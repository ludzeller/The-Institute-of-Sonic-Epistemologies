#!/bin/bash

# generate jconvolver config script
# 2011-03-01 rumori/virtual mumuth/the choreography of sound

HELP=0
VERBOSE=0
TOTALEXCLIN=0;
TOTALEXCLOUT=0;

# get options
while getopts ":c:d:g:i:o:p:s:t:n:x:y:vhz" opt; do
    case $opt in
	c)
	    CHANNELS=$OPTARG
	    ;;
	d)
	    CHANOFFSET=$OPTARG
	    ;;
	g)
	    GAIN=$OPTARG
	    ;;
	i)
	    INPUTS=$OPTARG
	    ;;
	o)
	    OUTPUTS=$OPTARG
	    ;;
	p)
	    BASEPATH=$OPTARG
	    ;;
	s)
	    PARTSIZE=$OPTARG
	    ;;
	t)
	    MAXSIZE=$OPTARG
	    ;;
	n)
	    NAME=$OPTARG
	    ;;
	x)
	    EXCLIN=$OPTARG
	    ;;
	y)
	    EXCLOUT=$OPTARG
	    ;;
	v)
	    VERBOSE=1
	    ;;
	h)
	    HELP=1
	    ;;
	z)
	    NOHEADER=1
	    ;;
	\?)
	    echo "Invalid option: -$OPTARG" >&2
	    ;;
	:)
	    echo "Option -$OPTARG requires an argument." >&2
	    exit 1
	    ;;
    esac
done

# print help
if [ $HELP -eq 1 ]; then
    echo "$0" >&2
    echo "2011 virtual mumuth" >&2
    echo "$0 generates jconvolver config files on standard output from a list" >&2
    echo "of impulse response input files. http://www.kokkinizita.net" >&2
    echo "usage:" >&2
    echo -e "$0 [options] < input_file_list > output_configuration" >&2
    echo "command line options:" >&2
    echo -e "\t-c\tnumber of channels to use from each input file [channels of 1st input file]" >&2
    echo -e "\t-d\tchannel offset for each input file [0]" >&2
    echo -e "\t-g\tgain (linear amplitude) for all impulse responses [1.0]" >&2
    echo -e "\t-i\tnumber of inputs for convolution matrix [number of input files + input excludes]" >&2
    echo -e "\t-o\tnumber of outputs for convolution matrix [number of channels + output excludes]" >&2
    echo -e "\t-p\tbase path of input file location [current dir]" >&2
    echo -e "\t-s\tminimum partition size [512]" >&2
    echo -e "\t-t\tmaximum impulse response length [length of 1st impulse response]" >&2
    echo -e "\t-n\tname of configuration [noname]" >&2
    echo -e "\t-x\texclude input channels [index1,length1[,index2,length2[,...]]] [none]" >&2
    echo -e "\t-y\texclude output channels [index1,length1[,index2,length2[,...]]] [none]" >&2
    echo -e "\t-z\tdo not output file header, only matrix lines" >&2
    echo -e "\t-v\tverbose output" >&2
    echo -e "\t-h\tprint this help screen" >&2
    exit 0;
fi

# guess sed's option for extended regexps
for SED_EXTARG in -E -r; do
    echo "" | sed $SED_EXTARG -e "" &> /dev/null
    if [ $? -eq 0 ]; then break; fi;
done;

