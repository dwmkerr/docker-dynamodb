# dynamodb

Run DynamoDB locally with Docker, more details at [github.com/dwmkerr/docker-dynamodb](https://github.com/dwmkerr/dynamodb):

```bash
docker run -p 8000:8000 dwmkerr/dynamodb
open http://localhost:8000/shell
```

Try it out by hitting the local shell:

![DynamoDB Local Shell Screenshot](https://raw.githubusercontent.com/dwmkerr/docker-dynamodb/master/assets/banner.jpg)

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

# Coding

For development instructions, check the GitHub page at [github.com/dwmkerr/docker-dynamodb](https://github.com/dwmkerr/docker-dynamodb).
