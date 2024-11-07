#create index stations in elasticsearch
def create_index_station(client, index,mapping) -> None:
    if not client.indices.exists(index=index):
        client.indices.create(index=index,body=mapping)
    return





if __name__ == "__main__":

    
    from elasticsearch import Elasticsearch
    mapping = {
        "mappings": {
            "properties": {
            "numbers": { "type": "integer" },
            "contract_name": { "type": "text" },
            "banking": { "type": "text" },
            "bike_stands": { "type": "integer" },
            "available_bike_stands": { "type": "integer" },
            "available_bikes": { "type": "integer" },
            "address": { "type": "text" },
            "status": { "type": "text" },
            "position": {
                "type": "geo_point",
                "lat_lon": True
            },
            "last_update": { "type": "text" }
            }
        }
        }

    es = Elasticsearch("http://localhost:9200")
    create_index_station(client=es, index="velibstations",mapping=mapping)
   
