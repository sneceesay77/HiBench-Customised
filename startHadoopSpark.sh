#!/bin/bash
start-all.sh
/usr/local/spark/sbin/start-all.sh
/usr/local/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
/usr/local/spark/sbin/start-history-server.sh

