*** Settings ***
Library           Selenium2Library
 
*** Variables ***
${URL}            //URL
${pageTitle}      //pageTitle
${timeout}        10s
 
*** Test Cases ***
Open QA Hive website via chrome headless mode
    ${opt}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${opt}    add_argument    --headless
    Create Webdriver    Chrome    chrome_options=${opt}
    Go To    ${URL}
    Wait Until Page Contains    ${pageTitle}    ${timeout}
    Capture Page Screenshot
    Close Browser