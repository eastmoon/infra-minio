## Minio 部屬

+ [Install and Deploy MinIO](https://min.io/docs/minio/container/operations/installation.html)
    - [Deploy MinIO: Single-Node Single-Drive](https://min.io/docs/minio/container/operations/install-deploy-manage/deploy-minio-single-node-single-drive.html)
    - [Deploy MinIO: Single-Node Multi-Drive](https://min.io/docs/minio/container/operations/install-deploy-manage/deploy-minio-single-node-multi-drive.html)
    - [Deploy a MinIO Tenant](https://min.io/docs/minio/kubernetes/upstream/operations/install-deploy-manage/deploy-minio-tenant.html#minio-mnmd)

### Topologies

MinIO 是一套軟體定義的高效分散式物件存儲伺服器，其拓譜 ( topologies ) 結構如下：

+ Single-Node Single-Drive (SNSD or “Standalone”)
    - 單一 MinIO 伺服器搭配單一儲存磁區
+ Single-Node Multi-Drive (SNMD or “Standalone Multi-Drive”)
    - 單一 MinIO 伺服器搭配至少 4 個儲存磁區
+ Multi-Node Multi-Drive (MNMD or “Distributed”)
    - 複數 MinIO 伺服器搭配每個伺服器至少 4 個儲存磁區

不同的拓譜結構對於資料的可靠性 ( reliability ) 與故障轉移 ( failover ) 有不同的等級，越多節點與儲存磁區越高的資料保護性；從 SNSD 與 SNMD 文件中提到對驅動器 ( Drive ) 的一致類型 ( Consistent Type )、一致容量 ( Consistent Size )，可以理解 Multi-Drive 類似軟體層級的 RAID 資料保護，此外掛入的驅動器本身應是單一的硬碟。

### Site Replication

節點複製 ( Site Replication ) 可將多個 MinIO 伺服器連結，並確保其 Buckets、Objects、IAM 設定保持同步於全部連結中的節點 ( Site )。

在節點複製 ( Site Replication ) 中，每個 MinIO 伺服器即為節點 ( Site )，而節點複製會啟用 [Bucket Versioning](https://min.io/docs/minio/container/administration/object-management/object-versioning.html#minio-bucket-versioning)，將 Bucket 內的資料以版本的概念保存，從而讓變更內容有版本管理的功能，並可透過用戶端 API ```mc admin replicate``` 操作。

### 小結

MinIO 的拓譜結構中，單點 ( Single-Node ) 可以配合驅動器結構來提高保護性，而多點 ( Multi-Node ) 則倚靠 Kubernetes cluster 概念切換執行入口確保執行端的高可用性。
