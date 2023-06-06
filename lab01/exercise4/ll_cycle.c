#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    if (head==NULL) return 0;
    node *fp = head, *sp = head;

    do {
        if (fp->next == NULL) return 0;
        fp = fp->next->next;
        sp = sp->next;
    } while (fp != sp && fp != NULL && sp != NULL);

    return fp == sp;
}
