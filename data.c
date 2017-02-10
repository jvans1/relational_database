#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#define MAX_ROWS 1000000
/* collection, */
  /* content_type, */
  /* document_creation_date, */
  /* document_number, */
  /* document_page_count, */
  /* document_release_date, */
  /* document_type, */
  /* file, */
  /* more1_link, */
  /* more1_title, */
  /* more2_link, */
  /* more2_title, */
  /* more3_link, */
  /* more3_title, */
  /* more4_link, */
  /* more4_title, */
  /* more5_link, */
  /* more5_title, */
  /* publication_date, */
  /* release_decision, */
  /* sequence_number, */
  /* title, */
  /* url */
struct row {
  char *publication_date;
  char *title;
  char *url;
};

int main ()
{

  const char *file_names[] = {
    "cia-crest-files-cia-crest-archive-metadata/1_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/2_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/3_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/4_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/5_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/6_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/7_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/8_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/9_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/10_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/11_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/12_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/13_export.csv",
    "cia-crest-files-cia-crest-archive-metadata/14_export.csv"
  };

  FILE *file;
  char *line = NULL;
  size_t size = 0;
  const char *mode =  "r";
  char *token;
  const char *delim = ",";
  struct row *row;
  char *temp_row[60];
  struct row *rows[MAX_ROWS];
  int row_count = 0;


  for(int i = 0; i < 14; i++){
    file = fopen(file_names[i], mode);
    assert(file != NULL);
    while(getline(&line, &size, file) != -1){
      token = strtok(line, delim);
      int index = 0;
      while(token != NULL ){
        temp_row[index] = token;
        token = strtok(NULL, delim);
        index++;
      }
      row = malloc(sizeof(struct row));
      row->title = temp_row[21];
      row->url = temp_row[22];
      row->publication_date = temp_row[18];
      rows[row_count] = row;
      row_count++;
    }
  }
}
