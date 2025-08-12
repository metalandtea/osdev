# Interrupts
## Basic Information
The interrupts follow the process of `/interrupts/DIAG-implem`. To put into words, the process calls `int <num>`, which starts the interrupt. Then, it is passed to a wrapper corresponding with the interrupt. That wrapper is the entry that then handles which stub is used based on the `ah` register.
### Registers
There is an expected input and output for the interrupts, and they should be followed unless there is a reason they can't, in which case the documentation should be thorough. Of course, they should only be used where each function requires them.

#### Input
|Register|Use
|-|-
| `ah` | interrupt stub to run
| `(e)cx` | counter
| `edx`, `ebx` | arguments
| `esi` | source register / string in
| `edi` | destination / string out

#### Output
|Register|Use
|-|-
| `al` | error code
| `ah` | error flags / error info
| `ecx`| count return
| `edx`, `ebx`| general purpose return values

The stack can also be used, but should be avoided if possible as it complicated and slows down the stubs. Most interrupts won't need the stack as they should be relatively primitive.

### List of Interrupts
- `0x00-0x1F`: (reserved by Intel)
- `0x20`: serialdriver (and debugger)
- `0x21`: manicpanic (fault and error handler)
- `0x22`: textdriver
- `0x23`: keyboarddriver