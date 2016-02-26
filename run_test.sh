#!/bin/bash

	TMP_DIFF=_diff_tmp.txt
	TMP_OUT=_out_tmp.txt
	OUTPUT=output.txt
	TESTS="$(ls tests/ | sed -r -e '/([a-z]+_test_[0-9]+\.c)/!d' | sed -r -e 's%([a-z]+_test_[0-9]+\.c)%tests/\1%')"
	TEST_LIST=test_list.txt
	DUMP=dump.txt
	#EXPECTS=ls | grep -e 'expect_[0-1]+.txt'
	WD="$(pwd)"
	PARENT="$(cd .. && pwd)"
	#echo $TESTS
	
	


TEST_NAME=	
TEST_NUM=0
DUMP_OUT=0
PRINT_OUT=0
PASSED=0

while [ "$1" != "" ]; do
    case $1 in
        -t )        shift
					TEST_NUM=$1
					shift
					TEST_NAME=$1
                        ;;
        -o )    	PRINT_OUT=1
                        ;;
        -d )    	DUMP_OUT=1
                        ;;
        -p )    	PASSED=1
                        ;;
    esac
	shift
done

	if [ "$TEST_NUM" = "0" ];
	then
		echo "" > $OUTPUT
		echo "" > $DUMP
		for t in $TESTS;
		do
			NUM="$(echo $t | sed -r -e 's/tests\/([a-z]+)_test_([0-9]+)\.c/\2/')"
			NAME="$(echo $t | sed -r -e 's/tests\/([a-z]+)_test_([0-9]+)\.c/\1/')"
			EXPECT="$(echo "tests/${NAME}_expect_${NUM}.txt")"
			TEST_TYPE="$(echo "$(cat  tests/${NAME}_${TEST_LIST})" | sed -n ${NUM}p)"
			cat $t | ${PARENT}/parse > ${TMP_OUT}
			diff -w ${TMP_OUT} ${EXPECT} > ${TMP_DIFF}
			
			if [ -s ${TMP_DIFF} ]
			then
			    echo "${t}\t\tFAILED"
			    echo "\n\nIN $TEST_TYPE : \n" >> ${OUTPUT} 	 	
			    cat ${TMP_DIFF} >> ${OUTPUT} 	
			    echo "\n\nIN $t : \n" >> ${DUMP}
			    cat ${TMP_OUT} >> ${DUMP}
			else
				if [ "$PASSED" = "1" ];
				then
					echo "${t}\t\tPASSED" 
				fi
			fi	
		done
	else
		echo "OUTPUT WAS: \n"
			cat tests/${TEST_NAME}_test_${TEST_NUM}.c | ${PARENT}/parse 
		echo "\n\nTEST: \n"
			cat tests/${TEST_NAME}_test_${TEST_NUM}.c
		echo "\n\nEXPECTED: \n"
			cat tests/${TEST_NAME}_expect_${TEST_NUM}.txt
		echo "\n\n"
	fi
	
	if [ "$PRINT_OUT" = "1" ];
	then
		echo "\n\nDIFFERENCES: "
		cat $OUTPUT
	fi
	if [ "$DUMP_OUT" = "1" ];
	then
	echo "\n\nDUMP: "
	cat $DUMP
	fi
