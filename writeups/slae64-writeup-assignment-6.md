---
title: SLAE64 - Assignment 6 - Polymorphism
date: 2021-04-10
tags:
- SLAE64
categories:
- SLAE Exam Assignments
- SLAE 64-bit
keywords:
    - Assembly
    - Polymorphism
---

The sixth assigment for the SLAE64 certification asks to select 3 shellcodes from [Shell-Storm](http://shell-storm.org/) and create a polymorphic version of them in order to beat pattern matching.
<!--more-->
The polymorphic version cannot be larger more than 150% of the original shellcode.

For each shellcode, the following steps have been followed:
* Download the shellcode to create `Original.nasm`
* Create polymorphic version `Polymorphic.nasm`
* Compile both to confirm that the behavior is the same

## execve()
The first shellcode I have selected is [Linux/x86_64 execve](http://shell-storm.org/shellcode/files/shellcode-603.php).

For the polymorphic version, I shuffled a bit the usage of RAX and RDX and changed a _mov_ operation with an _add_:
![](/writeups/img/6-1-diff.png)

As shown, the two shellcodes are working the same way:
![](/writeups/img/6-1-execve.png)

The original shellcode is 29 bytes long, the polymorphic version has 5 bytes more (118% of the original length).



## execveat()
The second shellcode I have selected is [execveat](http://shell-storm.org/shellcode/files/shellcode-905.php).

For the polymorphic version, I changed the initial setting of rax with the syscall number and transformed the final r8/r10 operations:
![](/writeups/img/6-2-diff.png)

As shown, the two shellcodes are working the same way:
![](/writeups/img/6-2-execveat.png)

The original shellcode is 28 bytes long, the polymorphic version has 1 byte more (104% of the original length).



## Add map in /etc/hosts
The third shellcode I have selected is [Add map in /etc/hosts file](http://shell-storm.org/shellcode/files/shellcode-896.php).

I have changed the registers used to push string on the stack and replaced some mov / add  instructions with equivalent add / inc.
![](/writeups/img/6-3-diff.png)

Here is the behavior of the original shellcode:
![](/writeups/img/6-3-hosts-original.png)

Here is the same behavior achieved with she polymorphic shellcode:
![](/writeups/img/6-3-hosts-polymorphic.png)

The original shellcode is 108 bytes long, the polymorphic version is **4 bytes shorter** (97% of the original length).

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