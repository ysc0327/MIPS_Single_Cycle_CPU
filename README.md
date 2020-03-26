# MIPS_Pipelined-CPU
Goal : Implementation of MIPS Pipelined 32-bit CPU using verilog.
=====================================================
This is NCKU Computer Architecture and IC design LAB course project. 
=====================================================


The project is Single cycle CPU.

I have written a insertion sort assembly code, and test in my Single cycle CPU.
The testbench I think have some error, because "memory needs 8 bits width in each address", so I have modified some part of testbench.

Implenment 23 instrucetion, contain :

  Rtype :         Itype:         Jtype:    
    nop             addi           j 
    add             andi           jalr
    sub             slti
    and             beq
    or              bne
    xor             lw
    nor             lh
    slt             sw
    sll             sh
    srl
    jr
    jalr
    
If you have some questions or suggestion, please contact to me. Thanks!
    
