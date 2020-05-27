# disasm2

You can't access it directly because there's no legitimate use case. Having any arbitrary instruction change eip would make branch prediction very difficult, and would probably open up a whole host of security issues.

You can edit eip using jmp, call or ret. You just can't directly read from or write to eip using normal operations

Setting eip to a register is as simple as jmp eax. You can also do push eax; ret, which pushes the value of eax to the stack and then returns (i.e. pops and jumps). The third option is call eax which does a call to the address in eax.

Reading can be done like this:

```
call get_eip
  get_eip:
pop eax ; eax now contains the address of this instruction
```