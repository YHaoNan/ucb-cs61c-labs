# .import ./utils.s
.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)     # hold a0
    sw s1, 8(sp)     #      a1
    sw s2, 12(sp)     #      a2
    sw s3, 16(sp)    #      fd
    sw s4, 20(sp)    # row x col
    sw s5, 24(sp)    # return array address



    mv s0, a0
    mv s1, a1
    mv s2, a2

    # a1 is filepath and a2 is read-only
    mv a1, a0
    mv a2, zero
    call fopen # now a0 is file descriptor or zero
    blt a0, zero, fopenerr # if fopen return a NULL
    mv s3, a0  # s3 now is fd

    mv a1, s1 # move row pointer to a1, a0 is already the fd
    call read_num # now a0 is the row

    # move fd to a0, column pointer to a1
    mv a0, s3
    mv a1, s2
    call read_num # now a0 is the column

    lw t0, 0(s1)
    lw t1, 0(s2)

    mul s4, t0, t1   # we set rows x cols to s4
    slli s4, s4, 2   # we set s4 *= 4 because we wanna read word(integer)
    
    mv a0, s4
    call malloc
    beq a0, zero, mallocerr  # if malloc return zero, goto mallocerr

    mv s5, a0 # we set s5 to hold the return array
    # now we use s0 to save offset
    mv s0, zero

loop_start:
    beq s0, s4, loop_end # if offset == rows x cols
    
    #slli t0, s0, 2  # t0 = offset * 4
    add t0, s0, s5  # t0 = start + t0, it point to the address of current element

    mv a0, s3
    mv a1, t0
    call read_num

    addi s0, s0, 4

    j loop_start

loop_end:

    mv a1, s3
    call fclose
    blt a0, zero, fcloseerr

    mv a0, s5
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)     # hold a0
    lw s1, 8(sp)     #      a1
    lw s2, 12(sp)     #      a2
    lw s3, 16(sp)    #      fd
    lw s4, 20(sp)    # row
    lw s5, 24(sp)    # col
    addi sp, sp, 28

    ret

# read_num(fd, where to store)
read_num:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s4, 4(sp)

    mv t0, a1  
    mv a1, a0        # file descriptor
    mv a2, t0        # store to?
    addi a3, zero, 4 # we read 4 bytes

    call fread        # call fread

    addi t0, zero, 4  # if read byte is not 4, goto readerr

    lw ra, 0(sp)
    lw s4, 4(sp)
    addi sp, sp, 8

    addi t1, s0, 4
    beq t1, s4, return1
    bne a0, t0, readerr
    ret
return1:
    ret

mallocerr:
    li a1, 88
    call exit2

fopenerr:
    li a1, 89
    call exit2

fcloseerr:
    li a1, 90
    call exit2

readerr:
    li a1, 91
    call exit2
