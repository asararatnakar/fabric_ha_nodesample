#!/bin/bash -e
function decor(){
  printf "\n ======================================== \n"
  docker ps -a | grep "peer[0-1].org[0-1].example.com$"
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

EXITED_CONTAINERS=$(docker ps -a | grep Exited | awk '{print $1}')
if [ ! -z "$EXITED_CONTAINERS" ]; then
  docker start $EXITED_CONTAINERS
fi

decor
VALUE="A_SIMPLE_VALUE1" ; ./quicktest.sh invoke $VALUE && ./quicktest.sh query $VALUE

verifyResult $? "PEER-TEST-1"

docker stop peer0.org1.example.com && sleep 5
decor
VALUE="A_SIMPLE_VALUE2" ; ./quicktest.sh invoke $VALUE && sleep 5 && ./quicktest.sh query $VALUE

verifyResult $? "PEER-TEST-2"
