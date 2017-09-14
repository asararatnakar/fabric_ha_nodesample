#!/bin/bash -e
function decor(){
  printf "\n ======================================== \n"
  docker ps -a | grep orderer
  printf "\n ======================================== \n"
}

function verifyResult(){
  if [ $1 -ne 0 ]; then
    printf "\n!!!!!!!!!!!! $2 FAILED !!!!!!!!!!!! \n"
    exit 1
  else
    printf "\n============= $2 PASSED ============= \n"
  fi
}

decor
VALUE="VALUE1" ; ./quicktest.sh invoke $VALUE && sleep 5 && ./quicktest.sh query $VALUE

verifyResult $? "ORD-TEST-1"

docker stop orderer0.example.com
decor
VALUE="VALUE2" ; ./quicktest.sh invoke $VALUE && sleep 5 && ./quicktest.sh query $VALUE

verifyResult $? "ORD-TEST-2"

docker stop orderer1.example.com
decor
VALUE="VALUE3" ; ./quicktest.sh invoke $VALUE && sleep 15 && ./quicktest.sh query $VALUE

verifyResult $? "ORD-TEST-3"

docker start orderer0.example.com && sleep 5 && docker stop orderer2.example.com && sleep 5
decor
VALUE="VALUE4" ; ./quicktest.sh invoke $VALUE && sleep 15 && ./quicktest.sh query $VALUE

verifyResult $? "ORD-TEST-4"

docker start orderer2.example.com && sleep 5 && docker stop orderer0.example.com && sleep 5 && docker stop orderer1.example.com
decor
VALUE="VALUE5" ; ./quicktest.sh invoke $VALUE && sleep 15 && ./quicktest.sh query $VALUE
verifyResult $? "ORD-TEST-5"

docker start orderer0.example.com &&  sleep 5 && docker start orderer1.example.com
decor
