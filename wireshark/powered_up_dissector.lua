-- Wireshark dissector for LEGO Powered Up devices
-- Copyright (C) 2018 David Lechner <david@lechnology.com>
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

-- Usage:
-- wireshark -X lua_script:powered_up_dissector.lua


---- Protocol: declare the names we will see in Wireshark ---

local powered_up_proto = Proto("LWP", "LEGO Powered Up Protocol")
powered_up_proto.fields.msg_len = ProtoField.uint8("powered_up.msg_len", "Message length", base.DEC)
powered_up_proto.fields.cmd = ProtoField.uint8("powered_up.cmd", "Command", base.HEX)
powered_up_proto.fields.subcmd = ProtoField.uint8("powered_up.subcmd", "Subcommand", base.HEX)
powered_up_proto.fields.action = ProtoField.uint8("powered_up.action", "Action", base.HEX)
powered_up_proto.fields.dev_info_dev_name = ProtoField.string("powered_up.dev_info.dev_name", "Device Name")
powered_up_proto.fields.dev_info_btn_state = ProtoField.int8("powered_up.dev_info.btn_state", "Button State", base.DEC)
powered_up_proto.fields.dev_info_fw_ver = ProtoField.string("powered_up.dev_info.fw_ver", "Firmware Version")
powered_up_proto.fields.dev_info_hw_ver = ProtoField.string("powered_up.dev_info.hw_ver", "Hardware Version")
powered_up_proto.fields.dev_info_rssi = ProtoField.int8("powered_up.dev_info.rssi", "RSSI", base.DEC)
powered_up_proto.fields.dev_info_batt_pct = ProtoField.int8("powered_up.dev_info.batt_pct", "Battery Percent", base.DEC)
powered_up_proto.fields.dev_info_unk7 = ProtoField.uint8("powered_up.dev_info.unk7", "Unknown", base.HEX)
powered_up_proto.fields.dev_info_mfg = ProtoField.string("powered_up.dev_info.mfg", "Manufacturer")
powered_up_proto.fields.dev_info_ble_stack = ProtoField.string("powered_up.dev_info.ble_stack", "BLE Stack")
powered_up_proto.fields.dev_info_unkA = ProtoField.uint16("powered_up.dev_info.unkA", "Unknown", base.HEX)
powered_up_proto.fields.dev_info_dev_id = ProtoField.uint8("powered_up.dev_info.dev_id", "Device ID", base.HEX)
powered_up_proto.fields.dev_info_unkC = ProtoField.uint8("powered_up.dev_info.unkC", "Unknown", base.HEX)
powered_up_proto.fields.dev_info_bd_addr = ProtoField.ether("powered_up.dev_info.bd_addr", "Bluetooth Address")
powered_up_proto.fields.dev_info_loader_bd_addr = ProtoField.ether("powered_up.dev_info.loader_bd_addr", "Bootloader Bluetooth Address")
powered_up_proto.fields.port_info_type = ProtoField.uint8("powered_up.port_info.type", "Port Info Type", base.HEX)
powered_up_proto.fields.port_info_type_id = ProtoField.uint8("powered_up.port_info.type_id", "Port Info Type ID", base.HEX)
powered_up_proto.fields.port_info_fw_ver = ProtoField.string("powered_up.port_info.fw_ver", "Firmware Version")
powered_up_proto.fields.port_info_hw_ver = ProtoField.string("powered_up.port_info.hw_ver", "Hardware Version")
powered_up_proto.fields.port_info_member = ProtoField.uint8("powered_up.port_info.member", "Member", base.HEX)


---- Enmerations: lookup tables for enum values ----

-- actions are used by device info (0x01) commands
local actions = {
    [0x01] = "Set Value",
    [0x02] = "Subscribe Value",
    [0x03] = "Unsubscribe Value",
    [0x04] = "Set Default Value",
    [0x05] = "Get Value",
    [0x06] = "Notification",
}

local device_ids = {
    [0x40] = "Move Hub",
    [0x41] = "Smart Hub",
    [0x42] = "Handset",
}

local port_ids = {
    [0x00] = "Port 0",
    [0x01] = "Port 1",
    [0x02] = "Port 2",
    [0x03] = "Port 3",
    [0x32] = "Port 50",
    [0x33] = "Port 51",
    [0x34] = "Port 52",
    [0x35] = "Port 53",
    [0x36] = "Port 54",
    [0x37] = "Port 55",
    [0x38] = "Port 56",
    [0x39] = "Port 57",
    [0x3A] = "Port 58",
    [0x3B] = "Port 59",
    [0x3C] = "Port 60",
}

local port_info_types = {
    [0x00] = "None",
    [0x01] = "Device",
    [0x02] = "Group",
}

