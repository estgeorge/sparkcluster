from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

spark = SparkSession.builder \
    .appName("Pratica spark 2") \
    .getOrCreate() 

spark.sparkContext.setLogLevel("ERROR")

print("----------------------------------------------------------------")
print("Executando o job 2")
print("----------------------------------------------------------------")

df = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "node-master:9092") \
    .option("subscribe", "temperatura.public.tempo") \
    .option("startingOffsets", "earliest") \
    .load()


#schema1 = StructType([     
#    StructField("payload", StringType(), True)
#])
#
#schema2 = StructType([     
#    StructField("after", StringType(), True) 
#])
#
#schema3 = StructType([ 
#    StructField('datetime',StringType(), True),  
#    StructField('tempmax',FloatType(), True), 
#    StructField('tempmin',FloatType(), True),
#    StructField('humidity',FloatType(), True),
#    StructField('city',StringType(), True) 
#])
#
#dx = df.selectExpr("CAST(value AS STRING)") 
#     .select(from_json(col("value"), schema1).alias("data1")) \
#     .select(from_json(col("data1.payload"), schema2).alias("data2")) \
#     .select("data2.*") 


schema = StructType([
    StructField("payload", StructType([
        StructField("after", StructType([
            StructField('datetime',StringType(), True),  
            StructField('tempmax',FloatType(), True), 
            StructField('tempmin',FloatType(), True),
            StructField('humidity',FloatType(), True),
            StructField('city',StringType(), True) 
        ]))
    ]))
])

dx = df.select(from_json(df.value.cast("string"), schema).alias("data")) \
    .select("data.payload.after.*")

ds = dx.writeStream \
    .outputMode("append") \
    .format("console") \
    .option("truncate", False) \
    .start() \
    .awaitTermination()





