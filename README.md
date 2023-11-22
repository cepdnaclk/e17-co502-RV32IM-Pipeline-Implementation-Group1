___
# RV32IM Pipelined CPU Implementation
___
## Overview
An in-order 5-stage pipelined CPU which implements the RV32I base instruction set and the M instruction set extension for multiplication/division operations as per the RISC-V ISA specification.


## Environment Setup
_NOTE: The following instructions assume a Linux/WSLg environment._

1. Install the following prerequisites for compilation and simulation.

|  **Name**  |  **Version** |
|:----------:|:------------:|
| `iverilog` |   `>= 11.0`  |
|  `gtkwave` | `>= 3.3.104` |

```bash
sudo apt install -y iverilog gtkwave
```

2. Clone the repository
```bash
git clone https://github.com/cepdnaclk/e17-co502-RV32IM-Pipeline-Implementation-Group1.git
```

3. Test the hardware modules as shown in the next section.

## Testing

The unit tests for the hardware units can be launched by executing the following command from the `code/cpu` directory,

```bash
sh scripts/test_module.sh <module_name>
```

where `<module_name>` refers to the name of the module being tested (e.g. `alu`).