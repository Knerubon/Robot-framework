*** Settings ***
Library           Selenium2Library
 
*** Variables ***
${URL}            //url
# ${pageTitle}      //pageTitle
# ${timeout}        10s

${input_user}       id=txtUsername
${input_pass}       id=txtPassword
${btn_login}        id=btnLogin

*** Keywords ***
login JEDI
    [Arguments]    ${input_user}    ${input_pass}    ${username}    ${password} 
     Element Should Be Visible    ${input_user}
     Element Should Be Visible    ${input_pass}
     Input Text       ${input_user}       ${username}
     Input Text       ${input_pass}       ${password}
     Click Element    ${btn_login}
     Sleep   2s   


*** Test Cases ***
Open chrome headless mode
    ${opt}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${opt}    add_argument    --headless
    Create Webdriver    Chrome    chrome_options=${opt}
    Go To    ${URL}
    # Wait Until Page Contains    ${pageTitle}    10s

    login JEDI      ${input_user}    ${input_pass}    adminjedi    password
    Click Element    xpath=/html/body/app-root/app-admin-master-page/nav/div/div[3]/ul/li[3]/a
    Sleep  2s
    
    #GET AppID
    @{elements}   Get Webelements    //*[starts-with(@name, 'txtAppID')]
    @{AppID}    Evaluate    [elem.get_attribute('ng-reflect-model') for elem in $elements]
    Log  ${AppID}

    #GET AppSecret
    @{elements}   Get Webelements    //*[starts-with(@name, 'txtAppSecret')]
    @{AppSecret}    Evaluate    [elem.get_attribute('ng-reflect-model') for elem in $elements]
    Log  ${AppSecret}

    #GET CreateDate
    @{elements}   Get Webelements    //*[starts-with(@name, 'txtCreateDate')]
    @{CreateDate}    Evaluate    [elem.get_attribute('ng-reflect-model') for elem in $elements]
    Log  ${CreateDate}


    Capture Page Screenshot


   
    

    
    

