from os.path import join
import urllib
from urllib.request import urlopen
import json
import time
from datetime import datetime, timedelta
from textwrap import dedent
from airflow import DAG
from airflow.operators.bash import BashOperator 
from airflow.operators.python_operator import PythonOperator

with DAG(
    "pratica_spark",
    default_args={
        "depends_on_past": True,
        "retries": 0,        
    },
    description="Pratica de airflow e spark",
    schedule=timedelta(days=1),
    start_date=datetime(2021, 1, 1),
) as dag:


    t0 = BashOperator(
        task_id="docker-compose-stop",
        bash_command="""
        cd ~/praticaspark
        docker compose stop 
        """ 
    )

    t1 = BashOperator(
        task_id="container-prune",
        bash_command="""
        docker container prune -f
        """ 
    )

    t2 = BashOperator(
        task_id="volume-prune",
        bash_command="""
        docker volume prune -f
        """ 
    )
    
    t3 = BashOperator(
        task_id="docker-compose-up",
        bash_command="""
        cd ~/praticaspark
        docker compose up -d
        sleep 40
        """ 
    )
    
    t4 = BashOperator(
        task_id="clean",
        bash_command="""
        docker exec -d --workdir /home/spark/data node-master bash /home/spark/data/clean.sh  
        """ 
    )
     
    t5 = BashOperator(
        task_id="kafka",
        bash_command="""
        docker exec -d --workdir /home/spark/data node-master bash /home/spark/data/bootstrap.sh 
        sleep 40
        """ 
    ) 
        
    t6 = BashOperator(
        task_id="submit-job",
        bash_command="""
        docker exec -d --workdir /home/spark/data node-master bash /home/spark/data/submit.sh
        """ 
    ) 
    
    
    def temperatura():
        cities = [
                  "Manaus","Macapá","Porto Velho","Rio Branco","Boa Vista","Belém","Palmas",
                  "Curitiba","Porto Alegre","Florianópolis","São Paulo","Rio de Janeiro",
                  "Belo Horizonte","Vitória","Goiânia","Cuiabá","Campo Grande" ,"Brasília",
                  "Recife","Salvador","Fortaleza","Natal","Aracaju","Maceió","São Luís",
                  "João Pessoa","Teresina"
        ]
        data_inicio = datetime.today()
        data_fim = data_inicio + timedelta(days=1)
        data_inicio = data_inicio.strftime('%Y-%m-%d')
        data_fim = data_fim.strftime('%Y-%m-%d')
        key = 'digite a key aqui'
        jsonlines_source = "/home/faraday/praticaspark/data/jsonlines_source.txt"

        for city in cities: 
            print(city)
            URL = join("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/",
                       f"{urllib.parse.quote(city)}/{data_inicio}/{data_fim}?unitGroup=metric&include=days&key={key}&contentType=json")
            f = urlopen(URL)
            jsonString = f.read()
            tempo = student_details = json.loads(jsonString)
            day = tempo['days'][0]
            sel = {k: day.get(k, None) for k in ('datetime', 'tempmax', 'tempmin', 'humidity')}
            sel['city'] = city
            f = open(jsonlines_source, "a")
            f.writelines(json.dumps(sel,ensure_ascii=False)+"\n")
            f.close()    
            time.sleep(3)        
        
        
    t7 = PythonOperator(
        task_id='download_temperatura',
        python_callable=temperatura)        
                
    t0 >> [t1, t2]
    [t1, t2] >> t3
    t3 >> [t4, t5] 
    [t4, t5] >> t6 >> t7
    
    

