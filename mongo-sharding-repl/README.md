## 1. Запустить сервис
```shell
docker compose -f compose.yaml up -d
```

## 2. Проверить, что всё развернулось: у всех статус UP и healthy (последнее кроме pymongo_api)
```shell
docker compose -f compose.yaml ps
```

## 3. Сгенерировать документы:
- Или через терминал в IDE из папки mongo-sharding
```shell
docker compose -f compose.yaml exec mongos_router mongosh --port 27020 --eval "db = db.getSiblingDB('somedb'); for (var i=0;i<1000;i++) db.helloDoc.insertOne({age:i,name:'ly'+i}); print(db.helloDoc.countDocuments())"
```

- Или через Git Bash из папки mongo-sharding/scripts
```shell
bash mongo-init.sh
```

## 4. Зайти на адрес http://localhost:8080 и убедиться, что у шардов подтянулись реплики

Итог будет выглядеть примерно так

![](/mongo-sharding-repl/screens/repl.PNG)
