---
title: SLAE64 - Assignment 7 - Crypter
date: 2021-04-11
tags:
- SLAE64
categories:
- SLAE Exam Assignments
- SLAE 64-bit
keywords:
    - Assembly
    - Encrypter
    - Fernet
---

The seventh assignment for the SLAE64 certification asks to create a custom crypter like the one shown in the "Crypters" video. You are free to use any existing encryption schema and any programming language.
<!--more-->
I have used the same encryption scheme and encrypt tool built for the SLAE32 certification.

## Encrypter
The encrypter tool: 
* takes the shellcode to be encrypted from the _shellcode_ variable
* creates a salt taking 16 random characters from digits and ascii_uppercase
* asks the user for the encryption password
* performs the encryption process
* prints on screen the different components:
  * chosen password in plaintext
  * random salt computed
  * encrypted payload, which is a string obtained by concatenating:
    * the random salt
    * the shellcode encrypted with Fernet

![Encrypt tool](/writeups/img/7-encrypt.png)

The _encrypted payload_ must be copied into the Decrypt-Exec utility.

## Decrypter
The decryption-exec tool:
* takes the encrypted string generated with previous tool from the *encrypted_payload* variable and then splits it into the two different components:
  * the salt (first 16 characters)
  * the cipher_text (other characters)
* asks the user for the password (which has to be the same used for the encryption, of course)
* builds the _key derivation function_ using the salt, with same algorithm used in the encryption
* performs the decryption, thus having the original shellcode into *shellcode_data* variable
* puts the shellcode in memory and cast it to *shellcode_function* function, for which the memory buffer has been set with Read, Write and Execute flags
* executes the shellcode

![Decrypt-Exec tool](/writeups/img/7-decryptexec.png)


## PoC
The screenshots presented above are taken from the tool published in the GitHub repo, which is itself a PoC with an 'execve' shellcode, which executes `/bin/sh`.



<!-- SLAE64 Disclaimer -->
_________________
This blog post has been created for completing the requirements of the SecurityTube Linux Assembly Expert certification: [http://www.securitytube-training.com/online-courses/x8664-assembly-and-shellcoding-on-linux/index.html](http://www.securitytube-training.com/online-courses/x8664-assembly-and-shellcoding-on-linux/index.html).

**Student ID**: `PA-29059`  
**GitHub repository**: [https://github.com/andrea-perfetti/SLAE64-Exam](https://github.com/andrea-perfetti/SLAE64-Exam)



This assignment has been written on a Kali Linux 2021.1 64-bit virtual machine:
```
┌──(kali㉿kali)-[~]
└─$ uname -a
Linux kali 5.10.0-kali3-amd64 #1 SMP Debian 5.10.13-1kali1 (2021-02-08) x86_64 GNU/Linux
```