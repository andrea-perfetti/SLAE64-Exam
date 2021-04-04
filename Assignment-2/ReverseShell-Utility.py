########################################
# Filename: ReverseShell-Utility.py
# Author  : Andrea Perfetti
# SLAE ID : PA-29059
#:::::::::::::::::::::::::::::::::::::::
# USAGE
# Invoke the script adding ip address and port number as arguments
########################################

import socket
import sys

if len(sys.argv) < 3:
    print ('Usage: python3 {utility} [ip_address] [port]'.format(utility = sys.argv[0]))
    exit(1)


ip = sys.argv[1]
ip_split = ip.split('.')
ip_string = '{b4}{b3}{b2}{b1}'.format( \
	b1 = format((int(ip_split[0]) ^ 0xFF), '02x'), \
	b2 = format((int(ip_split[1]) ^ 0xFF), '02x'), \
	b3 = format((int(ip_split[2]) ^ 0xFF), '02x'), \
	b4 = format((int(ip_split[3]) ^ 0xFF), '02x'), \
	)

port = int(sys.argv[2])
port = hex(socket.htons(port ^ 0xFFFF))
port_string = '{b1}{b2}'.format(b1 = port[2:4], b2 = port[4:6])

afinet_string = '{af}'.format(af = (hex(0x0002 ^ 0xFFFF))[2:6])


shellcode_string = '0x{ip}{port}{afinet}'.format(ip=ip_string, port=port_string, afinet=afinet_string)

print ("Please insert the following string into the shellcode, \nreplacing the '<CONNECT_PLACEHOLDER>' placeholder at line 24")
print (shellcode_string)
