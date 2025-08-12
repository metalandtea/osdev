# serialdriver.asm
## Basic information
### Synopsis
The Serial Driver is used to write to the COM1 port of the machine, located at address `0x3F8`. It does not support read functions, as it is used with the Qemu `-serial` flag. It is purely used for debugging purposes.
### General Details
- Operating mode: Protected Mode
- Ring Access: Ring 0
- Interrupt number: 0x20
### Relevant Details
- UART type assumed: 16550
- Baud Rate is 9600 assuming 115200 is div 1

| Property | Value |
|-|-|
| Divisor | 12 |
| Payload size | 8 bits |
| Parity | None |
| FIFO | Enabled (14 Bytes) |
| IRQ | Enabled |
| RTS/DSR | Set |
| Mode | Standard |

### Dependencies
Dependent on IDT to function correctly, as it is an interrupt.

## Entry
### Initialization
To start, there must be a valid IDT entry for the entry at gate `0x20`. You can do this with `setEntryOffset 0x20, serial_entry` in the kernel. (Later the kernel will do it automatically)

Before COM1 can be used, it must be initialized in the kernel with `int 0x20` with `ah == 0`, the serial interrupt to initialize the port.

### Interrupts
#### serialStart `ah == 0x00`
Initializes the COM1 port to the specifications provided in the **Relevant Details** section. If it does not configure succesfully, hangs.

in: (None)

out: (None)
#### serialPutC `ah == 0x01`
Writes a character to the COM1 port.

in:
- al | character to write

out: (None)

#### serialWrite `ah == 0x02`
Writes a null terminated string to the COM1 port.

in:
- esi -> source address
out: (None)

## Quirks
None as of this moment

## Final Notes
I'll check and sanitize stuff at some point