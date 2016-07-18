#!/bin/bash

# Centrify AD binding script for Casper / macOS

adbindact="$4"
adbindpwd="$5"
domain="$6"
ldappath="$7"

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
}

if [ ! -d "$LOGFOLDER" ];
then
	mkdir $LOGFOLDER
fi

echo $( /bin/date )" - Centrify AD Bind Script" > $LOG

if [ -z "$adbindact" ] || [ -z "$adbindpwd" ] || [ -z "$domain" ] || [ -z "$ldappath" ];
then
	logme "Missing parameter!"
	logme "AD account: $adbindact"
	logme "AD password: $adbindpwd"
	logme "AD domain: $domain"
	logme "LDAP path: $ldappath"
	cat ${LOG}
	exit 1
fi

logme "Binding computer to AD"
logme "Domain: $domain"
logme "Hostname: $host"
/usr/local/sbin/adjoin -w -u $adbindact -p $adbindpwd -c "$ldappath" -n $host $domain 2>&1 | tee -a ${LOG}

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
