# Create the docker images locally. If a BUILD_NUM is provided, we will also
# create an image with the tag BUILD_NUM.
build:
	docker build -t dwmkerr/dynamodb:latest .
ifndef BUILD_NUM
	$(warning No build number is defined, skipping build number tag.)
else
	docker build -t dwmkerr/dynamodb:$(BUILD_NUM) .	
endif

# Run the tests. These do things like kill containers, so run with caution.
test: build
	./test/basics.test.sh
	./test/ephemeral.test.sh
	./test/persistent.test.sh

# Deploy the images to the Docker Hub. Assumes you are logged in!
deploy: 
	docker push dwmkerr/dynamodb:latest
ifndef BUILD_NUM
	$(warning No build number is defined, skipping push of build number tag.)
else
	docker push dwmkerr/dynamodb:$(BUILD_NUM)
endif

# Make sure the makefile knows the commands below are commands, not targets.
.PHONY: build test deploy
