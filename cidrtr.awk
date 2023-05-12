#!/usr/bin/awk
# CIDR
/^[ ]*([0-9]{1,3}\.){3}[0-9]{1,3}[ ]*$/{print "CIDR Correct"}
# RANGE
/^[ ]*([0-9]{1,3}\.){3}[0-9]{1,3}[ ]*([0-9]{1,3}\.){3}[0-9]{1,3}/{print "Range Correct"}
