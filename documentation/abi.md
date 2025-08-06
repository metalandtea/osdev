# ABI
Note: I will add more stuff to it as I flesh out my ABI

## Overview
Stack Size: 0x4000
Stack Top: 0x90000

Stack Element Size: 4 bytes
Stack Size(in elements): 1000

Preserved Registers:
- ebx
- esi
- edi
- ebp

Scratch Registers:
- eax
- ecx
- edx

## Stack Behavior
The stack pushes arguments left to right, then pushes the instruction pointer and the base pointer, setting the new base pointer.

At the end of the functions, the stack pops eip, ebp then pops every argument with ret n (similar to Microsoft ABI).

routines and subroutines for the kernel start with a lowercase letter (ex: myRoutine) These should only ever be exposed to the kernel. User functions will always be set up to use the stack, and are displayed with a capital first letter in code (ex MyUserRoutine). Userland code should be sanitized and checked, and should not be trusted (though I'm not sure if I'm going to be doing much userland code right now, haha).

kernel routines will avoid the stack (beyond preserving registers through SFRAME and SFRAME_END) unless necessary, in the case of which thorough documentation should be provided.

Note: Kernel routines must still preserve the preserved registers, but they do not have to follow the argument behavior provided. Registers can be direcly written to and used without reading first from the stack.

## Returns for registers

Where applicable, these registers should handle each type of return value:

error flag -> al (0 on success, # for error)

