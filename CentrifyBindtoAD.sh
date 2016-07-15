#!/bin/bash

adbindact="$3"
adbindpwd="$4"
domain="$5"
ltldappath="$6"
dkldappath="$7"

host=$( /bin/hostname -s )

LOGFOLDER="/private/var/log"
LOG=$LOGFOLDER"/Centrify-AD-Bind.log"

function logme()
{
# Check to see if function has been called correctly
	if [ -z "$1" ]
	then
		/bin/echo $( /bin/date )" - logme function call error: no text passed to function! Please recheck code!"
		exit 1
	fi

# Log the passed details
	/bin/echo $( /bin/date )" - "$1 >> $LOG
	/bin/echo "" >> $LOG
}

if [ ! -d "$LOGFOLDER" ];
then
	mkdir $LOGFOLDER
fi

logme "Centrify AD Bind Script"

if [ -z "$adbindact" ] || [ -z "$adbindpwd" ] || [ -z "$domain" ] || [ -z "$ltldappath" ] || [ -z "$dkldappath" ];
then
	logme "Missing parameter!"
	logme "AD account: $adbindact"
	logme "AD password: $adbindpwd"
	logme "AD domain: $domain"
	logme "Laptop LDAP path: $ltldappath"
	logme "Desktop LDAP path: $dkldappath"
	cat ${LOG}
	exit 1
fi

# Is computer a desktop or laptop?

model=$( /usr/sbin/sysctl -n hw.model | grep "Book" )

if [ "$model" != "" ];
then
	# Laptop bind here
	logme "Binding a laptop computer"
	logme "Domain: $domain"
	logme "Hostname: $host"
	/usr/local/sbin/adjoin -w -u $adbindact -p $adbindpwd -c $ltldappath -n $host $domain 2>&1 | tee -a ${LOG}
else
	# Desktop bind here
	logme "Binding a desktop computer"
	logme "Domain: $domain"
	logme "Hostname: $host"
	/usr/loca/sbin/adjoin -w -u $adbindact -p $adbindpwd -c $dkldappath -n $host $domain 2>&1 | tee -a ${LOG}
fi

# Update, reload and flush AD settings

logme "Enabling Centrify Licenced features"
/usr/local/bin/adlicense --licensed 2>&1 | tee -a ${LOG}
logme "Reloading AD settings"
/usr/local/sbin/adreload 2>&1 | tee -a ${LOG}
logme "Flushing AD settings"
/usr/local/sbin/adflush 2>&1 | tee -a ${LOG}

# Wait 5 seconds and quit

/bin/sleep 5
exit 0
