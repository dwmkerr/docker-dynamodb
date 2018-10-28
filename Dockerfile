# It's DynamoDB, in Docker!
# 
# Check:
#
# http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html 
# 
# for details on how to run DynamoDB locally. This Dockerfile essentially
# replicates those instructions.

FROM openjdk:8-jre-alpine

# Specify dynamodb version with a build argument. (i.e. docker build . --build-arg DYNAMODB_VERSION=latest)
ARG DYNAMODB_VERSION

# Some metadata.
MAINTAINER Dave Kerr <github.com/dwmkerr>

# Create our main application folder.
RUN mkdir -p opt/dynamodb
WORKDIR /opt/dynamodb

# Download and unpack dynamodb.
# Links are from: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html

RUN wget https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_${DYNAMODB_VERSION}.tar.gz \
    && wget https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_${DYNAMODB_VERSION}.tar.gz.sha256 \
    && sha256sum -c dynamodb_local_${DYNAMODB_VERSION}.tar.gz.sha256 \
    && tar zxvf dynamodb_local_${DYNAMODB_VERSION}.tar.gz \
    && rm dynamodb_local_${DYNAMODB_VERSION}.tar.gz dynamodb_local_${DYNAMODB_VERSION}.tar.gz.sha256 

 
# The entrypoint is the dynamodb jar. Default port is 8000.
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "DynamoDBLocal.jar"]
