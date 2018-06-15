#!/bin/bash
touch ~/Desktop/pingTest.log
server="ad1.ad.jamfsw.corp"
ping -c 5000 -s 1024 $server > ~/Desktop/pingTest.log
