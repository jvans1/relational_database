#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#define MAX_ROWS 1000000
char *current_field;
char *starting_point;
char *comma = ",";
char *field(char *input)
{
  char *new_string;
  if(input != NULL) { current_field = input; };
  starting_point = current_field;
  for(;*current_field != *comma;*current_field++){}
  size_t new_string_size = current_field - starting_point;
  if(new_string_size == 0){
    return NULL;
  }
  new_string = malloc(new_string_size);
  stpncpy(new_string, starting_point, new_string_size);
  *current_field++;
  return  new_string;
}
struct row {
  char *publication_date;
  char *title;
  char *url;
};

int main ()
{

  const char *file_names[] = {
    "test_file.csv"
    /* "cia-crest-files-cia-crest-archive-metadata/1_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/2_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/3_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/4_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/5_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/6_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/7_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/8_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/9_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/10_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/11_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/12_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/13_export.csv", */
    /* "cia-crest-files-cia-crest-archive-metadata/14_export.csv" */
  };

  FILE *file;
  char *line = NULL;
  size_t size = 0;
  const char *mode =  "r";
  char *token;
  struct row *row;
  char *temp_row[60];
  struct row *rows[MAX_ROWS];
  int row_count = 0;


  for(int i = 0; i < 1; i++){
    file = fopen(file_names[i], mode);
    assert(file != NULL);
    while(getline(&line, &size, file) != -1){
      token = field(line);
      /* token = strtok(line, delim); */
      /* int index = 0; */
      while(token != NULL ){
        printf("Token: %s\n", token);
        token = field(NULL);
      }
      /* row = malloc(sizeof(struct row)); */
      /* row->title = temp_row[0]; */
      /* row->url = temp_row[1]; */
      /* row->publication_date = temp_row[2]; */
      /* rows[row_count] = row; */
      /* row_count++; */
      /* printf("First Name: %s, Last Name %s, Age %s\n", row-> title, row->url, row->publication_date); */
    }
  }
}

