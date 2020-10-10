# README #

Daniel Ramirez's extra legit ARM assembly code.
Much of this was written with a keen eye towards the example code written by Christopher D. McMurrough which can be found [here](https://github.com/cmcmurrough/cse2312).

### What is this repository for? ###

This repository exists to archive the programs I have written in ARM assembly as well as some information about the conditions under which this code was written.
The inspiration for these projects was a class on computer organization CSE 2312 that I took during fall of 2017. In particular all of the code in this repository was written between November 11th and December 6th of 2017. This code was originally version controlled using a private repository on BitBucket for two reasons. For one it was an assignment so I need BitBucket's free private repository, and I needed to host it online at all because I had to work with a headless ARM virtual machine (qemu). 

My workflow consisted of writing the code within a virtual machine running LUbuntu/Linux (personal choice), pushing the code to BitBucket, pulling it to the qemu, running it, and then circling back to the LUbuntu/Linux VM once again. The actual installation of Windows 10 I was using at the time essentially functioned as a hypervisor. As well this led to there being far more commits than what is normally required for a group of projects such as this. So the commit messages quickly devolved into nonsense that I smashed into the keyboard to get the code running in qemu sooner. I have dutifully rebase'd the repository such that the commit messages are more semantically meaningful.

Hopefully the story was amusing because I don't think code itself will be that useful.

### How do I get set up? ###

Run on motherboard or virtual machine with ARM ISA
Use these commands in the bash terminal

```$ as -o program.o program.s```

```$ gcc -o program program.o```

Both ```as``` and ```gcc``` are necessary as there are some standard C library functions called with the code.

### Contribution guidelines ###

Somewhat null as the projects are over.

### Who do I talk to? ###

me, coffee-dan
