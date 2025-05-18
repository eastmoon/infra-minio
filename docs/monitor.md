## Minio 監控與告警

+ [Monitoring and Alerts](https://min.io/docs/minio/container/operations/monitoring.html)

### Monitoring and Alerts

MinIO 使用 Prometheus 資料模型發佈時間點指標 ( point-in-time metrics )，用戶可以使用支援該資料模型的任何資料庫，提取訊息並建立圖表、資料分析進而規劃告警。

在文獻中 MinIO 提供 Prometheus 與 InfuxDB 的範本，本專案以 [Monitoring and Alerting using Prometheus](https://min.io/docs/minio/container/operations/monitoring/collect-minio-metrics-using-prometheus.html#minio-metrics-collect-using-prometheus) 為監控與告警的執行範本。

#### Generate the Scrape Configuration

使用 MinIO 命令 ```mc admin prometheus generate [ALIAS]``` 產生 Prometheus 的爬蟲 ( scrape ) 設定檔，但需注意以下幾點：

+ 設定 ```scrape_interval``` 確保抓取時間在一個操作區間內，建議值為 60 秒；若服務的爬蟲間隔太短會增加 MinIO 與 Prometheus 之間的負擔，倘若 MinIO 的變動緩慢，亦無需用極快的速度抓取資訊。
+ 設定 ```job_name``` 對用以便是對應的 MinIO 部屬。
+ 若 MinIO 環境變數 ```MINIO_PROMETHEUS_AUTH_TYPE``` 設定為 publish 則可忽略 ```bearer_token``` 的數值；因為 MinIO 已經設定若爬蟲抓取資料不做驗證。
+ 若 MinIO 部屬未使用 TLS 則 ```scheme``` 應設為 http 而非 https。

#### Restart Prometheus with the Updated Configuration

將前述的設定檔設定於 prometheus.yaml，並重啟 Prometheus 並確保其使用到此項設定。

#### Analyze Collected Metrics

使用 Prometheus 的 [expression browser](https://prometheus.io/docs/prometheus/latest/getting_started/#using-the-expression-browser) 來檢索收集的指標。

#### Configure an Alert Rule using MinIO Metrics

使用 Prometheus 的 [Alert Rule](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) 產生告警資訊。

#### Dashboard

MinIO 有提供 Grafana Dashboard 來呈現 Prometheus 收集的指標。

### [Healthchecks](https://min.io/docs/minio/container/operations/monitoring/healthcheck-probe.html#minio-healthcheck-api)

MinIO 公開未經身份驗證的端點，用於探測節點正常運行時間和叢集高可用性，以進行簡單的健康檢查。

例如使用 ```curl -I https://[MINIO-SERVER-ADDRESS]:9000/minio/health/live``` 檢查節點是否生存。

### [Bucket notifications](https://min.io/docs/minio/linux/administration/monitoring/bucket-notifications.html)

MinIO 儲存桶 ( Bucket ) 通知可讓管理員針對某些物件或儲存桶事件向支援的外部服務發送通知；其主要支援對象如下列：

+ [AMQP (RabbitMQ)](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-amqp.html)
+ [MQTT](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-mqtt.html)
+ [NATS](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-nats.html)
+ [NSQ](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-nsq.html)
+ [ElasticSearch](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-elasticsearch.html)
+ [Kafka](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-kafka.html)
+ [MySQL](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-mysql.html)
+ [PostgreSQL](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-postgresql.html)
+ [Redis](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-redis.html)
+ [Webhook](https://min.io/docs/minio/linux/administration/monitoring/publish-events-to-webhook.html)

使用上，可以解由 MinIO 事件將訊息通知給 Kafka，並由 Kafka 傳接訊息給 Flink 等串流資料處理服務，進而達到上傳資料同時觸發相應的批次檔案處理。
