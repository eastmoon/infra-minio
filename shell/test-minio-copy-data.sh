## Declare variable
## Execute script
echo "----- Create data -----"
LOCAL_DIR=/tmp/data
mc mb ${LOCAL_DIR}
echo 1234 > ${LOCAL_DIR}/demo1
echo 5678 > ${LOCAL_DIR}/demo2

echo "----- Create demo bucket -----"
BUCKET_NAME=demo-bucket
if [ $(mc ls minio | grep ${BUCKET_NAME} | wc -l) -eq 0 ]; then
    mc mb minio/${BUCKET_NAME}
else
    echo "bucket '${BUCKET_NAME}' exist."
fi

echo "----- Copy data to bucket -----"
mc cp -r ${LOCAL_DIR}/ minio/${BUCKET_NAME}/

echo "----- Remove local data -----"
rm -rf ${LOCAL_DIR}

echo "----- Copy bucket to data -----"
mc cp -r minio/${BUCKET_NAME}/ ${LOCAL_DIR}/

echo "----- Show data folder -----"
ls ${LOCAL_DIR} -al
