# docker-dynamodb [![CircleCI](https://circleci.com/gh/dwmkerr/docker-dynamodb.svg?style=svg)](https://circleci.com/gh/dwmkerr/docker-dynamodb)

Run DynamoDB locally with Docker:

```bash
docker run -p 8000:8000 dwmkerr/dynamodb
```

Any arguments you pass go straight to DynamoDB, which means you can use all of the commandline parameters in the [DynamoDB Documentation](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html).


# Instructions

Basic operation, default parameters. Runs in memory on port 8000:

```bash
docker run -p 8000:8000 dwmkerr/dynamodb
```

DynamoDB is now running on port 8000, check [localhost:8000/shell](http://localhost:8000) to see the shell.

If you want to have persistent data, just mount a volume from your host:

```bash
docker run -v /data:/data -p 8000:8000 dwmkerr/dynamodb -dbPath /data
```

# Coding

The code is structued like this:

```
Dockerfile     # the important thing, the actual dockerfile
makefile       # commands to build, test deploy etc
tests/         # bash scripts to test how the container works
```

## The Dockerfile

The Dockerfile is based on [OpenJDK](https://hub.docker.com/_/openjdk/) and essentially just runs a jar file in a JRSE 7 environment.

## The Makefile

The makefile contains commands to build, test and deploy. Parameters can be passed as environment variables or through the commandline.

| Command                  | Notes                             |
|--------------------------|-----------------------------------|
| `make build`             | Builds the image `dwmkerr/dynamodb:latest`. If a `BUILD_NUM` parameter is provided, also builds `dwmkerr/dynamodb:BUILD_NUM`. |
| `make test`              | Runs the test scripts. |
| `make deploy`            | Deploys the images to the docker hub. If you are not logged in, you're gonna have a bad time. |

## The Tests

The tests are simple bash scripts which check for basic capabilties *which relate to the image*. This means they're not there to make sure DynamoDB Local works, they're there to make sure the docker features work with the image. For eample, mounting a volume to provide a persistent data directory.

# Contributing

Please help out! Here are some areas I'd like to improve upon:

- [ ] Cleaner or colourised output for the tests. Is there any simple tool to do assets in a shell script?

If you contribute, include a `README.md` update in your PR and I'll list your contributions here.
