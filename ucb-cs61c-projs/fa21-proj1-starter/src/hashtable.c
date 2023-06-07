#include "hashtable.h"

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *)) {
  int i = 0;
  HashTable *newTable = malloc(sizeof(HashTable));
  if (NULL == newTable) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  newTable->size = size;
  newTable->buckets = malloc(sizeof(struct HashBucketEntry *) * size);
  if (NULL == newTable->buckets) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  for (i = 0; i < size; i++) {
    newTable->buckets[i] = NULL;
  }
  newTable->hashFunction = hashFunction;
  newTable->equalFunction = equalFunction;
  return newTable;
}

/* Task 1.2 */
void insertData(HashTable *table, void *key, void *data) {
  // 1. Find the right hash bucket location with table->hashFunction.
  unsigned int pos = table->hashFunction(key) % table->size;
  // 2. Allocate a new hash bucket entry struct.
  HashBucketEntry *ent = (HashBucketEntry*)malloc(sizeof(HashBucketEntry));
  ent->key = key;
  ent->data = data;
  // 3. Append to the linked list or create it if it does not yet exist. 
  ent->next = table->buckets[pos];
  table->buckets[pos] = ent;
  
  // [-] The code below is cool, but we wanna insert to head of the linkedlist, not the tail.
  // HashBucketEntry **head = &table->buckets[pos];
  // while (*head != NULL) head = &(*head)->next;
  // *head = ent;
}

/* Task 1.3 */
void *findData(HashTable *table, void *key) {
  // 1. Find the right hash bucket with table->hashFunction.
  unsigned int pos = table->hashFunction(key) % table->size;
  // 2. Walk the linked list and check for equality with table->equalFunction.
  HashBucketEntry *head = table->buckets[pos];
  while (head != NULL && table->equalFunction(key, head->key) == 0) {
    head = head->next;
  }
  return head == NULL ? NULL : head->data;
}

/* Task 2.1 */
unsigned int stringHash(void *s) {
  char *str = (char*)s;
  unsigned int hash = 0;
  while (*str!='\0') {
      hash+=*str;
      str++;
  }
  return hash;
}

/* Task 2.2 */
int stringEquals(void *s1, void *s2) {
  return !strcmp((char*)s1, (char*)s2);
}