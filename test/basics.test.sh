# Bomb if anything fails.
set -e

# Kill any running dynamodb containers.
echo "Cleaning up old containers..."
docker ps -a | grep dwmkerr/dynamodb | awk '{print $1}' | xargs docker rm -f  || true

# Check that if we run the image, we can hit the shell.
echo "Checking we can run the container..."
ID=$(docker run -d -p 8000:8000 dwmkerr/dynamodb)
sleep 2
http :8000/shell
echo "Successfully pinged the dynamodb shell!"

# Clean up the container. On CircleCI the FS is BTRFS, so this might fail...
docker stop $ID && docker rm $ID || true

