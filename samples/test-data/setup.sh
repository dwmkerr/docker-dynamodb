#!/usr/bin/env bash

# Bomb if anything fails.
set -e

# Run the container.
DATADIR="$(pwd)/data"
rm -rf $DATADIR; mkdir $DATADIR
echo "Created temporary data directory: $DATADIR"
ID=$(docker run -d -p 8000:8000 -v $DATADIR:/data/ dwmkerr/dynamodb -dbPath /data/)
sleep 2

# Create a table.
aws dynamodb --endpoint-url http://localhost:8000 --region us-east-1 \
	create-table \
	--table-name Supervillains \
    --attribute-definitions AttributeName=name,AttributeType=S \
	--key-schema AttributeName=name,KeyType=HASH \
	--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

# Add a record.
aws dynamodb --endpoint-url http://localhost:8000 --region us-east-1 \
    put-item \
    --table-name Supervillains \
    --item '{"name": {"S": "The Monarch"} }'

echo "Stopping..."
docker stop $ID && docker rm $ID || true
sleep 2

echo "Created data files at '$DATADIR'..."
