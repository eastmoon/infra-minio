## Declare alias
## Execute script
echo "----- Show Minio client all alias -----"
mc alias list

echo "----- Show MinIO deployment license -----"
mc license info minio

echo "----- Show MinIO deployment information -----"
mc admin info minio
