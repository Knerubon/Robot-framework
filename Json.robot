*** Settings ***
Library	 Collections	 	 	 
Library	 RequestsLibrary
Library   Selenium2Library
Library   DateTime
Library   String

*** Variable ***
${URL}              //URL
# ${apiKey}         //apiKey
# ${apiSecret}      //apiSecret
# ${timeStamp}      1580702216000
# ${signature}      //signature
${input_user}       id=txtUsername
${input_pass}       id=txtPassword
${btn_login}        id=btnLogin

*** Keywords ***
Open chrome headless mode
    ${opt}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${opt}    add_argument    --headless
    Create Webdriver    Chrome    chrome_options=${opt}
    Go To    ${URL}
    Sleep  2s

login JEDI
    [Arguments]    ${input_user}    ${input_pass}    ${username}    ${password} 
     Element Should Be Visible    ${input_user}
     Element Should Be Visible    ${input_pass}
     Input Text       ${input_user}       ${username}
     Input Text       ${input_pass}       ${password}
     Sleep   2s
     Click Element    ${btn_login}
     Sleep   2s

Click Menu APIsettrade
    Click Element       xpath=/html/body/app-root/app-admin-master-page/nav/div/div[3]/ul/li[3]/a
    Sleep  2s



*** Test Cases ***
Test Get Json
    Open chrome headless mode
    login JEDI       ${input_user}     ${input_pass}    //user    //pass
    Click Menu APIsettrade
    
   # GET AppID
    @{elements}   Get Webelements    //*[starts-with(@name, 'txtAppID')]
    @{AppID}    Evaluate    [elem.get_attribute('ng-reflect-model') for elem in $elements]
    Log  ${AppID}
    ${_AppID} =	Catenate    ${AppID}

    #GET AppSecret
    @{elements}   Get Webelements    //*[starts-with(@name, 'txtAppSecret')]
    @{AppSecret}    Evaluate    [elem.get_attribute('ng-reflect-model') for elem in $elements]
    Log  ${AppSecret}
    ${_AppSecret} =	Catenate    SEPARATOR=  ${AppSecret}

    #GET CreateDate
    @{elements}   Get Webelements    //*[starts-with(@name, 'txtCreateDate')]
    @{timeStamp}    Evaluate    [elem.get_attribute('ng-reflect-model') for elem in $elements]
    Log  ${timeStamp}

    #Convert timeStamp
    ${string}=    Convert To String    ${timeStamp}
    ${element}    Get Substring    ${string}     2     -2
    ${Convert_Date}=     Convert Date    ${element}     exclude_millis=yes    date_format=%d/%m/%Y %H:%M:%S
    ${epoch} =   Convert Date     ${Convertdate}    epoch
   
    ${_timeStamp}=    Convert To String    ${epoch}
    ${_timeStamps}    Get Substring    ${_timeStamp}     0     -2

    ${words} =	Split String	${_timeStamps}000
    log    ${words}

    ${str3} =	Catenate	SEPARATOR=	${_timeStamps}000

    
   #  ${_timeStamps_}    Get Substring    ${words}     2     -2
   #  Capture Page Screenshot

   # ${Convertdate} =	Convert Date	${timeStamp}	 exclude_millis=yes    date_format=%m.%d.%Y %H:%M	
   #  # Should Be Equal    ${date}    2014-05-28 12:05:03.111		
   #  ${epoch} =   Convert Date     ${Convertdate}    epoch

   #  ${string}=    Convert To String    ${timeStamp}
   #  log   ${string}
   #  ${element}    Get Substring    ${string}     0     -3

   #  ${element2}    Get Substring    ${string}     -2     4

   #  @{words} =	Split String	${element}${element2}	

# APIsettrade  
   #========================================================================================#
   #                                  Create :: Get signature                               #
   #========================================================================================#
 	Create Session  JEDI	 ${URL}	 
 	${json_string}=    catenate
    ...  {
    ...    "apiKey":"${AppID}",
    ...    "apiSecret":"${AppSecret}",     
    ...    "timeStamp":"${str3}"
    ...  }
    &{headers}=    Create Dictionary    Content-Type=application/json 
 	${resp}=	POST Request	JEDI	/api/v1/settrade/ecdsa/signature/create   data=${json_string}    headers=${headers}
 	Log    Num value is ${resp.text}
    Should Be Equal  ${resp.status_code}  ${200}
    ${json} =  Set Variable  ${resp.json()}
    Log    Num value is ${json['signature']}
    ${signature}=  Get Variable Value  ${json['signature']}
    log    ${json['signature']}
    log    ${signature}

   #////////////////////////////////////////////////////////////////////////////////////////#


   #========================================================================================#
   #                                 Get Token :: Login Token                               #
   #========================================================================================#
   
   # Create Session  APIsettrade  https://open-api-test.settrade.com
   # ${json_string}=    catenate
   #  ...  {
   #  ...    "apiKey":"${apiKey}",
   #  ...    "params":"",
   #  ...    "signature":"${signature}",     
   #  ...    "timeStamp":"${timeStamp}"
   #  ...  }
   #  &{headers}=    Create Dictionary    Content-Type=application/json
   #  ${resp}=	POST Request	APIsettrade	/api/oam/v1/018/broker-apps/EFP/login   data=${json_string}    headers=${headers}
 	# Log    Num value is ${resp.text}
   #  ${json} =  Set Variable  ${resp.json()}
   #  Log    Num value is ${json['token']}
   #  ${token}=  Get Variable Value  ${json['token']}
   #  log    ${token}

   #////////////////////////////////////////////////////////////////////////////////////////#


   #========================================================================================#
   #                              Login Token :: Create Order                               #
   #========================================================================================#

   # Create Session  APIsettrade  https://open-api-test.settrade.com
   # ${json_string}=    catenate
   #  ...  {
   #  ...    "seller": "401001-0",
   #  ...    "buyer": "200008-0",
   #  ...    "cpm": "0018",     
   #  ...    "position": "OPEN",
   #  ...    "price": 30.56,
   #  ...    "symbol": "USDM20",
   #  ...    "trType": "TFEX_USDF",
   #  ...    "volume": 20
   #  ...  }
   # &{headers}=    Create Dictionary    Content-Type=application/json      Authorization=Bearer ${token}
   #  ${resp}=	POST Request	APIsettrade	/api/seosd/v1/018/mktrep/orders/tradeReport   data=${json_string}    headers=${headers}
 	# Log    Num value is ${resp.text}
   #  ${json} =  Set Variable  ${resp.json()}
   # #  Log    Num value is ${json['token']}
   # #  ${token}=  Get Variable Value  ${json['token']}
   # #  log    ${token}

   #////////////////////////////////////////////////////////////////////////////////////////#