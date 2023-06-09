.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:

    # Prologue
    beq a3, zero, strideerr
    blt a3, zero, strideerr
    beq a4, zero, strideerr
    blt a4, zero, strideerr
    blt a2, zero, lengtherr
    beq a2, zero, lengtherr


    mv t0, zero   # t0=0
    mv t5, zero   # t5=0
    # t5 to hold result
    #   t0 to save current offset
    #   t1 to save current v0 element address,
    #   t2 to save current v0 element
    #   t3 to save current v1 element address
    #   t4 to save current v1 element
    j loop_start
loop_start:
    beq a2, t0, loop_end
    # t1 = offset * stride1 * 4 
    mul t1, t0, a3
    slli t1, t1, 2
    add t1, t1, a0
    # t2 = *t1
    lw t2, 0(t1)
    # t3 = offset * stride2 * 4
    mul t3, t0, a4
    slli t3, t3, 2
    add t3, t3, a1
    # t4 = *t3
    lw t4, 0(t3)

    # t2 = t2 * t4
    mul t2, t2, t4
    # t5 += t2
    add t5, t5, t2

    # t0++
    addi t0, t0, 1
    j loop_start

loop_end:
    mv a0, t5
    ret

lengtherr:
    li a1, 57
    call exit2

strideerr:
    li a1, 58
    call exit2