---
title: SLAE64 - Assignment 4 - Encoder
date: 2021-04-11
tags:
- SLAE64
categories:
- SLAE Exam Assignments
- SLAE 64-bit
keywords:
    - Assembly
    - Encoder
---


The fourth assigment for the SLAE64 certification asks to create a custom encoding scheme like the "Insertion Encoder" that has been presented in the course. A PoC is also requested, using _execve-stack_ shellcode.
<!--more-->
## The encoding schema
I have decided to go for a mix of the Insertion Encoder and XOR encoder.

Each byte of the shellcode is XOR-ed with a variable key, and after the a garbage `\xFE` byte is added. After the last byte of the actual shellcode, `\xFF` is inserted as a termination mark.

![Encoding Schema](/writeups/img/4-encoding-schema.png)

## The encoder
The encoding utility `Encoder.py` has been written in Python3. The first step of the utility is to select the XOR key; it is done by searching for non-used bytes in the actual shellcode, avoiding 0xFF and 0x00.

After the encoding process, the script is printing on the screen the XOR key and the encoded shellcode; both need to be inserted into `Decoder-Skeleton.nasm` replacing the placeholders.

For this first example, I have used a simple shellcode (placed under _Shellcode-Test_) which just performs an `exit(13)`.
![Encoder Utility](/writeups/img/4-encoder-utility.png)

## The decoder skeleton
The decoding skeleton adopts the JMP-CALL-POP technique to get the address of the actual payload in memory.

The registers are being used according to the following schema:
| Register | Usage |
|:--------:|-------|
| RSI      | Used to store the start address of the string in memory |
| RDX      | Offset to the byte being rewritten in memory with the _actual_ shellcode |
| RCX      | Offset to the byte being scanned (both shellcode and garbage) |

After the loop completes, the "Execute" section adds a final \x90 (NOP) to the actual shellcode in memory and then performs a jump to the shellcode address (stored in RSI).

![Decoder Demo](/writeups/img/4-decoder-poc.png)

## PoC with Execve-Stack
As requested, the shellcode for _Execve-Stack_ has been used for an additional PoC; all files are stored under 'PoC-Execve-Stack' directory.

Compiling and executing the original shellcode:
![Poc Execve-Stack - Original shellcode](/writeups/img/4-poc-execve-originalshellcode.png)

The encoding of the shellcode:
![Poc Execve-Stack - Encoding](/writeups/img/4-poc-execve-encoder.png)

The decoder nasm file has been prepared, compiled and debugged.

Just before the `JMP RSI` instruction, which actually passes the control to the decoded shellcode in memory, this is the content of the RSI register:
![Poc Execve-Stack - ](/writeups/img/4-poc-execve-jmprsi.png)

Comparing the content of the stack with the original shellcode, we can see that the two are the same, thus the decoding happened successfully:
![Poc Execve-Stack - ](/writeups/img/4-poc-execve-stackcontent.png)


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