.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # addi t0, zero, 4
    addi t0, zero, 1
    bne a0, t0, cmdlineerr

    addi sp, sp, -68
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 44(sp)
    sw s5, 48(sp)
    sw s6, 52(sp)
    sw s7, 56(sp)
    sw s8, 60(sp)
    sw s9, 64(sp)
    mv s9, a2



    #sw s4, 20(sp) 
    #sw s5, 24(sp) 
    #sw s6, 28(sp) 
    #sw s7, 32(sp) 


    lw s0, 0(a1)    # s0 is m0's path
    lw s1, 4(a1)    # m1's path
    lw s2, 8(a1)    # input's path
    lw s3, 12(a1)   # output's path

    mv a0, s0
    addi a1, sp, 20  # we save m0's row to 20(sp)
    addi a2, sp, 24  # we save m0's column to 24(sp)
    call read_matrix
    mv s4, a0 # s4 == m0

    mv a0, s1
    addi a1, sp, 28  # we save m1's row to 28(sp)
    addi a2, sp, 32  # we save m1's column to 32(sp)
    call read_matrix
    mv s5, a0 # s5 == m1

    mv a0, s2
    addi a1, sp, 36  # we save input's row to 36(sp)
    addi a2, sp, 40  # we save input's column to 40(sp)
    call read_matrix
    mv s6, a0 # s6 == input


    lw t0, 24(sp)   # a0 = m0's column * input's row * 4, malloc(a0)
    lw t1, 36(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    call malloc
    beq a0, zero, mallocerr
    mv s7, a0      # s7 == h

    mv a6, a0
    mv a0, s4
    lw a1, 20(sp)
    lw a2, 24(sp)
    mv a3, s6
    lw a4, 36(sp)
    lw a5, 40(sp)
    call matmul


    lw t0, 24(sp)
    lw t1, 36(sp)
    mv a0, s7
    mul a1, t0, t1
    call relu


    lw t0, 32(sp)   # a0 = m1's column * h's row(m0's column) * 4, malloc(a0)
    lw t1, 24(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    call malloc
    beq a0, zero, mallocerr
    mv s8, a0      # s8 == output

    mv a6, a0
    mv a0, s5
    lw a1, 28(sp)
    lw a2, 32(sp)
    mv a3, s7
    lw a4, 32(sp)
    lw a5, 40(sp)
    call matmul

    mv a0, s3
    mv a1, s8
    lw a2, 32(sp)
    lw a3, 24(sp)
    call write_matrix

    mv a0, s8
    lw t0, 32(sp)
    lw t1, 24(sp)
    mul a1, t0, t1
    call argmax
    
    mv s0, a0

    bne s9, zero, end

    mv a1, a0
    call print_int

    addi a1, zero, 10
    call print_char


end:
    mv a0, s0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 44(sp)
    lw s5, 48(sp)
    lw s6, 52(sp)
    lw s7, 56(sp)
    lw s8, 60(sp)
    lw s9, 64(sp)
    addi sp, sp, 68

    ret

cmdlineerr:
    li a1, 72
    call exit2

mallocerr:
    li a1, 88
    call exit2