local type_ids = {
    [0x00] = "None",
    [0x01] = "Medium Motor",
    [0x02] = "Train Motor",
    [0x08] = "Lights",
    [0x14] = "Hub Battery Voltage",
    [0x15] = "Hub Battery Current",
    [0x16] = "Hub Piezo Buzzer",
    [0x17] = "Hub Status Light",
    [0x22] = "WeDo 2.0 Tilt Sensor",
    [0x23] = "WeDo 2.0 Motion Sensor",
    [0x24] = "WeDo 2.0 Generic Sensor",
    [0x25] = "BOOST Color and Distance Sensor",
    [0x26] = "BOOST Interactive Motor",
    [0x27] = "BOOST Move Hub Built-in Motor",
    [0x28] = "BOOST Move Hub Built-in Tilt Sensor",
    [0x29] = "DUPLO Train Motor",
    [0x30] = "DUPLO Train Piezo Buzzer",
    [0x31] = "DUPLO Train Color Sensor",
    [0x32] = "DUPLO Train Speed",
    [0x37] = "Handset Button",
    [0x38] = "Handset ?",
}


---- Value parsers: parse single values and add them to the tree ----

-- parses a string
function parse_string(buffer, offset, subtree, field)
    local range = buffer(offset, buffer:len() - offset)
    local value = range:string()
    subtree:add_le(field, range, value)
end

-- parses a 1-byte signed integer
function parse_int8(buffer, offset, subtree, field)
    local range = buffer(offset, 1)
    local value = range:le_int()
    subtree:add_le(field, range, value)
end

-- parses a 1-byte unsigned integer
function parse_uint8(buffer, offset, subtree, field)
    local range = buffer(offset, 1)
    local value = range:le_uint()
    subtree:add_le(field, range, value)
end

-- parses a 2-byte unsigned integer
function parse_uint16(buffer, offset, subtree, field)
    local range = buffer(offset, 2)
    local value = range:le_uint()
    subtree:add_le(field, range, value)
end

-- parses a 4-byte version number and format's it using LEGO's weird 0.0.00.0000 format
function parse_version(buffer, offset, subtree, field)
    local bcd = buffer(offset + 3, 1):le_uint()
    local major = bit32.rshift(bcd, 4)
    local minor = bit32.band(bcd, 0xf)
    bcd = buffer(offset + 2, 1):le_uint()
    local bug_fix = bit32.rshift(bcd, 4) * 10 + bit32.band(bcd, 0xf)
    bcd = buffer(offset + 1, 1):le_uint()
    local build = bit32.rshift(bcd, 4) * 1000 + bit32.band(bcd, 0xf) * 100
    bcd = buffer(offset, 1):le_uint()
    build = build + bit32.rshift(bcd, 4) * 10 + bit32.band(bcd, 0xf)
    local value = string.format("%d.%d.%02d.%04d", major, minor, bug_fix, build)
    subtree:add_le(field, buffer(offset, 4), value)
end

-- parses a 6-byte Bluetooth address
function parse_bd_addr(buffer, offset, subtree, field)
    local range = buffer(offset, 6)
    local value = range:ether()
    subtree:add_le(field, range, value)
end

-- parses a 1-byte device id
function parse_dev_id(buffer, offset, subtree, field)
    local range = buffer(offset, 1)
    local value = range:le_int()
    local dev_id_tree = subtree:add_le(field, range, value)
    dev_id_tree:append_text(" (" .. device_ids[value] .. ")")
end

-- parses a 1-byte port id
function parse_port_id(buffer, offset, subtree, field)
    local range = buffer(offset, 1)
    local value = range:le_int()
    local port_id_tree = subtree:add_le(field, range, value)
    port_id_tree:append_text(" (" .. port_ids[value] .. ")")
end

-- parses a 1-byte type id
function parse_type_id(buffer, offset, subtree, field)
    local range = buffer(offset, 1)
    local value = range:le_int()
    local type_id_tree = subtree:add_le(field, range, value)
    type_id_tree:append_text(" (" .. type_ids[value] .. ")")
end


---- Message parsers: parse the data of specific message types ----

-- Parses a device info (0x01) message
function parse_dev_info(info, buffer, subtree)
    local action_range = buffer(4, 1)
    local action = action_range:le_uint()
    local action_tree = subtree:add_le(powered_up_proto.fields.action, action_range, action)
    local action_name = actions[action]
    action_tree:append_text(" (" .. action_name .. ")")

    if action == 6 then
        if info.parse_data then
            info.parse_notification(buffer, 5, subtree, info.value_field)
        end
    else
        if info.parse_write then
            info.parse_write(buffer, 5, subtree, info.value_field)
        end
    end
end

