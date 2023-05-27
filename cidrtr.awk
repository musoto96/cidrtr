#!/usr/bin/awk
function bintodec(bin){
    # This function turns a binary number 
    #  or string representing one, into decimal.
    bin=bin""
    len=split(bin,arr,"")
    dec=0
    for(_i=0;_i<len;_i++){
        if(arr[_i+1]){
            dec+=2**(len-_i-1)
        }
    }
    return dec
}
function dectobin(dec){
    # This function turns a decimal number 
    #  or string representing one, into binary.
    dec=int(dec"")
    odec=dec
    if(dec==0)return(0)

    _bin=1
    binsum=0
    while(bintodec(binsum)<odec){
        _bin=1
        while(bintodec(_bin)<=dec){
            _bin=int(_bin"0")
        }
        _nbin=int(substr(_bin"",1,length(_bin"")-1))
        binsum+=_nbin
        dec-=bintodec(_nbin)
    }
    return binsum
}
function numtooctt(num){
    # This function turns an integer number
    #  representing a subnet, into octets.
    noct=int(num/8)
    roct=4-noct
    rem=num%8

    octt=""
    for(_j=0;_j<32;_j++){
        if(_j>0&&_j%8==0){octt=octt"."}
        if(_j<num){
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
    for(_k=1;_k<=4;_k++){
        if(_k>1){sbmsk=sbmsk"."}
        sbmsk=sbmsk bintodec(smsk[_k])
    }
    return sbmsk
}
function padbin(bin,blen){
    # This function will pad a binary
    #  number with zeroes to the left
    bin=bin""
    len=split(bin,arr,"")
    if(len<blen){
        for(_l=0;_l<blen-len;_l++){
            bin="0"bin
        }
        return bin
    }else{
        return bin
    }
}
function bintodecaddr(str) {
    # This recursive function will add
    #  dots every 8 characters for the octet
    if (length(str)<=8)
        return str;
    else
        return substr(str,1,8)"."bintodecaddr(substr(str,8+1));
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
addrbin=""
for(i=1;i<=4;i++){
    if(octs[i]>255){
        print("Invalid address.","Error on octet",i,":"octs[i])
    }else{
        addrbin=addrbin padbin(dectobin(octs[i]),8)
    }
}

# Mask validation
mask=cidr[2]
if(mask>32)print("Invalid mask:",mask)

# Computations
comp=32-mask
nhost=comp**2
submask=octettomask(numtooctt(mask))

host1=addrbin
gsub(".{"comp"}$",sprintf("%0"comp"d",1),host1)

hostn=addrbin
gsub(".{"comp"}$",sprintf("%*s",comp,""),hostn)
gsub(/ /,1,hostn)

# Report
printf("%-18s %s\n%-18s %s \- %s\n\n","CIDR","Range",$0,octettomask(bintodecaddr(host1"")),octettomask(bintodecaddr(hostn"")))
}

#
# RANGE
#  This awk block contains the code
#  to turn a range into CIDR notation.
#
/^[[:blank:]]*([0-9]{1,3}\.){3}[0-9]{1,3}[[:blank:]]*-?[[:blank:]]*([0-9]{1,3}\.){3}[0-9]{1,3}[[:blank:]]*$/{
print("Range Correct")

# Range validation
# TODO
#  Remove dots, and compare decimal number size
#  first number should be larger than second number
}
