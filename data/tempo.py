from os.path import join
from datetime import datetime, timedelta
import urllib
from urllib.request import urlopen
import json
import time

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
key = 'digite a key'
jsonlines_source = "jsonlines_source.txt"

for i in range(10):
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
        time.sleep(10)


