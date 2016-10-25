# Bomb if anything fails.
set -e

# Kill any running dynamodb containers.
echo "Cleaning up old containers..."
docker ps -a | grep dwmkerr/dynamodb | awk '{print $1}' | xargs docker rm -f

# Run the container.
DATADIR=/tmp/dynamodbdata
rm -rf $DATADIR; mkdir $DATADIR
echo "Created temporary data directory: $DATADIR"
ID=$(docker run -d -p8000:8000 -v $DATADIR:/data/ dwmkerr/dynamodb -dbPath /data/)
sleep 2

# Create a table.
aws dynamodb --endpoint-url http://localhost:8000 \
	create-table \
	--table-name Supervillains \
    --attribute-definitions AttributeName=name,AttributeType=S \
	--key-schema AttributeName=name,KeyType=HASH \
	--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

# Add a record.
aws dynamodb --endpoint-url http://localhost:8000 \
    put-item \
    --table-name Supervillains \
    --item '{"name": {"S": "The Monarch"} }'

# Assert the count of records.
COUNT=$(aws dynamodb --endpoint-url http://localhost:8000 \
    scan \
    --table-name Supervillains \
    --select 'COUNT' \
    | jq .Count)

if [ $COUNT -ne "1" ]; then
    echo "Expeced to find a single record, found $COUNT..."
	exit 1
fi

echo "Stopping and restarting..."
docker stop $ID && docker rm $ID
ID=$(docker run -d -p8000:8000 -v $DATADIR:/data/ dwmkerr/dynamodb -dbPath /data/)
sleep 2

# List the tables - there shouldn't be any!
VILLAIN_NAME=$(aws dynamodb --endpoint-url http://localhost:8000 \
    scan \
    --table-name Supervillains \
    | jq '.Items[0].name.S')

if [ "$VILLAIN_NAME" != "The Monarch" ]; then
    echo "Failed to find the villain 'The Monarch', found $VILLAIN_NAME."
    exit 1
fi

# Clean up.
rm -rf $DATADIR

echo "Successfully tested persistent data via mounted volumes."
