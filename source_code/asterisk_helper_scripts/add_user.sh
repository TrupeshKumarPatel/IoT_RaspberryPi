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
echo "The extension number is: $extensionNumber"
echo "The caller ID is: $callerID"
echo ""
