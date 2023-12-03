import os
from os.path import join
from datetime import datetime, timedelta
from urllib.request import urlopen
import json
import time
import argparse
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("city")
args = parser.parse_args()
city = args.city

# intervalo de datas
data_inicio = datetime.today()
data_fim = data_inicio + timedelta(days=1)

# formatando as datas
data_inicio = data_inicio.strftime('%Y-%m-%d')
data_fim = data_fim.strftime('%Y-%m-%d')

key = 'digite aqui sua chave'

URL = join("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/",
         f"{city}/{data_inicio}/{data_fim}?unitGroup=metric&include=days&key={key}&contentType=json")

f = urlopen(URL)
jsonString = f.read()
tempo = student_details = json.loads(jsonString)

jsonlines_source = "jsonlines_source.txt"
    
for day in tempo['days']:
    sel = {k: day.get(k, None) for k in ('datetime', 'tempmax', 'tempmin', 'humidity')}
    sel['city'] = city
    f = open(jsonlines_source, "a")
    f.writelines(json.dumps(sel)+"\n")
    f.close()    
    break

