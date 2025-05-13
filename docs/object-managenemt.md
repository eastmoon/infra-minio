## 物件管理

+ [Object Management](https://min.io/docs/minio/container/administration/object-management.html)

所謂物件，是指數據處理中的非結構化資料，由二進位數據組成的檔案，例如影像、音訊、表格文件，甚至是二進位可執行程式碼；物件儲存也會用術語「Binary Large Object」或「blob」，儘管 blob 指的檔案大小可以是從 Byte 到 TeraBytes  不等。

MinIO 等物件儲存平台提供專用工具和功能，使用兼容標準 S3 API 來儲存、列出和檢索物件；對於，物件儲存則使用桶 ( buckets ) 來組織物件 ( object )，桶如同於檔案系統中的磁區、資料夾或目錄 ( 例如 ```/mnt/data``` 或 ```C:\``` )，其中可以容納任意數量的物件。

```
/articles/
   /john.doe/
      2020-01-02-MinIO-Object-Storage.md
      2020-01-02-MinIO-Object-Storage-comments.json
```

舉例來說，管理者需建立 ```/articles/``` 儲存桶，客戶端若要尋找到物件，則需填寫完整路徑，其中包括儲存桶 ( bucket ) 與所有中間的前綴 ( prefixes )，例如 ```/articles/john.doe```。

### Path or Virtual Host Bucket Access

MinIO 支援 [path-style](https://docs.aws.amazon.com/AmazonS3/latest/userguide/VirtualHosting.html#path-style-access) (預設) 或 [virtual-host](https://docs.aws.amazon.com/AmazonS3/latest/userguide/VirtualHosting.html) 的儲存桶 ( bucket ) 查詢。

舉例來說，考慮一個 MinIO 部署，其網域名稱 (FQDN) 為 minio.example.net，儲存桶為 mybucket：

+ 透過路徑式 ( path-style ) 查詢，應用程式指定儲存桶的完整路徑為 minio.example.net/mybucket。
+ 透過虛擬主機 ( virtual-host ) 查詢，應用程式指定儲存桶的子網域為 mybucket.minio.example.net/。

若要啟用虛擬主機儲存桶查詢，必須將 ```MINIO_DOMAIN``` 環境變數設定為可解析至 MinIO 部署位置的域名；倘若使用虛擬主機查詢，則 ```MINIO_DOMAIN=minio.example.net``` 指向的域名 ```minio.example.net```，其子域名 ```*.minio.example.net``` 不可在指向其他服務；且若 MinIO 部屬啟用 [TLS 加密](https://min.io/docs/minio/container/operations/network-encryption.html#minio-tls)，該域名的憑證申請需要包括 ```*.minio.example.net``` 所有子域名。

### [Object Organization and Planning](https://min.io/docs/minio/container/administration/object-management.html#object-organization-and-planning)

本結詳細描述 MinIO 儲存桶的結構與數量建議：

+ 使用較慢磁碟或網路基礎架構的硬體，往往在扁平物件層次結構的儲存桶中表現出較差的效能。
+ 使用適度或注重預算的硬體進行部署時，應將其工作負載設計為每個前綴 10000 個物件作為基準；並根據此做基準測試和對實際工作負載監控，來調整硬體設備以提高效能。
+ 具有高效能或企業級硬體的部署通常可以處理具有數百萬個或更多物件的前綴。

有關深入討論限制前綴內容的優點，請參閱有關[優化 S3 性能](https://docs.aws.amazon.com/AmazonS3/latest/userguide/optimizing-performance.html)。

### [Object Versioning](https://min.io/docs/minio/container/administration/object-management.html#object-versioning)

當客戶端對儲存桶執行新增、刪除、修改、檢索，在版本控制啟動時的執行細節描述，詳細內容參考上述連結。

### [Object Tagging](https://min.io/docs/minio/container/administration/object-management.html#object-tagging)

MinIO 提供對物件指定標籤，並可由標前尋找物件，詳細內容參考上述連結。

### [Object Retention](https://min.io/docs/minio/container/administration/object-management.html#object-retention)

MinIO 提供物件鎖定 ( Object Locking ) 或稱物件保留 ( Object Retention ) ，其強制執行一次寫入但多次讀取 (WORM) 不變性特性，可以保護版本化物件，詳細內容參考上述連結。

### [Object Lifecycle Management](https://min.io/docs/minio/container/administration/object-management.html#object-lifecycle-management)

MinIO 物件生命週期管理允許建立基於時間或日期的物件自動轉換或到期規則：

+ 對於物件轉換，MinIO 會自動將物件移至配置的遠端儲存層。
+ 對於物件過期，MinIO 會自動刪除該物件。

詳細內容參考上述連結。

### Client operations

使用 MinIO Client 進行儲存桶與物件操作。

+ [```mc mb```](https://min.io/docs/minio/linux/reference/minio-mc/mc-mb.html)
```
## 在本地建立目錄 '/tmp/new-dir'，如同 mkdir
mc mb /tmp/new-dir

## 在 MinIO 部屬 ( alias minio ) 建立儲存桶 mybucket，
mc mb minio/mybucket
```

+ [```mc rb```](https://min.io/docs/minio/linux/reference/minio-mc/mc-rb.html)
```
## 在本地移除目錄 '/tmp/new-dir'，如同 rm -rf
mc rb /tmp/new-dir

## 在 MinIO 部屬 ( alias minio ) 移除儲存桶 mybucket，
mc rb minio/mybucket
```

+ [```mc ls```](https://min.io/docs/minio/linux/reference/minio-mc/mc-ls.html)
```
## 檢視本地目錄 '/tmp/data'，如同 ls /tmp/data
mc ls /tmp/data

## 在 MinIO 部屬 ( alias minio ) 檢視儲存桶 mybucket，
mc ls minio/mybucket
```

+ [```mc cp```](https://min.io/docs/minio/linux/reference/minio-mc/mc-cp.html)
```
## 複製本地目錄 '/tmp/data' 下的所有內容 ( 目錄與物件 ) 至 MinIO 部屬 ( alias minio ) 的儲存桶 mybucket/data 內
mc cp -r /tmp/data/* minio/mybucket/data

## 複製 MinIO 部屬 ( alias minio ) 的儲存桶 mybucket 下的所有內容 ( 目錄與物件 ) 至本地目錄 '/tmp/data'
mc cp -r minio/mybucket/ /tmp/data/
```
> 亦可利用 [```mc get```](https://min.io/docs/minio/linux/reference/minio-mc/mc-get.html) 從 minio 取資料到本地，或 [```mc put```](https://min.io/docs/minio/linux/reference/minio-mc/mc-put.html) 從本地送物件到 minio。

+ [```mc mirror```](https://min.io/docs/minio/linux/reference/minio-mc/mc-mirror.html)
```
## 同步本地目錄 '/tmp/data' 下的所有內容 ( 目錄與物件 ) 至 MinIO 部屬 ( alias minio ) 的儲存桶 mybucket/data 內
mc mirror /tmp/data minio/mybucket/data
```

+ [```mc mv```](https://min.io/docs/minio/linux/reference/minio-mc/mc-mv.html)
```
## 移動 MinIO 部屬 ( alias minio ) 儲存桶 mybucket 下的檔案 '1' 到儲存桶 mybucket/data/ 下且名稱改為 'n1'
mc mv minio/mybucket/1 minio/mybucket/data/n1
```

+ [```mc rm```](https://min.io/docs/minio/linux/reference/minio-mc/mc-rm.html)
```
## 在本地目錄 '/tmp/data' 移除檔案 '1'，如同 rm
mc rm /tmp/data/1

## 移除 MinIO 部屬 ( alias minio ) 儲存桶 mybucket/data 內的物件 '1'
mc rm minio/mybucket/data/1
```

+ [```mc diff```](https://min.io/docs/minio/linux/reference/minio-mc/mc-diff.html)
```
## 比較本地目錄 '/tmp/data' 與 MinIO 部屬 ( alias minio ) 的儲存桶 mybucket 內的物件差異
mc diff /tmp/data minio/mybucket
```

+ [```mc du```](https://min.io/docs/minio/linux/reference/minio-mc/mc-du.html)
```
## 檢索本地目錄 '/tmp/data' 內的檔案數與容量
mc du /tmp/data

## 檢索 MinIO 部屬 ( alias minio ) 儲存桶 mybucket 內的檔案數與容量
mc du minio/mybucket
```

+ [```mc find```](https://min.io/docs/minio/linux/reference/minio-mc/mc-find.html)
```
## 搜尋本地目錄 '/tmp/data' 內名為 '1' 的檔案
mc find /tmp/data --name 1

## 檢索 MinIO 部屬 ( alias minio ) 儲存桶 mybucket 名為 '1' 的物件
mc find minio/mybucket --name 1
```
