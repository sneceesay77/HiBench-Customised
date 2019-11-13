#!/bin/bash
oneMegaByte=1048576
oneGigaByte=1073741824
for i in {100..10000..100}
do
   hadoop fs -rm -r -skipTrash hdfs://node1:9000/HiBench/Terasort/Input
   numBytes=$(( $oneMegaByte*$i ))
   numRows=$(( $numBytes/100 ))
   #hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.0.2.jar randomtextwriter -D mapreduce.randomtextwriter.totalbytes=$numBytes  -D mapreduce.job.reduces=8 hdfs://node1:9000/HiBench/Sort/Input
   #hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.0.2.jar randomtextwriter -D mapreduce.randomtextwriter.totalbytes=$numBytes  -D mapreduce.job.reduces=8 hdfs://node1:9000/HiBench/Wordcount/Input
   echo "Generating $numRows Rows"
   hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.0.2.jar teragen -D mapreduce.job.reduces=8  $numRows hdfs://node1:9000/HiBench/Terasort/Input 
   #bin/workloads/micro/wordcount/hadoop/run.sh
   bin/workloads/micro/terasort/hadoop/run.sh

   #delete output directory
   hadoop fs -rm -r -skipTrash hdfs://node1:9000/HiBench/Terasort/Input
   hadoop fs -rm -r -skipTrash hdfs://node1:9000/HiBench/Terasort/Output
done

