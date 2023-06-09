.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:
    # Error checks
    # to check height and width of these two matrix
    beq a1, zero, err
    blt a1, zero, err
    beq a2, zero, err
    blt a2, zero, err
    beq a4, zero, err
    blt a4, zero, err
    beq a5, zero, err
    blt a5, zero, err
    # to check first's width equal to second's height
    bne a2, a4, err

    # Prologue
    # s0 to s5 track a0 to a5
    # s6 track the offset of c
    # s7 to track of c's start address
    # s8 to start of first matrix
    # s9 to start of second matrix
    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5

    # ra, s0~s3 is callee saved register, we wanna use this, so we should save it before we use, and restore it before we return
    # we don't need restore it when we return back from other call, because the callee is response to restore it.
    # in the lab3, i don't really understand this so i wrote some confused code.

    # for caller saved register, if we use in function, we must save it before we call the other function
    # and we must restore it when function return

    mv s6, zero
    mv s7, a6
    mv s8, a0
    mv s9, a3
    

outer_loop_start:
    mul t0, s2, s4
    beq s6, t0, outer_loop_end

    mv a0, s8 # first matrix start
    mv a1, s9 # second matrix start
    mv a2, s2 # len is always first wight and second height
    addi a3, zero, 1 # strideA is 1
    mv a4, s2 # strideB is always first wight and second height
    jal ra dot

    slli t0, s6, 2 # s7 = offset * 4
    add t0, s7, t0 # s7 += start of c = the address of c's current element

    sw a0, 0(t0)

    addi s6, s6, 1

    rem t0, s6, s2 # if s6 % s2 == 0
    beq t0, zero, bigupdate
    
    addi s9, s9, 4

    j outer_loop_start

bigupdate:
    # start of A += (s6 % s2) * s2
    slli t0, s2, 2
    add s8, s8, t0

    # start of B += (s6 % s2)
    #slli t0, s2, 2
    sub s9, s9, t0
    addi s9, s9, 4
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 44
    ret


err:
    li a1, 59
    call exit2