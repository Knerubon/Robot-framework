*** Settings ***
Library      Selenium2Library
Library      BuiltIn
Library      String
Library      OperatingSystem
Library      DateTime
Suite Setup    Setting 

*** Variables ***
${browser}          Chrome
${url}              //url
${input_user}       id=txtUserID
${input_pass}       id=txtPassword
${btn_login}        id=btnLogin
${GenID}            iconMenu_icon_bobjid_

#-------------------- Config -------------------------------------------------------------------------#
${user}                 //Useer
${password}             //Pass
${Date_From}            20200121    #Format : YYYYMMDD --> Date_From    
${Date_To}              20200122    #Format : YYYYMMDD --> Date_To
${TypeProduct}          ALL        #Select type : |ALL|Commod Swap|Commod Option|Futures|FX|FX Option|Money Market|Credit Derivatives|Swap|
${dir_start}            C:/Users/AGT111/Downloads         # Path Start
${dir_end}              C:/Robot/CopyFile2                # Path End

#------------------------------------------------------------------------------------------------------#

*** Keywords ***
Setting 
    Open Browser  ${url}  ${browser}
    Maximize Browser Window
    #Set Screenshot Directory  ${Path}
    #---------------------------
    # ${opt}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Call Method    ${opt}    add_argument    --headless
    # Create Webdriver    Chrome    chrome_options=${opt}
    # Go To    ${URL}
    # Sleep   2s
    # Wait Until Page Contains    ${pageTitle}    10s
    # Capture Page Screenshot
    
login
    [Arguments]    ${xpath_user}    ${xpath_pass}    ${username}    ${password} 
     Element Should Be Visible    ${xpath_user}
     Element Should Be Visible    ${xpath_pass}
     Input Text       ${xpath_user}       ${username}
     Input Text       ${xpath_pass}       ${password}
     Click Element    ${btn_login}
     Sleep   2s     

For Loop Click arrowRight
    : FOR    ${INDEX}    IN RANGE    1    15
    \    Log    ${INDEX}
    \    click element    //*[@id="arrowRight"]
    Log    For loop is over

*** Test Cases ***

Case 1 : Test 

    login    ${input_user}    ${input_pass}      ${user}       ${password}    
    Sleep   2s
    Wait Until Page Contains     Treasury Report System   30s
    For Loop Click arrowRight
    click Element    xpath=//*[@id="menu"]/ul/li[12]/a/span
    Sleep   2s
    click link    Maturity Date Transaction Report
    
    #--------------------------------------------------------------------------------------#
    ##### Setting Date From
    # ${Date_From} =	Convert Date	 20200121         #----- YYYYMMDD
    ${Log_Date_From} =	Convert Date	 ${Date_From}	result_format=%d %B %Y
    Click Element   id=ContentPlaceHolder1_txtMaturityDateFrom
    Click Element   xpath=//div[@title='${Log_Date_From}']

    ##### Setting Date To
    # ${Date_To} =	Convert Date	 20200122         #-----YYYYMMDD
    ${Log_Date_To} =	Convert Date	 ${Date_To}     result_format=%d %B %Y
    Click Element   id=ContentPlaceHolder1_txtMaturityDateTo
    Click Element   (//div[@title='${Log_Date_To}'])[2]
    Select From List By Label      xpath=//*[@id="ContentPlaceHolder1_ProductControlDDL_ddlProduct"]     ${TypeProduct}
    Click Element    xpath=//*[@id="ContentPlaceHolder1_btnView"]
    #--------------------------------------------------------------------------------------#

    #### Main Report 
    ${url1}   ${url2}      Get Locations
    Select Window    url=${url2}
    Sleep   2s
    Click Element   xpath=//img[contains(@alt,'Export this report')]
      
    # ${url1}   ${url2}    Get Window Handles
    # Select Window	${url2}
    # Wait Until Page Contains   File Format   30s
    Sleep  2s
    Click Element    xpath=//td[@align='left'][contains(.,'Crystal Reports (RPT)')]
    Wait Until Element is Enabled  //*[starts-with(@id, 'iconMenu_icon_bobjid_')]   30s
    @{elements}   Get Webelements    //*[starts-with(@id, 'iconMenu_icon_bobjid_')]
    @{ids}    Evaluate    [elem.get_attribute('id') for elem in $elements]
    Log  ${ids}
    ${element}    Get Substring    @{ids}     21    -13
    Sleep   2s
    Click Element      //*[@id="iconMenu_menu_bobjid_${element}_dialog_combo_text_bobjid_${element}_dialog_combo_it_11"]
    Click Element      xpath=//*[@id="theBttnCenterImgbobjid_${element}_dialog_submitBtn"]
    Sleep   2s

    #------------------------------ Move File --------------------------------#

    File Should Exist      ${dir_start}/crsViewReport.pdf
    CopyFile     ${dir_start}/crsViewReport.pdf     ${dir_end}
    ${StartFile}    Get Substring    ${Log_Date_From}     0       -9
    ${EndFile}      Get Substring    ${Log_Date_To}       0       -9
    ${YearFile}     Get Substring    ${Date_From}         0       -4
    move_file    ${dir_end}/crsViewReport.pdf       ${dir_end}/Maturity Report ${TypeProduct} ${StartFile} - ${EndFile} ${YearFile}.pdf
    Remove File    ${dir_start}/crsViewReport.pdf

    #------------------------------ End --------------------------------------#


    