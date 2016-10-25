build:
	docker build -t dmwkerr/dynamodb:latest .
ifndef BUILD_NUM
	$(warning No build number is defined, skipping build number tag.)
else
	docker build -t dwmkerr/dynamodb:$(BUILD_NUM) .	
endif

test:
	./test/basics.test.sh
	./test/ephemeral.test.sh
	./test/persistent.test.sh

deploy: test
	docker push dwmkerr/dynamodb:latest
ifndef BUILD_NUM
	$(warning No build number is defined, skipping push of build number tag.)
else
	docker push dwmkerr/dynamodb:$(BUILD_NUM) .	
endif

.PHONY: build test deploy
