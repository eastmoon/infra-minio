# infra-minio
Tutorial and learning report with infrastructure open source software MinIO.

### Startup

+ 啟動

使用 CLI 呼叫 docker-compose 來啟動相關服務

```
minio up
```
> 預設啟用 OSS 版本，若要使用企業版則添加參數 ```--ent```

+ 關閉

使用 CLI 呼叫 docker-compose 來關閉相關服務

```
minio down
```

+ 進入

使用 CLI 進入目標容器內來操作相關服務的命令

```
minio into --tag=[service-name]
```

## 文獻

+ [MinIO](https://min.io/docs/minio/container/index.html)
    - [MinIO - Wiki](https://en.wikipedia.org/wiki/MinIO)
    - [MinIO - Docker](https://hub.docker.com/r/minio/minio/)
    - [MinIO Client - Docker](https://hub.docker.com/r/minio/mc)
+ Upload file Server
    - [Configure NGINX Proxy for MinIO Server](https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html)
    - [Upload Files Using Pre-signed URLs](https://min.io/docs/minio/linux/integrations/presigned-put-upload-via-browser.html)
    - [Posting a File with Curl](https://reqbin.com/req/c-dot4w5a2/curl-post-file)
+ 說明與教學
    - [資料庫 - 大型物件儲存系統 MinIO 簡介](https://ambersun1234.github.io/database/database-minio/)
    - [幫非結構化資料找個家，快速入門MinIO(一)：基本概念介紹](https://medium.com/jimmyfu87/b9f7c830fd26)
