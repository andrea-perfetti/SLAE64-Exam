########################################
# Filename: Encoder.py
# Author  : Andrea Perfetti
# SLAE ID : PA-29059
#:::::::::::::::::::::::::::::::::::::::
# USAGE
# Add your shellcode in the 'shellcode' variable following the example
# then run the script to get the encoded version,.
# Copy it into Decode-Skeleton.nasm and compile (using -N option in ld)
########################################

def last_flagged(seq):
    seq = iter(seq)
    a = next(seq)
    for b in seq:
        yield a, False
        a = b
    yield a, True 

import random

# Update here the shellcode to be encoded
shellcode = b'\x48\x31\xc0\xb0\x3c\x48\x31\xff\x48\x83\xc7\x0d\x0f\x05'


# Garbage and Terminator Bytes - do not change!
garbage = '0xFE'
terminator = '0xFF'

# Choosing the XOR Key
shellcode = bytearray(shellcode)

shellcode_int_array = []
for byte in shellcode:
	shellcode_int_array.append(int(byte))

possible_xor_keys = []
for i in range(1,255):
	if i not in shellcode_int_array:
		possible_xor_keys.append(i)

# If no candidates found, exiting	
if len(possible_xor_keys) == 0:
	print ('[!] No candidates found for XOR Key. Please check shellcode.')
	exit(1)

# Picking up a random Key
xor_key = random.choice(possible_xor_keys)

# Preparing space for the encoded string
encoded = ''

for op, is_last in last_flagged(shellcode):
	xored = op ^ xor_key
	encoded += hex(xored) + ','
	if is_last:
		encoded += terminator
	else:
		encoded += garbage + ','

print ("")
print ("Shellcode encoding utility")
print ("--------------------------------------------------")
print ("Encoding character: " + hex(xor_key))
print ("--------------------------------------------------")
print ("Encoded version:")
print (encoded)
print ("--------------------------------------------------")
