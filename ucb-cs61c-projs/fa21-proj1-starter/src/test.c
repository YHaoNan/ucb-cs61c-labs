#include "hashtable.h"
#include <stdio.h>
#include <string.h>
#include <assert.h>

#define SIZE 41

int main() {
    HashTable *t = createHashTable(SIZE, stringHash, stringEquals);
    insertData(t, "0", "1230120");
    insertData(t, "19", "0150120");
    insertData(t, "Find", "Zindex");
    assert(strcmp(findData(t, "0"), "1230120") == 0);
    assert(strcmp(findData(t, "19"), "0150120") == 0);
    assert(strcmp(findData(t, "Find"), "Zindex") == 0);
}