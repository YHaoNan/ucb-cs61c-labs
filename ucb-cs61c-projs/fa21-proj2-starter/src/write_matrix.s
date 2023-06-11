.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3


    # a1 is filepath and a2 is write-only
    mv a1, a0
    addi a2, zero, 1
    call fopen # now a0 is file descriptor or zero
    blt a0, zero, fopenerr # if fopen return a NULL
    mv s4, a0  # s4 now is fd


    # write row and column
    sw s2, 24(sp)
    addi a1, sp, 24
    addi a2, zero, 1
    call write_number
    sw s3, 24(sp)
    mv a0, s4
    addi a1, sp, 24
    addi a2, zero, 1
    call write_number

    mv a0, s4
    mv a1, s1
    mul a2, s2, s3 # s3 = row x column

    call write_number

    mv a1, s4
    call fclose
    blt a0, zero, fcloseerr

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 28
    ret


# write a number to file
# write_number(fd, array, length):
write_number:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    
    mv s0, a2
    
    mv t0, a0
    mv t1, a1
    mv t2, a2

    mv a1, t0
    mv a2, t1
    mv a3, t2
    addi a4, zero, 4

    call fwrite

    bne a0, s0, fwriteerr

    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8

    ret

fopenerr:
    li a1, 89
    call exit2

fcloseerr:
    li a1, 90
    call exit2

fwriteerr:
    li a1, 92
    call exit2