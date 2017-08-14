#!/usr/bin/env python3

from gattlib import GATTRequester

BOOST_handle=0x0e
RGBLED_WHITE=b'\x08\x00\x81\x32\x11\x51\x00\x0A'

req = GATTRequester("00:16:53:A4:CD:7E",True,"hci0")
req.write_by_handle(BOOST_handle, RGBLED_WHITE)
