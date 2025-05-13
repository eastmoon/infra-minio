## Declare variable
MINIO_ALIAS=minio
USER_ACCESSKEY=testuser
USER_SECRETKEY=test1234!QAZ
## Execute script
echo "----- Create user -----"
mc admin user add ${MINIO_ALIAS} ${USER_ACCESSKEY} ${USER_SECRETKEY}

echo "----- Create demo bucket -----"
BUCKET_NAME=demo-user-bucket
if [ $(mc ls minio | grep ${BUCKET_NAME} | wc -l) -eq 0 ]; then
    mc mb ${MINIO_ALIAS}/${BUCKET_NAME}
else
    echo "bucket '${BUCKET_NAME}' exist."
fi

echo "----- Create policy file -----"
POLICY_FILE=/tmp/user-policy.json
cat > ${POLICY_FILE} << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${BUCKET_NAME}/*",
        "arn:aws:s3:::${BUCKET_NAME}"
      ]
    }
  ]
}
EOF
cat ${POLICY_FILE}

echo "----- Create policy -----"
POLICY_NAME=${BUCKET_NAME}-policy
if [ $(mc admin policy ls ${MINIO_ALIAS} | grep ${POLICY_NAME} | wc -l) -eq 0 ]; then
    mc admin policy create ${MINIO_ALIAS} ${POLICY_NAME} ${POLICY_FILE}
else
    echo "policy '${POLICY_NAME}' exist."
fi

echo "----- Attach policy to user -----"
if [ $(mc admin user info ${MINIO_ALIAS} ${USER_ACCESSKEY} | grep ${POLICY_NAME} | wc -l) -eq 0 ]; then
    mc admin policy attach ${MINIO_ALIAS} ${POLICY_NAME} --user ${USER_ACCESSKEY}
else
    echo "policy '${POLICY_NAME}' already attach to '${USER_ACCESSKEY}'."
fi

echo "----- Create demo alias -----"
DEMO_ALIAS=demo
mc alias set demo "${MINIO_HOST}" "${USER_ACCESSKEY}" "${USER_SECRETKEY}"

echo "----- Create test-bucket with demo alias, it will deny -----"
mc mb ${DEMO_ALIAS}/test-bucket

echo "----- Show all bucket in ${MINIO_ALIAS} alias-----"
mc ls ${MINIO_ALIAS}

echo "----- Show all bucket in ${DEMO_ALIAS} alias, only ${BUCKET_NAME} -----"
mc ls ${DEMO_ALIAS}
