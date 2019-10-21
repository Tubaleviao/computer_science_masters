def waait(): Unit = {for(i <- 1 to 10) {print(i);Thread.sleep(1000);}}
val dataset = sc.textFile("sleepstudy.csv")
dataset.takeOrdered(10).foreach(println)
waait()
var columns = dataset.map(line => line.split(","))
var filtered = columns.filter(_(0)!="\"\"")

// average ms
var mapped = filtered.map(line => (line(3), (line(1).toDouble, line(1).toDouble) ))
var maxMin = mapped.reduceByKey((x,y) => (Math.min(x._1,y._1), Math.max(x._2,y._2)) )
var population = maxMin.map(rec => (rec._1, rec._2._1-rec._2._2)).collect()
population.foreach(println)
waait()
var parallelized = sc.parallelize(population)
var sample = parallelized.sample(false, 0.5).cache
sample.foreach(println)
var avgSum = sample.reduce((a, b) => ("sum", a._2+b._2))._2 / sample.count
var resamples = 10
println("Total population ms average: "+ parallelized.reduce((a,b) => ("sum", a._2+b._2))._2 / parallelized.count)
println("Sample average: "+avgSum)
for(i <- 1 to resamples-1) {
	var resample = sample.sample(true, 1)
	avgSum += resample.reduce((a, b) => ("sum", a._2+b._2))._2 / resample.count
}
println(resamples+" resample average: "+ (avgSum/10))

// mean of ms by additional day
var mbd_pop = filtered.map(line => (line(2), line(1).toDouble))
var sum_count = mbd_pop.map(x => (x._1, (x._2, 1)))
var sum_count_day = sum_count.reduceByKey((a,b) => (a._1+b._1, a._2+b._2))
var avg_by_day = sum_count_day.map(x => (x._1, x._2._1/x._2._2))

avg_by_day.sortBy(_._1.toInt).takeOrdered(10).foreach(println)