# parse sparse channels
for E in ${EXCLIN//,/ }; do
    EXCLINA[${#EXCLINA[*]}]=$E;
done
if [ $((${#EXCLINA[*]}%2)) -ne 0 ]; then
    echo "ERROR: number of arguments to -x is uneven"
    exit 1;
fi
for (( I=1; I<${#EXCLINA[*]}; I=I+2 )); do
    TOTALEXCLIN=$(($TOTALEXCLIN+${EXCLINA[$I]}));
done
for E in ${EXCLOUT//,/ }; do
    EXCLOUTA[${#EXCLOUTA[*]}]=$E;
done
if [ $((${#EXCLOUTA[*]}%2)) -ne 0 ]; then
    echo "ERROR: number of arguments to -y is uneven"
    exit 1;
fi
for (( I=1; I<${#EXCLOUTA[*]}; I=I+2 )); do
    TOTALEXCLOUT=$(($TOTALEXCLOUT+${EXCLOUTA[$I]}));
done

# read input file list
while read FILE; do
    FILES[${#FILES[*]}]=$FILE;
done

# guess defaults

# current dir if not specified
if [ -z $BASEPATH ]; then
    BASEPATH=`pwd`;
# else
#     cd $BASEPATH;
fi

# number of channels per file if not specified
if [ -z $CHANNELS ]; then
    CHANNELS=`sndfile-info $FILES | grep -e '^Channels' | sed $SED_EXTARG -e 's/^Channels[^0-9]*([0-9]+)/\1/g'`;
fi

# channel offset if not specified
if [ -z $CHANOFFSET ]; then
    CHANOFFSET=0;
fi

# std gain if not specified
if [ -z $GAIN ]; then
    GAIN=1;
fi

# number of input files if not specified
if [ -z $INPUTS ]; then
    INPUTS=$((${#FILES[*]}+$TOTALEXCLIN));
fi

# number of channels of first input file if not specified
if [ -z $OUTPUTS ]; then
    OUTPUTS=$(($CHANNELS+$TOTALEXCLOUT));
fi

# partition size 512 if not specified
if [ -z $PARTSIZE ]; then
    PARTSIZE=512;
fi

# duration of first input file if not specified
if [ -z $MAXSIZE ]; then
    MAXSIZE=`sndfile-info $FILES | grep -e '^Frames' | sed $SED_EXTARG -e 's/^Frames[^0-9]*([0-9]+)/\1/g'`;
fi

# sample name if not specified
if [ -z $NAME  ]; then
    NAME="noname";
fi

# print message
if [ $VERBOSE -eq 1 ]; then
    echo "$0" >&2
    echo "2011 virtual mumuth" >&2
    echo "config name: $NAME" >&2
    echo "base path: $BASEPATH" >&2
    echo "number of files: ${#FILES[*]}" >&2
    echo "channels per file: $CHANNELS" >&2
    echo "channel offset: $CHANOFFSET" >&2
    echo "gain for all irs [amp]: $GAIN" >&2
    echo "inputs: $INPUTS" >&2
    echo "outputs: $OUTPUTS" >&2
    echo "min partition size: $PARTSIZE" >&2
    echo "max impulse length: $MAXSIZE" >&2;
    for (( I=0; I < $((${#EXCLINA[*]}/2)); ++I )); do
	echo "exclude input channels region $(($I+1)): index: ${EXCLINA[$(($I*2))]}, length: ${EXCLINA[$((I*2+1))]}" >&2;
    done
    for (( I=0; I < $((${#EXCLOUTA[*]}/2)); ++I )); do
	echo "exclude output channels region $(($I+1)): index: ${EXCLOUTA[$(($I*2))]}, length: ${EXCLOUTA[$((I*2+1))]}" >&2;
    done
fi

# plausability checks
if [ $(($INPUTS*$OUTPUTS)) -ne $(((${#FILES[*]}+$TOTALEXCLIN)*($CHANNELS+$TOTALEXCLOUT))) ]; then
    echo "ERROR: number of inputs * outputs does not match number of files * channels" >&2
    exit 1;
fi
if [ $CHANNELS -gt $OUTPUTS ]; then
    echo "ERROR: number of channels per file greather than number of outputs" >&2
    exit 1;
fi

# generate config file head
if [ -z $NOHEADER ]; then
    echo "# jconvolver config file: $NAME"
    echo "# generated by $0 on `date`"
    echo -e "# virtual mumuth\n"

    echo -e "/cd\t$BASEPATH\n"

    echo "#                in  out   partition    maxsize"
    echo "# -----------------------------------------------"

    echo -e "/convolver/new\t$INPUTS\t$OUTPUTS\t$PARTSIZE\t$MAXSIZE\n"

# ports and names
    echo "#              num   port name     connect to"
    echo "# -----------------------------------------------"
    for (( I=1; I<=$INPUTS; ++I )); do
	echo -e "/input/name\t$I\tin_$I";
    done
    echo ""
    for (( I=1; I<=$OUTPUTS; ++I )); do
	echo -e "/output/name\t$I\tout_$I";
    done;
fi

# impulses and matrix
echo -e "\n#               in\tout\tgain\tdelay\toffset\tlength\tchan\tfile"
echo "#-----------------------------------------------------------------------------"
L=0
for (( I=1; I<=$INPUTS; ++I )); do
    
    # look for input exclusion
    for (( P=0; P < ${#EXCLINA[*]}; P=P+2 )); do
	if [ $I -eq ${EXCLINA[$P]} ]; then
	    I=$(($I+${EXCLINA[$(($P+1))]}));
	fi;
    done

    J=1
    while [ $J -le $OUTPUTS ]; do
	FILE=${FILES[L]}
	L=$(($L+1))
	for (( K=$((1+$CHANOFFSET)); K<=$(($CHANNELS+$CHANOFFSET)); ++K )); do
	    # look for output exclusion
	    for (( P=0; P < ${#EXCLOUTA[*]}; P=P+2 )); do
		if [ $J -eq ${EXCLOUTA[$P]} ]; then
		    J=$(($J+${EXCLOUTA[$(($P+1))]}));
		fi;
	    done
	    echo -e "/impulse/read\t$I\t$J\t$GAIN\t0\t0\t0\t$K\t$FILE";
	    J=$(($J+1))
	done;
    done;
done

# done
echo -e "\n# EOF"


# EOF
