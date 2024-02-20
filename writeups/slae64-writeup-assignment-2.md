---
title: SLAE64 - Assignment 2 - TCP Reverse Shell with passcode
date: 2021-04-04
tags:
- SLAE64
categories:
- SLAE Exam Assignments
- SLAE 64-bit
keywords:
    - Assembly
    - Reverse Shell
---
The second assigment for the SLAE64 certification asks to write a TCP Reverse Shell shellcode that connects to an address and a port and then executes a shell after verifying a "passcode" on successful connection. 
<!--more-->
For the basic structure of a Reverse Shell TCP, please refer to assignment 5 and to related assignment for the SLAE32 certification.

In order to verify the passcode, a code section has been added after the _dup2_ cycle, in order to perform a [_read_](https://man7.org/linux/man-pages/man2/read.2.html) syscall which puts the 8 bytes read on the stack and compares with the hardcoded passcode (_acceptme_).

If the comparison is successful, then the _execve_ is performed:
![Reverse TCP - Example with successful connection and passcode](/writeups/img/2-revtcp-correctpwd.png)

If the submitted passcode is wrong, the program exits with status code 6:
![Reverse TCP - Example with wrong passcode submitted](/writeups/img/2-revtcp-wrongpwd.png)

I have also added to the shellcode a check after the _connect()_ syscall: if the connection is not successful (e.g. due to wrong listener activated) then the program exits with status code 1:
![Reverse TCP - Example with unsuccessful connection](/writeups/img/2-revtcp-wronglistener.png)

## Customization Utility
In order for the reverse shell to be customizable, the `ReverseShell-Skeleton.nasm` file has been created with a placeholders to be filled with appropriate chosen ip and port (line 24).

Given that the bytes have to be inserted as XOR-ed with 0xFF, in order to avoid null ones, the `ReverseShell-Utility.py` comes handy as it just requires to be executed passing the IP and Port for the connection as parameters, and appropriate value will be calculated and presented to the user:
![Reverse TCP - Python utility](/writeups/img/2-revtcp-utility.png)

The following screenshot shows the shell to localhost on port 6969, for which the parameter has been generated with the Python utility:
![Reverse TCP - PoC of the Python utility on localhost:6969](/writeups/img/2-revtcp-utility-poc.png)

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