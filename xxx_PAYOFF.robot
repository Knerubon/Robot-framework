*** Settings ***
Library	  Collections	 	 	 
Library	  RequestsLibrary
Library   Selenium2Library
Library   OperatingSystem
Library   DateTime
Library   String

*** Variable ***
#================= input Data ===========================#

${channel}       input channel
${Acc_no}        input Acc_no
${CID}           input CID

#============================================#

${path}          C:/Robot/Payment
# ${url}           //local   #E2E
${url}             //local   #SIT
${ENV}         sit

#============================================#

*** Keywords ***

*** Test Cases ***
Test Payment Online
   ${date} =  Get Current Date
   ${effDate} =  Convert Date	${date}	result_format=%Y%m%d
   ${dateTime} =	 Convert Date	${date}	result_format=%Y%m%d%H%M%S
   
   #========================================================================================#
   #                                 ::   GET balance   ::                                  #
   #========================================================================================#

 	Create Session  Approval	 ${url}
 	${json_string}=    catenate
    ...  {
    ...   "amount":"0",
    ...   "bankCode":"006",
    ...   "bankRef":"${dateTime}", 
	...    "channel":"${channel}",
	...    "comCode":"",
	...    "command":"APPROVAL",
	...    "dateTime":"${dateTime}",
	...    "effDate":"${effDate}",
	...    "password":"cbpay",
	...    "prodCode":"DSL",
	...    "ref2":"${Acc_no}",    
	...    "ref1":"${CID}", 
	...    "ref3":"",
	...    "ref4":"",
	...    "user":"cbpay"
	...  }
    &{headers}=    Create Dictionary    Content-Type=application/json 
 	 ${resp}=	POST Request	Approval	/api/v1/dms/cbpay/GetApproval   data=${json_string}    headers=${headers}
 	 Log    Num value is ${resp.text}
    # check status_code 200
    Should Be Equal   ${resp.status_code}  ${200}
    ${json} =  Set Variable  ${resp.json()}
    # Log    ${json}
    # Log    Num value is ${json['respMsg']}
    # Create LOG file
    # Create File   ${path}/approval_${Acc_no}_${dateTime}.txt  ${resp.text}
    # Check successful
    # Should Be Equal   ${json['respMsg']}   Successful

    # ----- > Get tranxId 
    Log    Num value is ${json['balance']}
    ${balance}=  Get Variable Value  ${json['balance']}
    log    ${balance}

   #========================================================================================#
   #                                      ::  Approval  ::                                  #
   #========================================================================================#
    ${date_} =  Get Current Date
    ${effDate_} =  Convert Date	${date_}	result_format=%Y%m%d
    ${dateTime_} =	 Convert Date	${date_}	result_format=%Y%m%d%H%M%S

 	Create Session  Approval	 ${url}
 	${json_string}=    catenate
    ...  {
    ...   "amount":"${balance}",
    ...   "bankCode":"006",
    ...   "bankRef":"${dateTime_}", 
	...    "channel":"${channel}",
	...    "comCode":"",
	...    "command":"APPROVAL",
	...    "dateTime":"${dateTime_}",
	...    "effDate":"${effDate_}",
	...    "password":"cbpay",
	...    "prodCode":"DSL",
	...    "ref2":"${Acc_no}",    
	...    "ref1":"${CID}", 
	...    "ref3":"",
	...    "ref4":"",
	...    "user":"cbpay"
	...  }
    &{headers}=    Create Dictionary    Content-Type=application/json 
 	 ${resp}=	POST Request	Approval	/api/v1/dms/cbpay/GetApproval   data=${json_string}    headers=${headers}
 	 Log    Num value is ${resp.text}
    # check status_code 200
    Should Be Equal   ${resp.status_code}  ${200}
    ${json} =  Set Variable  ${resp.json()}
    Log    ${json}
    Log    Num value is ${json['respMsg']}
    # Create LOG file
    Create File   ${path}/approval_${Acc_no}_${dateTime} ${ENV}.txt  ${resp.text}
    # Check successful
    Should Be Equal   ${json['respMsg']}   Successful

    # ----- > Get tranxId 
    Log    Num value is ${json['tranxId']}
    ${tranxId}=  Get Variable Value  ${json['tranxId']}
    log    ${tranxId}
   
   #========================================================================================#
   #                                 ::     Payment     ::                                  #
   #========================================================================================#
   ${date2} =  Get Current Date
   # ${effDate} =  Convert Date	${date2}	result_format=%Y%m%d
   ${dateTime2} =	 Convert Date	${date2}	result_format=%Y%m%d%H%M%S

   Create Session  Payment  ${url}
   ${json_string}=    catenate
    ...  {
    ...   "amount":"${balance}",  
    ...   "bankCode":"006",
    ...   "bankRef":"${dateTime2}", 
	...    "channel":"${channel}",
	...    "comCode":"",
	...    "command":"PAYMENT",
	...    "dateTime":"${dateTime2}",
	...    "effDate":"${effDate}", 
	...    "password":"cbpay",
	...    "prodCode":"DSL",
	...    "cusName":"ทดสอบ",
	...    "respCode":0,
	...    "respMsg":"",
	...    "ref1":"${CID}",  
	...    "ref2":"${Acc_no}",  
	...    "ref3":"",
	...    "ref4":"",
	...    "user":"cbpay",
	...    "tranxId":"${tranxId}" 
	...  }
    &{headers}=    Create Dictionary    Content-Type=application/json
    ${resp}=	POST Request	Payment	/api/v1/dms/cbpay/GetPayment   data=${json_string}    headers=${headers}
 	 Log    Num value is ${resp.text}
    # check status_code 200
    Should Be Equal   ${resp.status_code}  ${200}
    ${json} =  Set Variable  ${resp.json()}
    Log    ${json}
    Log    Num value is ${json['respMsg']}
    # Create LOG file
    Create File   ${path}/payment_${Acc_no}_${dateTime2} ${ENV}.txt  ${resp.text}
    # Check successful
    Should Be Equal   ${json['respMsg']}   Successful


   #////////////////////////////////////////////////////////////////////////////////////////#

