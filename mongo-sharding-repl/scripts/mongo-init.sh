#!/bin/bash

# Seed sharded cluster via mongos_router (mongo-sharding/compose.yaml)

docker compose -f ../compose.yaml exec -T mongos_router mongosh --port 27020 <<'EOF'
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
EOF
