## Declare variable
## Execute script
echo "----- Create bucket -----"
mc mb minio/test-bucket

echo "----- List all bucket -----"
mc ls minio

echo "----- Remove bucket -----"
mc rb minio/test-bucket
