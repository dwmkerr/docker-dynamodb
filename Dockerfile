# It's DynamoDB, in Docker!
# 
# Check:
#
# http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html 
# 
# for details on how to run DynamoDB locally. This Dockerfile essentially
# replicates those instructions.

# Use JDK 7. I tried alpine, but all calls to dynamo then fail silently...
# FROM openjdk:7-jre-alpine
FROM openjdk:7

# Some metadata.
MAINTAINER Dave Kerr <github.com/dwmkerr>

# Create our main application folder.
RUN mkdir -p opt/dynamodb
WORKDIR /opt/dynamodb

# Download and unpack dynamodb.
# Links are from: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html
RUN wget https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz -q -O - | tar -xz
  
# The entrypoint is the dynamodb jar. Default port is 8000.
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "DynamoDBLocal.jar"]
