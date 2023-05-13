#!/usr/bin/awk

function bintodec(bin){
    # This function turns a binary number 
    #  or string representing one, into a decimal.
    bin=bin""
    len=split(bin,arr,"")
    dec=0
    for(i=0;i<len;i++){
        if(arr[i]){
            dec+=2**(len-i)
        }
    }
    return dec
}
function numtooctt(num){
    # This function turns an integer number
    #  into octets (or bytes).
    noct=int(num/8)
    roct=4-noct
    rem=num % 8

    octt=""
    for(i=0;i<32;i++){
        if(i>0&&i%8==0){octt=octt"."}
        if(i<num){
            octt=octt"1"
        }else{
            octt=octt"0"
        }
    }
    return octt
}

function octettomask(octet){
    # This function turns octets 
    #  into into a subnet mask
    split(octet,smsk,".")

    sbmsk=""
    for(j=1;j<=4;j++){
        if(j>1){sbmsk=sbmsk"."}
        sbmsk=sbmsk bintodec(smsk[j])
    }
    return sbmsk
}

BEGIN{
}

#
# CIDR
#  This awk block contains the code
#  to turn CIDR into a range.
#
/^[[:blank:]]*([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}[[:blank:]]*$/{
split($0,cidr,"/")

# Address validation
addr=cidr[1]
split(addr,octs,".")
for(i=1;i<=4;i++){
    if(octs[i]>255){
        print("Invalid address.","Error on octet",i,":"octs[i])
    }
}
# Mask validation
mask=cidr[2]
if(mask>32)print("Invalid mask:",mask)

comp=32-mask
nhost=comp**2
inoct=numtooctt(mask)
submask=octettomask(inoct)
print submask

}

#
# RANGE
#  This awk block contains the code
#  to turn a range into CIDR notation.
#
/^[[:blank:]]*([0-9]{1,3}\.){3}[0-9]{1,3}[[:blank:]]*([0-9]{1,3}\.){3}[0-9]{1,3}[[:blank:]]*$/{print("Range Correct")}
