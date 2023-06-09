.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:
    beq a1, zero, err
    blt a1, zero, err

    # we need t3 to save max, t4 to max offset
    #   t0 to save current offset,
    #   t1 to save current element address,
    #   t2 to save current element

    lw t3, 0(a0)  # t3 = array[0]
    mv t4 zero
    addi t0, zero, 1 # t0 = 1

    j loop_start


loop_start:
    beq t0, a1, loop_end  # if offset is reached to array length => goto loop_end;
    slli t1, t0, 2        # t1 = offset * 4
    add t1, t1, a0        # t1 = t1 + base address of array
    lw t2, 0(t1)          # t2 = *t1
    bgt t3, t2, loop_continue  # if t2<t3 goto loop_continue
    beq t3, t2, loop_continue  # if t2==t3 goto loop_continue
    mv t3, t2                  # else (t2>t3) t3=t2
    mv t4, t0                  # t4=offset

loop_continue:
    addi t0, t0, 1        # t0++
    j loop_start          # goto loop_start

loop_end:
    mv a0, t4
    ret

err:
    li a1, 57
    call exit2