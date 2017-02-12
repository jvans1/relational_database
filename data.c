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
  if(*starting_point == *comma) {
    current_field++;
    return "" ;
  }
  for(;*current_field != *comma && *current_field != '\n' && *current_field != '\0';*current_field++){}
  size_t new_string_size = current_field - starting_point;
  if(new_string_size == 0){
    return NULL;
  }
  new_string = malloc(new_string_size);
  stpncpy(new_string, starting_point, new_string_size);
  *current_field++;
  return  new_string;
}
typedef struct {
  char *publication_date;
  char *title;
  char *url;
} Row;

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

int row_count = 0;

Row * filter(char *title, Row *rows) {
  for(int a = 0; a < row_count; a++){
    if(strcmp(rows[a].title, title) == 0){
      printf("Found title %s", rows[a].title);
    }
  }
}


int main ()
{

  FILE *file;
  char *line = NULL;
  size_t size = 0;
  const char *mode =  "r";
  char *token;
  Row *row;
  char *temp_row[60];
  Row *rows[MAX_ROWS];


  for(int i = 0; i < 14; i++){
    file = fopen(file_names[i], mode);
    assert(file != NULL);
    while(getline(&line, &size, file) != -1){
      token = field(line);
      int index = 0;
      while(token != NULL ){
        temp_row[index] = token;
        index++;
        token = field(NULL);
      }
      row = malloc(sizeof(Row));
      row->title = temp_row[21];
      row->url = temp_row[22];
      row->publication_date = temp_row[18];
      rows[row_count] = row;
      row_count++;
    }
  }

  printf("What title do you want?\n", row_count);
  char *input;
  getline(&input, &size, stdin);
  char newline = '\n';
  char *input_no_newline = strtok(input, &newline);
  filter(input_no_newline)
}

