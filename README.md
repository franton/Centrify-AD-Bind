# Centrify-AD-Bind

As of 14th July 2016, Casper still has an outstanding defect (D-009723) with it's inbuilt Centrify binding. Accordingly I have scripted a replacement until this is fixed.

Usage: ./CentrifyBindtoAD.sh "" "" "bind account" "bind password" "domain" "laptop ldap path" "desktop ldap path"

The script checks for the information above, fails if it doesn't get them (and tells you which one!) then does a check to see if you are on a laptop or not. It will then bind to the appropriate OU based on that information.

This was written in mind for an AD structure that has separate OU's for desktops and laptops. If this isn't the case for you, the code is easy to chop down to a single OU.

The OU is hard coded as I had problems elsewhere with variables not passing properly to the adjoin account. Suggestions to fix this and make the script more "universal" are welcome!
