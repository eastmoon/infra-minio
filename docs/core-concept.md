## Minio 核心概念

### [Core Operational Concepts](https://min.io/docs/minio/container/operations/concepts.html)

#### What are the components of a MinIO Deployment?

MinIO 部署 ( MinIO deployment ) 由一組儲存和運算資源組成，運行在至少一個 minio 伺服器節點，使其成為一個物件儲存庫。

MinIO 獨立實例 ( MinIO standalone instance ) 由一個伺服器集區內包括一個 minio 伺服器節點組成，此結構適合初始開發和評估。

MinIO 部署可直接在非虛擬化基礎架構中的實體設備上運作，亦或運行在雲端服務上的虛擬機，例如使用 Docker、Podman 或 Kubernetes。

#### What system topologies does MinIO support?

1、單一節點單一裝置 Single-Node Single-Drive (SNSD or “Standalone”)

此結構只有一個 MinIO 伺服器與一個儲存資料裝置或資料夾；例如，測試在主機的本地硬碟中的資料夾。

2、單一節點複數裝置 Single-Node Multi-Drive (SNMD or “Standalone Multi-Drive”)

此結構只有一個 MinIO 伺服器與數個掛載的儲存資料裝置或資料目錄；例如，單一容器搭配只少 2 個掛載目錄。

3、複數節點複數裝置 Multi-Node Multi-Drive (MNMD or “Distributed”)

此結構由數個 MinIO 伺服器各自掛載數個儲存資料裝置或資料目錄。

#### How does MinIO manage multiple virtual or physical servers?

伺服器池 ( Server Pool ) 是 minio 伺服器節點集合，它們匯集其伺服器下屬的磁碟和資源以支援物件儲存寫入和檢索請求，此結構有以下特點：

+ MinIO 支援對現有的 MinIO 部署新增一個或多個伺服器池，以實現水平擴展。
+ MinIO 由多個可用的伺服器池組成時，單一物件總會寫入同一個伺服器池中的相同糾刪集 ( erasure set )。
+ 一個伺服池集發生故障，MinIO 將暫停所有池的 I/O 操作，直到叢集恢復正常運作，才能恢復部署的 I/O 操作。
+ 當異常發生且執行修復操作期間，寫入其他伺服器池的物件會安全地保留在其磁碟內。

一個伺服器池可經由參數化的 HOSTNAME 資訊傳遞給 minio 伺服器命令執行：

```
minio server https://minio{1...4}.example.net/mnt/disk{1...4}
```

以上啟動命令範例，會建立單一伺服器池，其中有 4 個 minio 伺服器節點，每個節點有 4 個磁碟裝置，總共 16 個磁碟裝置。

詳細參數與設定可參考 [minio server](https://min.io/docs/minio/linux/reference/minio-server/minio-server.html#command-minio.server)。

#### How does MinIO link multiple server pools into a single MinIO cluster?

MinIO 叢集是由一個進入點 MinIO 部屬與至少一個伺服器池組成。

```
minio server https://minio{1...4}.example.net/mnt/disk{1...4} \
             https://minio{5...8}.example.net/mnt/disk{1...4}
```

以上啟動命令範例，會建立一個叢集，包括 2 個伺服器池，每個池包括 4 個 minio 伺服器節點，每個節點有 4 個磁碟裝置，總共 32 個磁碟裝置。

#### [Can I change the size of an existing MinIO deployment?](https://min.io/docs/minio/container/operations/concepts.html#can-i-change-the-size-of-an-existing-minio-deployment)

本結詳細描述 MinIO 叢集部屬如何修改其伺服器池來增加總容量，詳細參考上述連結內文。

#### How do I manage one or more MinIO instances or clusters?

管理 MinIO 部屬與叢集可經由以下方式：

+ 使用命令列 ```mc``` 與 ```mc admin``` 下達指令
+ 使用 MinIO 圖形化控制台的使用者介面

### [Deployment Architecture](https://min.io/docs/minio/container/operations/concepts/architecture.html)

本結詳細描述 MinIO 服務其部屬在 MNMD 模式時，硬體、軟體、第三方儲存服務間的運作關係，詳細參考上述連結內文。

### [Availability and Resiliency](https://min.io/docs/minio/container/operations/concepts/availability-and-resiliency.html)

本結詳細描述 MinIO 服務如何實踐高可用性與擴展性，其包括運作邏輯與執行效能評估，詳細參考上述連結內文。

### [Erasure Coding](https://min.io/docs/minio/container/operations/concepts/erasure-coding.html)

本結詳細描述 MinIO 如何使用[糾刪碼 ( Erasure Coding )](https://en.wikipedia.org/wiki/Erasure_code) 來保護儲存系統的數據，詳細參考上述連結內文。

### [Object Healing](https://min.io/docs/minio/container/operations/concepts/healing.html)

本結詳細描述 MinIO 如何基於糾刪碼 ( Erasure Coding ) 來修復 ( Healing ) 因壞損遺失的資料，詳細參考上述連結內文。

### [Object Scanner](https://min.io/docs/minio/container/operations/concepts/scanner.html)

本結詳細描述 MinIO 如何透過掃描 ( Scanner ) 來檢查數據物件是否需要修復，詳細參考上述連結內文。

### [Thresholds and Limits](https://min.io/docs/minio/container/operations/concepts/thresholds.html)

本結描述 MinIO 的物件儲存閥值與極限，詳細參考上述連結內文。
