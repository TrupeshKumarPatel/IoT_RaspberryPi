#!/bin/bash

for i in {0..60}
do
	asterisk -rx "sip show channelstats" >> $1.log
	sleep 1
done
