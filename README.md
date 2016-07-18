# Centrify-AD-Bind

As of 14th July 2016, Casper still has an outstanding defect (D-009723) with it's inbuilt Centrify binding. Accordingly I have scripted a replacement until this is fixed.

Usage: ./CentrifyBindtoAD.sh "" "" "" "bind account" "bind password" "domain" "ldap path"

The script checks for the information above, fails if it doesn't get them (and tells you which one!) then will then bind to the appropriate OU based on that information.
