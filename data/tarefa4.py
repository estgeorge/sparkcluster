from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

spark = SparkSession.builder \
    .appName("Pratica spark") \
    .getOrCreate() 

spark.sparkContext.setLogLevel("ERROR")

df = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "node-master:9092") \
    .option("subscribe", "jsonlines") \
    .option("startingOffsets", "earliest") \
    .load()

schema1 = StructType([     
    StructField("schema", StringType(), True), 
    StructField("payload", StringType(), True)
])

schema2 = StructType([  
    StructField('datetime',StringType(), True),  
    StructField('tempmax',FloatType(), True), 
    StructField('tempmin',FloatType(), True),
    StructField('humidity',FloatType(), True),
    StructField('city',StringType(), True) 
])

dx = df.selectExpr("CAST(value AS STRING)") \
     .select(from_json(col("value"), schema1).alias("data1")) \
     .select(from_json(col("data1.payload"), schema2).alias("data2")) \
     .select("data2.*") 

#ds = dx.writeStream \
#    .outputMode("append") \
#    .format("console") \
#    .option("truncate", False) \
#    .start() \
#    .awaitTermination()    

def salva_postgresql(df, epoch_id):
    df.write.jdbc(
        url="jdbc:postgresql://postgres-db:5432/engdados",
        table="tempo",
        mode="append",
        properties={
            "user": "postgres",
            "password": "spark",
            "driver": "org.postgresql.Driver"
        }
	)

ds = dx.writeStream \
    .foreachBatch(salva_postgresql) \
    .start() \
    .awaitTermination() 
