########################################
# Filename: BindShell-Utility.py
# Author  : Andrea Perfetti
# SLAE ID : PA-29059
#:::::::::::::::::::::::::::::::::::::::
# USAGE
# Invoke the script adding port number as argument
########################################

import socket
import sys

if len(sys.argv) < 2:
    print ('Usage: python3 {utility} [port]'.format(utility = sys.argv[0]))
    exit(1)



port = int(sys.argv[1])
port = hex(socket.htons(port ^ 0xFFFF))
port_string = '{b1}{b2}'.format(b1 = port[2:4], b2 = port[4:6])

afinet_string = '{af}'.format(af = (hex(0x0002 ^ 0xFFFF))[2:6])


shellcode_string = '0x{port}{afinet}'.format(port=port_string, afinet=afinet_string)

print ("Please insert the following string into the shellcode, \nreplacing the '<BIND_PLACEHOLDER>' placeholder at line 23")
print (shellcode_string)
