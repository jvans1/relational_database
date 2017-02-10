#include <stdio.h>
#include <string.h>
#include <stdlib.h>
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

  char *line = NULL;
  size_t size = 0;
  FILE *file;
  const char *mode =  "r";
  char *token;
  const char *delim = ",";
  struct row *row;
  char *temp_row[23];

  for(int i = 0; i < 14; i++){
    file = fopen(file_names[i], mode);
    while(getline(&line, &size, file) != 0){
      token = strtok(line, delim);
      int i = 0;
      while(token != NULL ){
        temp_row[i] = token;
        token = strtok(NULL, delim);
        i++;
      }
      row = malloc(sizeof(struct row));
      row->title = temp_row[21];
      row->url = temp_row[22];
      row->publication_date = temp_row[18];
      printf("Row title: %s", row->title);
    }
  }
}
