#!/usr/bin/awk

BEGIN{
}

# CIDR
/^[[:blank:]]*([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}[[:blank:]]*$/{
split($0,cidr,"/")

# Address validation
addr=cidr[1]
split(addr,bytes,".")
for(i=1;i<=4;i++){
    if(bytes[i]>255){
        print("Invalid address.","Error on byte",i,":"bytes[i])
    }
}

# Mask validation
mask=cidr[2]
if(mask>32)print("Invalid mask:",mask)

}

# RANGE
/^[[:blank:]]*([0-9]{1,3}\.){3}[0-9]{1,3}[[:blank:]]*([0-9]{1,3}\.){3}[0-9]{1,3}[[:blank:]]*$/{print("Range Correct")}
