# Step 1, create the data.
create-test-data:
	./setup.sh

# Step 2, create a custom image which contains the data.
build:
	docker build -t sample-test-data:latest .

# Step 3, run the custom image.
start:
	docker run -p 8000:8000 sample-test-data -dbPath /data/

# Step 4, demonstrate we have data in the custom image.
test:
	aws dynamodb --endpoint-url http://localhost:8000 --region us-east-1 scan --table-name Supervillains  | jq '.Items[0].name.S'
