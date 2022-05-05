#!/bin/bash

if [[ $EUID -ne 0 ]]
then
    echo "Only root can run this script!!!"
    exit 1
fi

read -p 'Enter extention number(must be 4 digits): ' extensionNumber
if [ -z "$extensionNumber" ]
then
     echo "Extention number is empty"
     exit 1
elif [[ ! $extensionNumber =~ ^[0-9]{4} ]]
then
     echo "Extention number must be 4 digit number"
     exit 1
fi

read -p 'Enter caller ID: ' callerID
if [ -z "$callerID" ]
then
     echo "Caller ID cannot be empty"
     exit 1
fi

read -p 'Password: ' password


echo ""
echo "Entered extension number is: $extensionNumber"
echo "Entered caller ID is: $callerID"
echo ""

echo "Now checking configuration files..."
echo "Please wait here..."

SIP_FILE='/etc/asterisk/sip.conf'
EXTENSIONS_FILE='/etc/asterisk/extensions.conf'

if [ ! -f "$SIP_FILE" ]; then
     echo "sip.conf file is not available at $SIP_FILE"
     exit 1
else
     if [ ! -f "$EXTENSIONS_FILE" ]; then
          echo "extensions.conf file is not available at $EXTENSIONS_FILE"
          exit 1
     fi
     echo "
[$extensionNumber](voip-default)
secret=$password
callerid=\"$callerID\" <$extensionNumber>
     " >> $SIP_FILE
     echo "SIP configuration are added successfully!!!"

     echo "
[from-trunk]
;
; voip-default $extensionNumber (FOR TEST ONLY)
;
exten     => $extensionNumber, 1, NoOp(Someone Calling $extensionNumber)
same => n, Answer()
same => n, Wait()
same => n, Dial(SIP/$extensionNumber, 30, r)
     " >> $EXTENSIONS_FILE
     echo "EXTENSIONS configuration are added successfully!!!"
fi
