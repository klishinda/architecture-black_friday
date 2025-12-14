## 1. Запустить сервис
```shell
docker compose -f compose.yaml up -d
```

## 2. Проверить, что всё развернулось: у всех статус UP и healthy (последнее кроме pymongo_api)
```shell
docker compose -f compose.yaml ps
```

## 3. Зайти на адрес http://localhost:8080 и убедиться, что подтянулось несколько шардов

## 4. Т.к. объем генерируемых данных мал, сразу сами задаём правило разделения по шардам с созданием чанков
```shell
docker compose -f compose.yaml exec mongos_router mongosh --port 27020 --eval "db=db.getSiblingDB('somedb'); db.helloDoc.createIndex({name:'hashed'}); sh.enableSharding('somedb'); sh.shardCollection('somedb.helloDoc',{name:'hashed'}, false, {numInitialChunks:8});"
```

## 5. Сгенерировать документы:
- Или через терминал в IDE из папки mongo-sharding
```shell
docker compose -f compose.yaml exec mongos_router mongosh --port 27020 --eval "db = db.getSiblingDB('somedb'); for (var i=0;i<1000;i++) db.helloDoc.insertOne({age:i,name:'ly'+i}); print(db.helloDoc.countDocuments())"
```

- Или через Git Bash из папки mongo-sharding/scripts
```shell
bash mongo-init.sh
```

## 6. Зайти на адрес http://localhost:8080 и убедиться, что в helloDoc -> documents_count изменилось значение (по дефолту на 1000)

Итог будет выглядеть примерно так

![](/mongo-sharding/screens/sharding-web.PNG)

## 7. Проверить, что документы распределились по разным шардам
```shell
docker compose -f compose.yaml exec mongos_router mongosh --port 27020 --eval "db=db.getSiblingDB('somedb'); db.helloDoc.getShardDistribution();"
```

Итог будет выглядеть примерно так

![](/mongo-sharding/screens/sharding-docs-percent.PNG)