-- Parses a port info (0x04) message
function parse_port_info(info, buffer, subtree)
    local range = buffer(4, 1)
    local port_info_type = range:le_uint()
    local port_info_type_tree = subtree:add_le(powered_up_proto.fields.port_info_type, range, port_info_type)
    port_info_type_tree:append_text(" (" .. port_info_types[port_info_type] .. ")")

    parse_type_id(buffer, 5, subtree, powered_up_proto.fields.port_info_type_id)

    if port_info_type == 0x01 then
        if buffer(5, 1):le_uint() ~= 0 then
            -- TODO: what is offset 6?
            parse_version(buffer, 7, subtree, powered_up_proto.fields.port_info_fw_ver)
            parse_version(buffer, 11, subtree, powered_up_proto.fields.port_info_hw_ver)
        end
    elseif port_info_type == 0x02 then
        -- TODO: what is offset 6?
        parse_port_id(buffer, 7, subtree, powered_up_proto.fields.port_info_member)
        parse_port_id(buffer, 8, subtree, powered_up_proto.fields.port_info_member)
    end
end


---- Commands: table of possible commands and subcommands ----

-- generates a table containing subcommands for 0x04 command
function create_port_id_subcommands()
    local subcommands = {}
    for k, v in pairs(port_ids) do
        subcommands[k] = {
            name = v,
            parse_data = parse_port_info,
        }
    end
    return subcommands
end

local commands = {
    [0x01] = {
        name = "Device Info",
        subcommands = {
            [0x01] = {
                name = "Device Name",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_dev_name,
                parse_notification = parse_string,
            },
            [0x02] = {
                name = "Button State",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_btn_state,
                parse_notification = parse_uint8,
            },
            [0x03] = {
                name = "Firmware Version",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_fw_ver,
                parse_notification = parse_version,
            },
            [0x04] = {
                name = "Hardware Version",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_hw_ver,
                parse_notification = parse_version,
            },
            [0x05] = {
                name = "RSSI",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_rssi,
                parse_notification = parse_int8,
            },
            [0x06] = {
                name = "Battery Percent",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_batt_pct,
                parse_notification = parse_uint8,
            },
            [0x07] = {
                name = "Unknown",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_unk7,
                parse_notification = parse_uint8,
            },
            [0x08] = {
                name = "Manufacturer",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_mfg,
                parse_notification = parse_string,
            },
            [0x09] = {
                name = "BLE Stack",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_ble_stack,
                parse_notification = parse_string,
            },
            [0x0A] = {
                name = "Unknown",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_unkA,
                parse_notification = parse_uint16,
            },
            [0x0B] = {
                name = "Device ID",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_dev_id,
                parse_notification = parse_dev_id,
            },
            [0x0C] = {
                name = "Unknown",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_unkC,
                parse_notification = parse_uint8,
            },
            [0x0D] = {
                name = "Bluetooth Address",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_bd_addr,
                parse_notification = parse_bd_addr,
            },
            [0x0E] = {
                name = "Bootloader Bluetooth Address",
                parse_data = parse_dev_info,
                value_field = powered_up_proto.fields.dev_info_loader_bd_addr,
                parse_notification = parse_bd_addr,
            },
        },
    },
    [0x04] = {
        name = "Port Info",
        subcommands = create_port_id_subcommands(),
    },
}


---- Dissector: the entry point for the dissector ----

function powered_up_proto.dissector(buffer, pinfo, tree)
    info("buffer: " .. buffer())

    if buffer:len() == 0 then
        return
    end

    pinfo.cols.protocol = powered_up_proto.name
    -- TODO: could also set pinfo.cols.info

    local subtree = tree:add(powered_up_proto, buffer(), "Powered Up Message")

    local msg_len_range = buffer(0, 1)
    local msg_len = msg_len_range:le_uint()
    subtree:add_le(powered_up_proto.fields.msg_len, msg_len_range, msg_len)

    -- TODO: find out what byte at offset 1 does

    local cmd_range = buffer(2, 1)
    local cmd = cmd_range:le_uint()
    local cmd_tree = subtree:add_le(powered_up_proto.fields.cmd, cmd_range, cmd)
    local cmd_info = commands[cmd]
    cmd_tree:append_text(" (" .. cmd_info.name .. ")")

    local subcmd_range = buffer(3, 1)
    local subcmd = subcmd_range:le_uint()
    local subcmd_tree = subtree:add_le(powered_up_proto.fields.subcmd, subcmd_range, subcmd)
    local subcmd_info = cmd_info.subcommands[subcmd]
    subcmd_tree:append_text(" (" .. subcmd_info.name .. ")")

    if subcmd_info.parse_data then
        subcmd_info:parse_data(buffer, subtree)
    end
end

bluetooth_table = DissectorTable.get("bluetooth.uuid")
-- Powered Up LEGO characteristic UUID
bluetooth_table:add("00001624-1212-efde-1623-785feabcd123", powered_up_proto)
