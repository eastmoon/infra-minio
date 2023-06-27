# infra-minio
Tutorial and learning report with infrastructure open source software MinIO.

```
docker run -ti --rm ^
    -p 9000:9000 ^
    -p 9001:9001 ^
    -e MINIO_ROOT_USER=adminminio ^
    -e MINIO_ROOT_PASSWORD=minio!@#$ ^
    minio/minio server /data --console-address ":9001"
```

## 文獻

+ [MinIO](https://min.io/docs/minio/container/index.html)
    - [MinIO - Wiki](https://en.wikipedia.org/wiki/MinIO)
    - [MinIO - Docker](https://hub.docker.com/r/minio/minio/)
    - [MinIO Client - Docker](https://hub.docker.com/r/minio/mc)
+ Upload file Server
    - [Upload Files Using Pre-signed URLs](https://min.io/docs/minio/linux/integrations/presigned-put-upload-via-browser.html)
    - [Posting a File with Curl](https://reqbin.com/req/c-dot4w5a2/curl-post-file)
