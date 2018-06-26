#!/usr/bin/env bash

# Bomb if anything fails.
set -e

# Kill any running dynamodb containers.
echo "Cleaning up old containers..."
docker ps -a | grep dwmkerr/dynamodb | awk '{print $1}' | xargs docker rm -f  || true

# Run the container.
DATADIR=/tmp/dynamodbdata
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

# Assert the count of records.
COUNT=$(aws dynamodb --endpoint-url http://localhost:8000 --region us-east-1 \
    scan \
    --table-name Supervillains \
    --select 'COUNT' \
    | jq .Count)

if [ $COUNT -ne "1" ]; then
    echo "Expeced to find a single record, found $COUNT..."
	exit 1
fi

# Clean up the container. On CircleCI the FS is BTRFS, so this might fail...
echo "Stopping and restarting..."
docker stop $ID && docker rm $ID || true
ID=$(docker run -d -p 8000:8000 -v $DATADIR:/data/ dwmkerr/dynamodb -dbPath /data/)
sleep 2

# Search for the record we created before, if the persistence has worked we
# should find it.
VILLAIN_NAME=$(aws dynamodb --endpoint-url http://localhost:8000 --region us-east-1 \
    scan \
    --table-name Supervillains \
    | jq '.Items[0].name.S')

if [[ "$VILLAIN_NAME" =~ Monarch ]]; then
    echo "Searched for a villain and found $VILLAIN_NAME!"
else
    echo "Searched for 'Monarch' but found $VILLAIN_NAME, failing test."
    exit 1
fi

# Clean up.
rm -rf $DATADIR

echo "Successfully tested persistent data via mounted volumes."
