.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    addi sp, sp, -8 # we want use s0 and call factorial recursivly. so we need 2 stack slot to save these register.
    sw ra, 0(sp)
    mv s0, a0       # now s0 is a0
    sw s0, 4(sp)
    beq a0, x0, done # if factorial(0) goto done;
    addi a0, a0, -1  # a0--;
    jal ra, factorial # factorial(a0)
    lw s0, 4(sp)    # restore s0 and ra
    lw ra, 0(sp)   
    mul a0, a0, s0  # n = s0 * factorial(s0-1)
    addi sp, sp, 8  # restore stack pointer
    ret
done:
    addi a0, x0, 1 # when we reach 0, return 1
    addi sp, sp, 8 # restore stack pointer
    ret
