___
# RV32IM Pipelined CPU Implementation
___
## Overview
An in-order 5-stage pipelined CPU which implements the RV32I base instruction set and the M instruction set extension for multiplication/division operations as per the RISC-V ISA specification.


## Testing

The unit tests for the hardware units can be launched by executing the following command from the `code/cpu` directory,

```
sh scripts/test_module.sh <module_name>
```

where `<module_name>` refers to the name of the module being tested (e.g. `alu`).