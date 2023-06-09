.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    # Prologue
    beq a1, zero, err
    blt a1, zero, err

    # we set t0 to the element offset, t1 to the element address
    mv t0, zero

    j loop_start

loop_start:
    beq t0, a1, loop_end  # if offset is reached to array length => goto loop_end;
    slli t1, t0, 2        # t1 = offset * 4
    add t1, t1, a0        # t1 = t1 + base address of array
    lw t2, 0(t1)          # t2 = *t1
    bgt t2, zero, loop_continue # if t2 > 0 goto loop_continue
    sw zero, 0(t1)              # set 0 to array

loop_continue:
    addi t0, t0, 1        # t0++
    j loop_start          # goto loop_start

loop_end:
	ret

err:
    li a1, 57
    call exit2