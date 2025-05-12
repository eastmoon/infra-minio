## Setting alias

if  [[ -n ${MINIO_HOST} && -n ${MINIO_ROOT_USER} && -n ${MINIO_ROOT_PASSWORD} ]]; then
    if [ $(command -v mc | wc -l) -gt 0 ]; then
        mc alias set minio "${MINIO_HOST}" "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"
    fi
fi
## Startup container
tail -f /dev/null
