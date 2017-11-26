#!/bin/bash

#cd ~
#mkdir .tcbm
#cd .tcbm
#mkdir client
#cd client
#mkdir tmp
#cd tmp
#mkdir job

USE_THIS_SLAVE=Yes #use this slave Yes/No
PROCESSING=No #(noch zu programmieren ist nur ein vorübergender platzhalter)
LAST_SLAVELOG="STARTUPSLAVE" #text für logfile bei Computerneustart


rm ~/.tcbm/slave/last_slavelog.txt
rm ~/.tcbm/slave/slavelog.txt #nur vorübergehend zur fehlersuche


echo
echo

echo $LAST_SLAVELOG >> ~/.tcbm/slave/last_slavelog.txt



while [[ 1 == 1 ]]
do

  LAST_SLAVELOG=`<~/.tcbm/slave/last_slavelog.txt`

  if [[ $LAST_SLAVELOG == STARTUPSLAVE ]]                                       #eventuel noch durch if; elif; fi ersetzen
  then
  echo $LAST_SLAVELOG
  echo $LAST_SLAVELOG >> ~/.tcbm/slave/slavelog.txt
  fi

  #LAST_SLAVELOG_LINE=`tail -n1 ~/.tcbm/slave/slavelog.txt`
  if [[ $LAST_SLAVELOG == executejob* ]]
  then
  echo $LAST_SLAVELOG
  echo $LAST_SLAVELOG >> ~/.tcbm/slave/slavelog.txt
  fi

  if [[ $LAST_SLAVELOG == standby* ]]
  then
  echo $LAST_SLAVELOG
  echo $LAST_SLAVELOG >> ~/.tcbm/slave/slavelog.txt
  fi




OLDDATE=`date`    #starting time of current status

#standby start
  if [[ $USE_THIS_SLAVE == Yes ]] && [[ $PROCESSING == No ]]    #test if this slave is activated and is not working on a job
  then

    if ! [[ -f ~/.tcbm/slave/tmp/job.tcbm ]]    #test if a new jobfile is not available
    then

      while ! [[ -f ~/.tcbm/slave/tmp/job.tcbm ]]   #if no new jobfile is available set status to standby
      do
      echo standby > ~/.tcbm/slave/slavestatus.txt
      NEWDATE=`date`    #ending time of current status
      echo standby $OLDDATE $NEWDATE > ~/.tcbm/slave/last_slavelog.txt
      sleep 1
      done

  	elif [[ -f ~/.tcbm/slave/tmp/job.tcbm ]]
  	then

    	while [[ 1 == 1 ]]
    	do
    	echo executejob > ~/.tcbm/slave/slavestatus.txt
    	sleep 3 #wird noch durch entsprechenden Befehl ersetzt
    	NEWDATE=`date`
    	echo executejob $OLDDATE $NEWDATE > ~/.tcbm/slave/last_slavelog.txt
    	echo executejob $OLDDATE $NEWDATE
    	sleep 1
    	done

  	fi

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

done
