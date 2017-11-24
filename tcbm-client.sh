#!/bin/bash

cd ~
#mkdir .tcbm
cd .tcbm
#mkdir client
cd client
#mkdir tmp
cd tmp
#mkdir job

$USE_THIS_SLAVE=True

while [[ $USE_THIS_SLAVE = True ]]; do
  echo free > request

  if [ -f ~/.tcbm/client/tmp/job.sh ]
  then
    echo render
    sleep 2
  else
    sleep 2
fi
  cd ~/.tcbm/client/tmp/job
  rm *

done







if [[ $USE_THIS_SLAVE == True ]] && [[ $PROCESSING == No ]] && [[ $IS_THERE_A_JOB == No ]]
  then
  echo standby > slavestatus.txt
  echo $MYDATE standby >> slavelog.txt
  sleep 2

elif [[ $USE_THIS_SLAVE == True ]] && [[ $PROCESSING == No ]] \
&& [[ $IS_THERE_A_JOB == Yes ]]
  then
  echo starting_new_job > slavestatus.txt
  echo $MYDATE starting new job >> slavelog.txt
  #STARTBEFEHL FÜR JOBFILE

elif [[ $USE_THIS_SLAVE == True ]] && [[ $PROCESSING == Yes ]]
  then
  echo at_work > slavestatus.txt
  render
  slee

elif [[ $USE_THIS_SLAVE == False ]] && [[ $PROCESSING == Yes ]]
  then
  echo last_job > slavestatus.txt

elif [[ $USE_THIS_SLAVE == False ]] && [[ $PROCESSING == No ]]
  then
  echo off > slavestatus.txt

else
  echo error > slavestatus

fi
