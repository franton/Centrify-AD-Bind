#!/bin/bash

adbindact="$3"
adbindpwd="$4"
domain="$5"

if [ -z "$adbindact" ] || [ -z "$adbindpwd" ] || [ -z "$domain" ];
then
	echo "Missing parameter!"
	echo "AD account: $adbindact"
	echo "AD password: $adbindpwd"
	echo "AD domain: $domain"
	exit 1
fi

host=$( /bin/hostname -s )

LOGFOLDER="/private/var/log/"
LOG=$LOGFOLDER"/Centrify-AD-Bind.log"

if [ ! -d "$LOGFOLDER" ];
then
	mkdir $LOGFOLDER
fi

# Set functions here

function logme()
{
# Check to see if function has been called correctly
	if [ -z "$1" ]
	then
		/bin/echo $( /bin/date )" - logme function call error: no text passed to function! Please recheck code!"
		exit 1
	fi

# Log the passed details
	/bin/echo $( /bindate )" - "$1 >> $LOG
	/bin/echo "" >> $LOG
}

echo "Centrify AD Bind Script - started at "$( date ) > $LOG

# Is computer a desktop or laptop?

model=$( /usr/sbin/sysctl -n hw.model | grep "Book" )

if [ "$model" != "" ];
then
	# Laptop bind here
	logme "Binding a laptop computer"
	logme "Domain: $domain"
	logme "Hostname: $host"
	/usr/local/sbin/adjoin -w -u $adbindact -p $adbindpwd -c "OU=" -n $host $domain | tee -a ${LOG}
else
	# Desktop bind here
	logme "Binding a desktop computer"
	logme "Domain: $domain"
	logme "Hostname: $host"
	/usr/loca/sbin/adjoin -w -u $adbindact -p $adbindpwd -c "OU=" -n $host $domain | tee -a ${LOG}
fi

# Update, reload and flush AD settings

logme "Enabling Centrify Licenced features"
/usr/local/bin/adlicense --licensed
logme "Reloading AD settings"
/usr/local/sbin/adreload | tee -a ${LOG}
logme "Flushing AD settings"
/usr/local/sbin/adflush | tee -a ${LOG}

# Wait 5 seconds and quit

/bin/sleep 5
exit 0
