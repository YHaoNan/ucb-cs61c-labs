Open the files ex2.c and ex2.s. The assembly code provided (.s file) is a translation of the given C program into RISC-V.

In addition to opening a file in the "Editor" tab and then running in the "Simulator" tab as described above, you can also run ex2.s directly within the Venus terminal by cding into the appropriate folder, then running run ex2.s or ./ex2.s. Typing vdb ex2.s will also assemble the file and take you to the "Simulator" tab directly.


Find and identify the following components of this assembly file, and be able to explain how they work.

---

The register representing the variable `k`.

变量k在汇编代码中由t0持有，下面是大部分寄存器持有值于C语言中的概念的对应

- s1: source address
- s2: dest address
- t0: k (loop condition)
- s3: current offset of source array
- t1: s1 + s3 (the address of current element of source array)
- t2: current element of source array
- a0: argument to func

> t2 = a0

- t3: s2 + s3 (the address of current element of dest array)

> t2 = t3

- s0: sum

---

The register representing the variable `sum`.

s0

---

The registers acting as pointers to the `source` and `dest` arrays.

s1对应source，s2对应dest

---

The assembly code for the loop found in the C code.

标签loop是循环的开始，`jal x0 loop`是无条件跳转回循环的代码，在循环开始处，`beq t2, x0, exit`校验了当前source中的数字是否是0，如果是就跳转到exit。

---

How the pointers are manipulated in the assembly code.

t0保存了当前的循环变量，通过`slli s3, t0, 2`将t0中的循环变量左移2，也就是乘以4，算得整型数组中第k个元素的下标地址，再加上数组的基址就OK了。