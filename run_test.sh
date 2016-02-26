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
		    echo "$t FAILED"
		    echo "\n\nIN $TEST_TYPE : \n" >> ${OUTPUT} 	 	
		    cat ${TMP_DIFF} >> ${OUTPUT} 	
		    echo "\n\nIN $t : \n" >> ${DUMP}
		    cat ${TMP_OUT} >> ${DUMP} 
		else
			echo "$t PASSED" 
		fi	
	done

	echo "\n\nDIFFERENCES: "
	cat $OUTPUT
	echo "\n\nDUMP: "
	cat $DUMP
