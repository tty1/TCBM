#!/bin/bash

	#Tom's Cluster Batch Manager (slave)
	#Version 0.06

		TMP_LOCATION= $(sed -n '2{p;q}' slave_config.txt)
		CONFIG_LOCATION=~/.config/tcbm/slave/
		USE_THIS_SLAVE=`<"$CONFIG_LOCATION"use_this_slave`
		LANGUAGE=de
		MAX_CPU_LOAD=	# dont start a job if the CPU-load is over nn$
		MAX_MEM_LOAD=	# dont start a job if the memory-load is over
		MIN_LOAD=
		MAX_LOAD_TIME=
		MIN_LOAD_TIME=
		PROCESSING=No #(noch zu programmieren ist nur ein vorübergender platzhalter)
		LAST_SLAVELOG="STARTUPSLAVE" #text für logfile bei Computerneustart

		typeset -i MEMTOTAL MEMFREE PROZENT PROZENT_FREE MEMAV MEM
		MEMTOTAL=`cat /proc/meminfo | grep MemTotal* | sed -n s/\ /"\n"/gp | grep '[0-9]'`
		MEMFREE=`cat /proc/meminfo | grep MemFree* | sed -n s/\ /"\n"/gp | grep '[0-9]'`
		MEMAV=`cat /proc/meminfo | grep MemAvailable* | sed -n s/\ /"\n"/gp | grep '[0-9]'`
		MEM=$MEMAV+$MEMFREE
		PROZENT_FREE=100*$MEM/$MEMTOTAL
		PROZENT=100-$PROZENT_FREE
		echo $PROZENT


cd ~
mkdir .tcbm
cd .tcbm
mkdir slave
cd slave
mkdir tmp
cd tmp
mkdir job

USE_THIS_SLAVE=Yes #use this slave Yes/No
PROCESSING=No #(noch zu programmieren ist nur ein vorübergender platzhalter)
LAST_SLAVELOG="STARTUPSLAVE" #text für logfile bei Computerneustart

#rm ~/.tcbm/slave/last_slavelog.txt
#rm ~/.tcbm/slave/slavelog.txt #nur vorübergehend zur fehlersuche

case $1 in
	--help)		cat ~/opt/tcbm/files/help.txt
	;;
	--version)
	#version $(sed -n '2{p;q}' tcbm.sh)
	echo "VERSION"
	echo $VERSION
	;;
	--1st)		echo first_setup
	;;
	--config)
		echo setup

	;;
	--stop)		echo stop
	;;
	--start)	echo start_the_rest
	echo $LAST_SLAVELOG >> ~/.tcbm/slave/last_slavelog.txt
	while [[ 1 == 1 ]]; do	# --start
		OLDDATE=`date`    #starting time of current status
		LAST_SLAVELOG=`<~/.tcbm/slave/last_slavelog.txt`

		#top bla bla bla
		#PROCESSING=Yes/NO

		if [[ $LAST_SLAVELOG == STARTUPSLAVE ]]; then                                  #eventuel noch durch if; elif; fi ersetzen
			echo $LAST_SLAVELOG
			echo >> ~/.tcbm/slave/slavelog.txt
			echo $LAST_SLAVELOG >> ~/.tcbm/slave/slavelog.txt
			echo >> ~/.tcbm/slave/slavelog.txt
			sleep 5
		fi

		if [[ $LAST_SLAVELOG == executejob* ]]; then
			echo $LAST_SLAVELOG
			echo $LAST_SLAVELOG >> ~/.tcbm/slave/slavelog.txt
		fi

		if [[ $LAST_SLAVELOG == standby* ]]; then
			echo $LAST_SLAVELOG
			echo $LAST_SLAVELOG >> ~/.tcbm/slave/slavelog.txt
		fi

		if [[ $USE_THIS_SLAVE == Yes ]] && [[ $PROCESSING == No ]];then    #test if this slave is activated and is not working on a job

			if ! [[ -f ~/.tcbm/slave/tmp/job.tcbm ]]; then    #test if a new jobfile is not available
				while ! [[ -f ~/.tcbm/slave/tmp/job.tcbm ]]; do  #if no new jobfile is available set status to standby
					NEWDATE=`date`    #ending time of current status
					echo standby > ~/.tcbm/slave/slavestatus.txt
					echo standby $OLDDATE $NEWDATE > ~/.tcbm/slave/last_slavelog.txt
					sleep 5
				done

			elif [[ -f ~/.tcbm/slave/tmp/job.tcbm ]]; then
				while [[ -f ~/.tcbm/slave/tmp/job.tcbm ]]; do
				#while [[ 1 == 1 ]]; do
					echo executejob > ~/.tcbm/slave/slavestatus.txt
					sleep 3 #wird noch durch entsprechenden Befehl ersetzt
					NEWDATE=`date`
					echo executejob $OLDDATE $NEWDATE > ~/.tcbm/slave/last_slavelog.txt
					echo executejob $OLDDATE $NEWDATE
					sleep 1
				done

			fi

		elif [[ $USE_THIS_SLAVE == Yes ]] && [[ $PROCESSING == Yes ]]; then
			echo "the system is used for an other task" > slavestatus.txt
			# render

		elif [[ $USE_THIS_SLAVE == No ]] && [[ $PROCESSING == Yes ]]; then
			echo last_job > slavestatus.txt

		elif [[ $USE_THIS_SLAVE == No ]] && [[ $PROCESSING == No ]]; then
			echo off > slavestatus.txt

		else
			echo error > slavestatus

		fi

	done

	;;
	*)				echo "--help and you got more information"
esac
