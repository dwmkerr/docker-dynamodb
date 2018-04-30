# docker-dynamodb [![CircleCI](https://circleci.com/gh/dwmkerr/docker-dynamodb.svg?style=shield)](https://circleci.com/gh/dwmkerr/docker-dynamodb) [![ImageLayers Badge](https://badge.imagelayers.io/dwmkerr/dynamodb:latest.svg)](https://imagelayers.io/?images=dwmkerr/dynamodb:latest 'Get your own badge on imagelayers.io')

[![Docker Hub Badge](http://dockeri.co/image/dwmkerr/dynamodb)](https://registry.hub.docker.com/u/dwmkerr/dynamodb/)

Run DynamoDB locally with Docker:

```bash
docker run -p 8000:8000 dwmkerr/dynamodb
open http://localhost:8000/shell
```

<img src="assets/banner.jpg" width="600" alt="DynamoDB Local Shell Screenshot">

This container has full support for all of the commandline parameters in the [DynamoDB Documentation](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html).


# Instructions

To run an ephemeral instance of DynamoDB:

```bash
docker run -p 8000:8000 dwmkerr/dynamodb
```

If you want to have persistent data, just mount a volume from your host and set it as a data directory for DynamoDB:

```bash
docker run -v /data:/data -p 8000:8000 dwmkerr/dynamodb -dbPath /data
```

If you want to access tables and data created by the AWS CLI through a language SDK (Node, Java, etc), you will want to use the `-sharedDb` option [as described in this AWS forum post](https://forums.aws.amazon.com/thread.jspa?messageID=717048):

```bash
docker run -p 8000:8000 dwmkerr/dynamodb -sharedDb
```

Without this option, each connection will get is own database and the data will not be accessible between different clients.

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

The tests are simple bash scripts which check for basic capabilties *which relate to the image*. This means they're not there to make sure DynamoDB Local works, they're there to make sure the docker features work with the image. For example, mounting a volume to provide a persistent data directory.

# Continuous Integration

CI is provided currently by Circle. Ensure you provide AWS credentials as we are using the AWS CLI (they are not used, but the CLI still checks that they are present).

# Samples

## Generating an Image with Test Data

A basic sample showing how to build an image with custom test data is at [`./samples/test-data`](./samples/test-data).

1. Go to the sample: `cd ./samples/test-data`
2. Create some sample data: `make create-test-data`. This creates sample data files at `./data`.
3. Build a new docker image called `sample-test-data`, with `make build`.
4. The newly created image has the test data built in. Verify with `make test`.

# Contributing

Please help out! Here are some areas I'd like to improve upon:

- [ ] Cleaner or colourised output for the tests. Is there any simple tool to do assets in a shell script?

If you contribute, include a `README.md` update in your PR and I'll list your contributions here.
