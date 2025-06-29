### Run this on startup
from datetime import datetime
import logging
import requests

from datasets import Dataset, DatasetDict
import pandas as pd

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# querying dumpster spots for the whole world
url = "https://dumpstermap.herokuapp.com/dumpsters/withinbounds/-180/-90/180/90/"
response = requests.get(url)
entry = response.json()
dumpsters = entry["features"]

cols = ["Latitude", "Longitude", "dumpster_created", "voting", "comment", "voting_created", "name"]

dumpsters_df = pd.DataFrame(columns=cols)
num_dumpsters = len(dumpsters)

logging.info("Starting to process dumpsters")
for i, dumpster in enumerate(dumpsters):
    if i % 100 == 0:
        logging.info(f"Processing dumpster {i}/{num_dumpsters}")
    url = f"https://dumpstermap.herokuapp.com/dumpsters/{dumpster['id']}"
    response = requests.get(url)
    if response.status_code != 200:
        logging.info("Problem fetching from:", url, response.status_code)
    try:
        entry = response.json()

        rows = []
        lat = entry['geometry']['coordinates'][1]
        lon = entry['geometry']['coordinates'][0]
        dumpster_created = entry['properties']['created']

        for vote in entry['properties']['voting_set']:
            rows.append({
                "Latitude": lat,
                "Longitude": lon,
                "dumpster_created": dumpster_created,
                "voting": vote['value'],
                "comment": vote['comment'],
                "voting_created": vote['created_date'],
                "name": vote['name']
            })

        if rows:
            dumpsters_df = pd.concat([dumpsters_df, pd.DataFrame(rows)], ignore_index=True)
    except Exception as e:
        logging.info(e)

logging.info("Finished processing dumpsters")

dumpsters_df.sort_values("dumpster_created", inplace=True, ascending=False)

dataset = Dataset.from_pandas(dumpsters_df)
dataset_dict = DatasetDict({datetime.now().strftime("%Y.%m.%d"): dataset})
dataset_dict.push_to_hub("Hitchwiki/dumpster-diving-spots")

logging.info("Dataset pushed to Hugging Face Hub")

    
