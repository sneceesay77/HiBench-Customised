#!/bin/bash
#echo "Generating Data Using Teragen"
#hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.0.2.jar teragen 5242880 input500
#dataSize=(500 750 1024 1536 2048 2560 3072 4096 4608 5120)
#inumReducer=$((1 + RANDOM % 5))
#echo $numReducer
scaleProfile=(tiny small)
#scaleProfile=(huge)
#scaleProfile=(huge)
for i in "${scaleProfile[@]}"
do
   sed -i.bak  s/"hibench.scale.profile.*"/"hibench.scale.profile     $i"/g conf/hibench.conf

   sed -i.bak  s/"hibench.yarn.executor.num.*"/"hibench.yarn.executor.num     32"/g conf/spark.conf
   sed -i.bak  s/"spark.executor.memory.*"/"spark.executor.memory     8g"/g conf/spark.conf
   sed -i.bak  s/"hibench.yarn.executor.cores.*"/"hibench.yarn.executor.cores     8"/g conf/spark.conf
   sed -i.bak  s/"spark.driver.memory.*"/"spark.driver.memory     4g"/g conf/spark.conf

   echo Generatig Data
   bin/workloads/micro/wordcount/prepare/prepare.sh
   echo Data Generation Finished
   numExecutor=(4 8 16 24 32)
   #numExecutor=(32)
   for j in "${numExecutor[@]}"
   do
	 sed -i.bak  s/"hibench.yarn.executor.num.*"/"hibench.yarn.executor.num     $j"/g conf/spark.conf
	 executorMem=(2 4 6 8)
	 for k in "${executorMem[@]}"
	 do
            sed -i.bak  s/"spark.executor.memory.*"/"spark.executor.memory     $k"g/g conf/spark.conf
            numCores=(2 4 6 8)
	    for l in "${numCores[@]}"
            do
	      sed -i.bak  s/"hibench.yarn.executor.cores.*"/"hibench.yarn.executor.cores     $l"/g conf/spark.conf
	      levelOfPar=(8 16 32 64)
	      for m in "${levelOfPar[@]}"
	      do
		 echo Running benchmark with $i datasize numExe=$j exeMem=$k numCore=$l levelOfPar=$m Confirugration
		 #sed -i.bak  s/"spark.driver.memory.*"/"spark.driver.memory     $m"g/g conf/spark.conf
		 sed -i.bak  s/"^spark.default.parallelism.*"/"spark.default.parallelism     $m"/g conf/spark.conf
		 sed -i.bak  s/"^spark.sql.shuffle.partitions.*"/"spark.sql.shuffle.partitions    $m"/g conf/spark.conf
		 codec=("lz4" "lzf" "snappy" "zstd")
		 for n in "${codec[@]}"
	         do
		   sed -i.bak  s/"spark.io.compression.codec.*"/"spark.io.compression.codec     $n"/g conf/spark.conf
		   ssc=("true" "false")
		   for o in "${ssc[@]}"
		   do
		     sed -i.bak  s/"spark.shuffle.compress.*"/"spark.shuffle.compress     $o"/g conf/spark.conf
		     sssc=("true" "false")
		     for p in "${sssc[@]}"
		     do
		       sed -i.bak  s/"spark.shuffle.spill.compress.*"/"spark.shuffle.spill.compress     $p"/g conf/spark.conf
		       sbc=("true" "false")
		       for q in "${sbc[@]}"
		       do
			 sed -i.bak  s/"spark.broadcast.compress.*"/"spark.broadcast.compress     $q"/g conf/spark.conf
			 bin/workloads/micro/wordcount/spark/run.sh
		       done
		     done
	   	   done
	   	 done
	      done
	    done	    
	 done
   done
done
