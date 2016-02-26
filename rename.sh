#!/bin/bash

for i in $(ls)
do	
	NAME=$(echo $i|sed -E -e"s/\{(.*)\}/\1/")
	echo $NAME
	mv $i $NAME
done

