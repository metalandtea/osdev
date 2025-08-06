# Text Driver

## Functions

### clearScreen
Clears the screen, starting from text mem 0xb8000 and writing 2000 words. Retains color of screen based on memory location 'terminal_color.'

#### in:
#### out:
#### scratch: 
ax <- 0x0 | terminal_color
ecx <- 2000 (MEM_VID_TEXT_SIZE)

### putc x, y, char
Puts a character to video memory.

#### in:
stack <- x value of cursor

stack <- y value of cursor

stack <- character to print

#### out:
#### scratch:

ax <- 0x0 | terminal_color

eax <- ax | (GARBAGE)

ecx <- the absolute cursor position

### puts x, y, source, size
Puts a string to video memory.

#### in:
stack <- x value of cursor start

stack <- y value of cursor start

stack <- address of string

stack <- size of string (in bytes)