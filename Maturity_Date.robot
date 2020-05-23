*** Settings ***
Library      Selenium2Library
Library      BuiltIn
Library      String
Library      OperatingSystem
Library      DateTime
Suite Setup    Setting 

*** Variables ***
${browser}          Chrome
${url}              //local
${input_user}       id=txtUserID
${input_pass}       id=txtPassword
${btn_login}        id=btnLogin
${GenID}            iconMenu_icon_bobjid_

#-------------------- Config -------------------------------------------------------------------------#
${user}                 //user
${password}             //password
${ForLoop}              15
${Date_From}            20200121    #Format : YYYYMMDD --> Date_From    
${Date_To}              20200122    #Format : YYYYMMDD --> Date_To
${TypeProduct}          Swap        #Select type : |ALL|Commod Swap|Commod Option|Futures|FX|FX Option|Money Market|Credit Derivatives|Swap|
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
    [Arguments]    ${ForLoop}
    : FOR    ${INDEX}    IN RANGE    1    ${ForLoop}
    \    Log    ${INDEX} 
    \    click element    //*[@id="arrowRight"]
    Log    For loop is over
    Sleep   2s

Select Report Maturity Date Transaction Report
    Wait Until Page Contains     Treasury Report System   30s
    click Element    xpath=//*[@id="menu"]/ul/li[12]/a/span
    Wait Until Page Contains     Maturity Date Transaction Report   30s
    Sleep   2s
    click link    Maturity Date Transaction Report

select Setting Date From
    [Arguments]    ${Date_From}
    ${Log_Date_From} =	Convert Date	 ${Date_From}	result_format=%d %B %Y
    Click Element   id=ContentPlaceHolder1_txtMaturityDateFrom
    Click Element   xpath=//div[@title='${Log_Date_From}']
    

select Setting Date To
    [Arguments]     ${Date_To}
    ${Log_Date_To} =	Convert Date	 ${Date_To}     result_format=%d %B %Y
    Click Element   id=ContentPlaceHolder1_txtMaturityDateTo
    Click Element   (//div[@title='${Log_Date_To}'])[2]
    

Select Product Type
    [Arguments]     ${TypeProduct}
    Select From List By Label      xpath=//*[@id="ContentPlaceHolder1_ProductControlDDL_ddlProduct"]     ${TypeProduct}
    Click Element    xpath=//*[@id="ContentPlaceHolder1_btnView"]
    Sleep  2s
    
Crystal Report Page
    ${url1}   ${url2}      Get Locations
    Select Window    url=${url2}
    Click Element   xpath=//img[contains(@alt,'Export this report')]
    # ${url1}   ${url2}    Get Window Handles
    # Select Window	${url2}
    Sleep  2s
    Click Element    xpath=//td[@align='left'][contains(.,'Crystal Reports (RPT)')]
    Wait Until Element is Enabled  //*[starts-with(@id, 'iconMenu_icon_bobjid_')]   30s
    @{elements}   Get Webelements    //*[starts-with(@id, 'iconMenu_icon_bobjid_')]
    @{ids}    Evaluate    [elem.get_attribute('id') for elem in $elements]
    Log  ${ids}
    ${element}    Get Substring    @{ids}     21    -13
    Click Element      //*[@id="iconMenu_menu_bobjid_${element}_dialog_combo_text_bobjid_${element}_dialog_combo_it_11"]
    Click Element      xpath=//*[@id="theBttnCenterImgbobjid_${element}_dialog_submitBtn"]
    Sleep   2s

Directory File
    [Arguments]     ${Date_From}    ${Date_To}      ${TypeProduct}
    File Should Exist      ${dir_start}/crsViewReport.pdf
    CopyFile     ${dir_start}/crsViewReport.pdf     ${dir_end}
    ${Log_Date_From} =	Convert Date	 ${Date_From}	result_format=%d %B %Y
    ${Log_Date_To} =	Convert Date	 ${Date_To}     result_format=%d %B %Y
    ${StartFile}    Get Substring    ${Log_Date_From}     0       -9
    ${EndFile}      Get Substring    ${Log_Date_To}       0       -9
    ${YearFile}     Get Substring    ${Date_From}         0       -4
    move_file      ${dir_end}/crsViewReport.pdf       ${dir_end}/Maturity Report ${TypeProduct} ${StartFile} - ${EndFile} ${YearFile}.pdf
    Remove File    ${dir_start}/crsViewReport.pdf
    Close Window
    Sleep  2s

Clear Element Value Date
    ${url1} =     Get Locations
    Select Window    ${url1}
    Wait Until Page Contains      Maturity Date Transaction Report    30s
    Click Element           //*[@id="ContentPlaceHolder1_ImageButton2"]
    Sleep  2s


*** Test Cases ***

Login and Select Report
    login    ${input_user}    ${input_pass}      ${user}       ${password}  
    For Loop Click arrowRight     ${ForLoop}
    Select Report Maturity Date Transaction Report

Case 1 : Maturity Report Swap 21 Jan - 22 Jan 2020
    [Tags]    Product Swap
    select Setting Date From    ${Date_From}
    select Setting Date To      ${Date_To}
    Select Product Type         ${TypeProduct}
    Crystal Report Page
    Directory File              ${Date_From}    ${Date_To}      ${TypeProduct}
    Clear Element Value Date    
    
Case 2 : Maturity Report Futures 23 Jan - 24 Jan 2020
    [Tags]    Product Futures
    select Setting Date From     20200123    #Format : YYYYMMDD --> Date_From
    select Setting Date To       20200124    #Format : YYYYMMDD --> To
    Select Product Type          Futures     #Select type
    Crystal Report Page
    Directory File               20200123     20200124     Futures
    Clear Element Value Date    
    
Case 3 : Maturity Report FX Option 23 Jan - 24 Jan 2020
    [Tags]    Product FX Option
    select Setting Date From     20200124    #Format : YYYYMMDD --> Date_From
    select Setting Date To       20200125    #Format : YYYYMMDD --> To
    Select Product Type          FX Option     #Select type
    Crystal Report Page
    Directory File               20200124     20200125    FX Option
    Clear Element Value Date     

Case 4 : Maturity Report FX 25 Jan - 25 Jan 2020
    [Tags]    Product FX
    select Setting Date From     20200125    #Format : YYYYMMDD --> Date_From
    select Setting Date To       20200125    #Format : YYYYMMDD --> To
    Select Product Type          FX          #Select type
    Crystal Report Page
    Directory File               20200125     20200125    FX
    Clear Element Value Date  

Case 5 : Maturity Report Commod Option 29 Jan - 1 Feb 2020 
    [Tags]    Product Commod Option
    select Setting Date From     20200129           #Format : YYYYMMDD --> Date_From
    select Setting Date To       20200201           #Format : YYYYMMDD --> To
    Select Product Type          Commod Option      #Select type
    Crystal Report Page
    Directory File               20200129     20200201    Commod Option
    Clear Element Value Date
    
    #------------------End--------------------#
    Close All Browsers     