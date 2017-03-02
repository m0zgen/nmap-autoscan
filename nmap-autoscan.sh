#!/bin/bash
#
# ---------------------------------------------------------- ENVs #
#
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
# Determine script location
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
# Script name
me=`basename "$0"`

# ---------------------------------------------------------- VARs #
#
IP=$1
dta=$(date +%d-%m-%Y-%H-%M-%S)
# dta=$(date +%d-%m-%Y)

SCANFOLDER=$SCRIPT_PATH/scans
SCANPREV=$SCANFOLDER/prev.xml
SCANCURR=$SCANFOLDER/scan-$dta

# ---------------------------------------------------------- CHKs #
#
if [[ -z $IP ]]; then
  #statements
  echo "Please ask IP"
  exit
fi

if [[ ! -d $SCANFOLDER ]]; then
  mkdir $SCANFOLDER
fi

# ---------------------------------------------------------- ACTs #
#
cd $SCANFOLDER

nmap -T4 -F -Pn $IP -oA $SCANCURR > /dev/null

if [[ -L $SCANPREV ]]; then
    ndiff $SCANPREV $SCANCURR.xml > diff-result

    if [[ -n `grep "open" diff-result` ]]; then
      echo "Achtung"
    fi
fi

ln -sf $SCANCURR.xml $SCANPREV
