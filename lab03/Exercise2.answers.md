Open ex1.s in Venus and answers the following questions. Some of the questions will require you to run the RISC-V code using Venus's simulator tab.

As with the last lab, since we're not autograding these answers, we've once again provided answers to some of these questions so you can verify your understanding.

--- 

What do the .data, .word, .text directives mean (i.e. what do you use them for)? Hint: think about the 4 sections of memory.

> `.data`用于向程序的数据段中保存数据

> `.text`用于向程序的文本段中保存数据（指令也是数据，它们都是binary，看你如何解释它们）

> `.word`用于声明一个32bit数据（至少在rv32中）？

---

Run the program to completion. What number did the program output? What does this number represent?

34，这应该是斐波那契数列的第九个数字（如果0算第一个的话xD）

---

At what address is n stored in memory? Hint: Look at the contents of the registers.

在`0x10000010`，除了看寄存器t3的位置，也可以从Memory中直接找到。

值得一提的是，汇编代码中使用了这条清晰简单的语句加载n的地址到t3：
```asm
la t3, n
```

但实际上，rv32中并没有la指令，这是一个assembler pesudo instruction（汇编器伪指令），它会被实际翻译成两条真正的rv32机器指令：

```asm
# 我们仍使用寄存器的ABI name
auipc t3, 65536  # pc 0x8
addi t3, t3, 8   # pc 0xc
```

第一条指令将立即数65536左移12位并与当前pc相加，也就是`hex((65536<<12)+0x8)=0x10000008`，第二条指令将立即数8加到t3上，也就是`0x10000010`。

---

Without actually editing the code (i.e. without going into the "Editor" tab), have the program calculate the 13th fib number (0-indexed) by manually modifying the value of a register. You may find it helpful to first step through the code. If you prefer to look at decimal values, change the "Display Settings" option at the bottom.

t3保存的是我们要找数列的第几个，我们只需要将t3改成13即可（注意要在decimal模式下更改，如果是hex模式，请改成0xd）

