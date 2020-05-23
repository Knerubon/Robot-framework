*** Settings ***
Library    OperatingSystem

*** Variable ***
${dir_start}    C:/Users/AGT111/Downloads         
${dir_end}      C:/Robot/CopyFile2
# ${PATH}         C:/Robot/CopyFile3      #Create

*** Test Case ***
test
    # Create Directory  ${PATH}/CopyFile3  #Create

    CopyFile     ${dir_start}/22012020.pdf     ${dir_end}

    move_file    ${dir_end}/22012020.pdf    ${dir_end}/Test_1.pdf

    Remove File    ${dir_start}/crsViewReport.pdf

    