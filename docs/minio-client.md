## Minio 用戶端

+ [MinIO Client](https://min.io/docs/minio/linux/reference/minio-mc.html)

MinIO 用戶端 ```mc``` 命令列工具，提供了類同 UNIX 常見檔案操作命令（如 ls、cat、cp、mirror 和 diff）的 MinIO 遠端操作服務，並且與 Amazon S3 的雲端儲存服務命令列操作兼容。

其命令列 ```mc``` 格式如下：

```
mc [GLOBALFLAGS] COMMAND --help
```

## Minio 管理用戶端

+ [MinIO Admin Client](https://min.io/docs/minio/linux/reference/minio-mc-admin.html)

MinIO 用戶端 ```mc``` 命令列 ( Command Line ) 提供了 ```mc admin``` 命令用於執行 MinIO 的管理服務與操作。

需注意，雖然 ```mc``` 支援任何與 S3 相容的服務，但 ```mc admin``` 僅支援 MinIO 服務。

其命令列 ```mc admin``` 格式如下：

```
mc admin [FLAGS] COMMAND [ARGUMENTS]
```

## 登記操作服務端

MinIO 用戶端的命令，皆需指向一個服務端，其命令列格式如下：

```
# License information
mc license info [ALIAS]

# MinIO server information
mc admin info [TARGET]
```

在 ```mc``` 命令列的 ```[ALIAS]``` 或 ```mc admin``` 命令列的 ```[TARGET]``` 都是透過 [```mc alias```](https://min.io/docs/minio/linux/reference/minio-mc/mc-alias.html) 設定的別名；在預設情況下，使用 ```mc alias list``` 可看到提供了 4 個別名，若要註冊新的別名，其格式如下：

```
mc alias set minio [MINIO_HOST_URL] [MINIO_ACCESS_KEY] [MINIO_SECRET_KEY]
```

MinIO 對於透過用戶端操作，建議是設定用戶進行，相關設定參考[用戶與群組](./core-identity.md)。

然而，若要操作管理用戶端，仍會需要使用 root 帳戶進行用戶管理，並取得用戶的相應 ACCESS_KEY 與 SECRET_KEY；而參考 [MinIO root User](https://min.io/docs/minio/linux/administration/identity-access-management/minio-user-management.html#minio-root-user) 與 [Root Access Settings](https://min.io/docs/minio/linux/reference/minio-server/settings/root-credentials.html) 說明可得知，對 root 用戶，其 ACCESS_KEY 即為 MINIO_ROOT_USER、SECRET_KEY 即為 MINIO_ROOT_PASSWORD；亦可理解文件多次提到預設 root 用戶與密碼為 minioadmin，但在產品環境應使用具唯一性、字符長、隨機性的數值。

本專案範本，在 minio-mc 容器啟動時會依據提供的環境參數自動建立對 minio 服務的別名，其操作流程如下：

+ 進入容器 ```minio.bat into --tag=minio-mc```
+ 檢查別名 ```mc alias list```
    - 應存在預設完成的 minio
    - 若不存在可以檢查 ```docker logs -f docker-minio-mc_infra-minio``` 的記錄
+ 檢查服務狀態 ```mc admin info minio```
