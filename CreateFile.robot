*** Settings ***
Library  OperatingSystem
Library  String



*** Keywords ***
write_variable_in_file
  [Arguments]  ${variable}
  Create File  C:/Robot/file_with_variable.txt  ${variable}


*** test cases ***
write_variable_in_file
  Create File  C:/Robot/file_with_variable.txt   nerubon