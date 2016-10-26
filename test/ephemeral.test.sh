# Bomb if anything fails.
set -e

# Kill any running dynamodb containers.
echo "Cleaning up old containers..."
docker ps -a | grep dwmkerr/dynamodb | awk '{print $1}' | xargs docker rm -f  || true

# Run the container.
echo "Checking we can run the container..."
ID=$(docker run -d -p 8000:8000 dwmkerr/dynamodb)
sleep 2

# Create a table.
AWS_DEFAULT_REGION=us-west-1
aws dynamodb --endpoint-url http://localhost:8000 \
	create-table \
	--table-name Supervillains \
    --attribute-definitions AttributeName=name,AttributeType=S \
	--key-schema AttributeName=name,KeyType=HASH \
	--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

# Clean up the container. On CircleCI the FS is BTRFS, so this might fail...
echo "Stopping and restarting..."
docker stop $ID && docker rm $ID || true
ID=$(docker run -d -p8000:8000 dwmkerr/dynamodb)
sleep 2

# List the tables - there shouldn't be any!
aws dynamodb --endpoint-url http://localhost:8000 \
    list-tables \
	| jq '.TableNames | length'
