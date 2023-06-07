/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philphix.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
#ifndef _PHILPHIX_UNITTEST
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 1;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(0x61C, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}
#endif /* _PHILPHIX_UNITTEST */

// 救命！！！Project1的代码怎么能写好看？？
// 注意缓冲区溢出，有时候strncpy很有效（比如字符串没有终止符时）
/* Task 3 */
void readDictionary(char *dictName) {
  FILE *fp = fopen(dictName, "r+");
  if (!fp) {
    fprintf(stderr, "Cannot open file");
    exit(61);
  }

  char c;
  int wsz = 100;
  char *word = malloc(wsz);
  char *key = NULL;
  char *data = NULL;
  int len = 0;
  while (1) {
    c = getc(fp);

    if (c == ' ' || c == '\t' || c == '\n' || c == EOF) {
      if (!key && c == EOF) break;
      if (!key && len > 0) {
        key = malloc(len+1);
        strncpy(key, word, len);
        key[len] = 0;
        word = realloc(word, wsz);
        len = 0;
      } else if (!data && len > 0) {
        data = malloc(len+1);
        strncpy(data, word, len);
        data[len] = 0;

        insertData(dictionary, key, data);

        if (c == EOF) {
          break;
        }

        data = NULL;
        key = NULL;
        len = 0;
        wsz = 100;
        word = realloc(word, wsz);
      } 
    } else {
      if (len >= wsz) {
        wsz *= 2;
        word = realloc(word, wsz);
      }
      word[len] = c;
      len++;
    }
  }

  free(word);
  fclose(fp);
}


/* Task 4 */
void processInput() {
  char c;
  char *word = malloc(100);
  int len = 0, wsz = 100;
  while (1) {
    c = getchar();
    if (c == EOF && len == 0) break;
    if (!isalnum(c) && len != 0) {
      word[len] = '\0';
      char *tmp = malloc(len+1);
      char *data = findData(dictionary, word);
      if (!data) {
        tmp[0] = word[0];
        for (int i=1; i<len; i++) {
          tmp[i] = tolower(word[i]);
        }
        data = findData(dictionary, tmp);
      }
      tmp[len] = '\0';
      if (!data) {
        tmp[0] = tolower(word[0]);
        data = findData(dictionary, tmp);
      }

      if (data) {
        fprintf(stdout, "%s", data);
      } else {
        fprintf(stdout, "%s", word);
      }
      word = realloc(word, 100);
      len = 0;
      wsz = 100;
      free(tmp);
      if (c==EOF) break;
    }
    if (!isalnum(c)) {
      putchar(c);
    } else {
      if (len >= wsz) {
        wsz *= 2;
        word = realloc(word, wsz);
      }
      word[len++] = c;
    }
  }

  free(word);
}
