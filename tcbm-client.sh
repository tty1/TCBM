#!/bin/bash

#cd ~
#mkdir .tcbm
#cd .tcbm
#mkdir client
#cd client
#mkdir tmp
#cd tmp
#mkdir job

USE_THIS_SLAVE=Yes
PROCESSING=No

#while [[ $USE_THIS_SLAVE = Yes ]]; do
#  echo free > request

#  if [ -f ~/.tcbm/client/tmp/job.sh ]
#  then
#    echo render
#    sleep 2
#  else
#    sleep 2
#fi
#  cd ~/.tcbm/client/tmp/job
#  rm *
#done
rm ~/.tcbm/slave/last_slavelog.txt

last_slavelog=STARTUPSLAVE
echo "\n"
echo $last_slavelog
echo "\n"

echo "\n" >> ~/.tcbm/slave/slavelog.txt
echo $last_slavelog >> ~/.tcbm/slave/slavelog.txt
echo "\n" >> ~/.tcbm/slave/slavelog.txt


while [[ 1 == 1 ]]
do
if ! [[ $last_slavelog == STARTUPSLAVE ]]
then
last_slavelog=`<~/.tcbm/slave/last_slavelog.txt`
fi
echo $last_slavelog
echo $last_slavelog >> ~/.tcbm/slave/slavelog.txt

#standby start
if [[ $USE_THIS_SLAVE == Yes ]] && [[ $PROCESSING == No ]] \
#&& [[ $IS_THERE_A_JOB == No ]]
then
echo 12345678dfggh
sleep 1
olddate=`date`
  while ! [[ -f ~/.tcbm/slave/tmp/job.tcbm ]]
  do
  echo standby > ~/.tcbm/slave/slavestatus.txt
  newdate=`date`
  echo standby $olddate - $newdate
  echo standby $olddate $newdate > last_slavelog.txt
  #echo $last_slavelog > ~/.tcbm/slave/last_slavelog.txt
  #echo $last_slavelog

  #echo last_slavelog
  #lastline=`tail -n1 ~/.tcbm/slave/slavelog.txt`
  #echo lastline $lastline
    #if ! [[ $lastline == standby* ]]
    #then

    #echo standby $olddate - $newdate >> ~/.tcbm/slave/slavelog.txt
    #else

    #fi
  sleep 0.5
  done
#standby end

  #echo $MYDATE standby >> slavelog.txt
  #sleep 2

elif [[ $USE_THIS_SLAVE == Yes ]] && [[ $PROCESSING == No ]] \
&& [[ $IS_THERE_A_JOB == Yes ]]
  then
  echo starting_new_job > slavestatus.txt
  echo $MYDATE starting new job >> slavelog.txt


  #STARTBEFEHL FÜR JOBFILE

elif [[ $USE_THIS_SLAVE == Yes ]] && [[ $PROCESSING == Yes ]]
  then
  echo at_work > slavestatus.txt
  render


elif [[ $USE_THIS_SLAVE == No ]] && [[ $PROCESSING == Yes ]]
  then
  echo last_job > slavestatus.txt



elif [[ $USE_THIS_SLAVE == No ]] && [[ $PROCESSING == No ]]
  then
  echo off > slavestatus.txt


else
  echo error > slavestatus

fi
#echo $last_slavelog >> ~/.tcbm/slave/slavelog.txt
#echo $last_slavelog
done
