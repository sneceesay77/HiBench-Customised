#!/bin/bash
stop-all.sh
/usr/local/spark/sbin/stop-all.sh
/usr/local/hadoop/sbin/mr-jobhistory-daemon.sh stop historyserver
/usr/local/spark/sbin/stop-history-server.sh

