## MinIO 身分管理

+ [MinIO Identity Management](https://min.io/docs/minio/container/administration/identity-access-management/minio-identity-management.html)
    - [User Management](https://min.io/docs/minio/container/administration/identity-access-management/minio-user-management.html)
    - [Group Management](https://min.io/docs/minio/container/administration/identity-access-management/minio-group-management.html)

### User Management

MinIO 用戶由唯一的存取金鑰 ( Access key ) 或稱用戶名稱 ( Username ) 與對應的秘密金鑰 ( Secret Key ) 或稱密碼 ( Password ) 組成；當 MinIO 用戶端要取得操作權限，則需要提供有效的存取金鑰（用戶名稱）與對應秘密金鑰（密碼）來驗證。

MinIO 的每位用戶可以擁有至少一個的政策 ( Policy )，這些政策明確列出該用戶可執行的行為與可操作的資源，此外用戶的政策也可以從其所屬的群組繼承；在預設情況，MinIO 拒絕所有的行為執行與資源操作，系統必須明確指派一個政策給用戶，改用戶才具有可執行的行為與可操作的資源，詳細設定請參閱[存取管理](https://min.io/docs/minio/container/administration/identity-access-management.html#minio-access-management)。

MinIO 除內部 IDP ( IDentity Provider ) 驗證身分外，還有提供 [OpenID Connect (OIDC)](https://min.io/docs/minio/container/administration/identity-access-management/oidc-access-management.html#minio-external-identity-management-openid) 或 [Active Directory/LDAP IDentity Provider (IDP)](https://min.io/docs/minio/container/administration/identity-access-management/ad-ldap-access-management.html#minio-external-identity-management-ad-ldap)；但需注意，啟用第三方系統驗證，將使得內部 IDP 禁止使用。

#### Create a User

建立用戶可使用 [```mc admin user add```](https://min.io/docs/minio/linux/reference/minio-mc-admin/mc-admin-user-add.html) 命令：

```
mc admin user add [ALIAS] [ACCESSKEY] [SECRETKEY]
```

+ ```ALIAS``` 為設置於 alias 中的 MinIO 部屬。
+ ```ACCESSKEY``` 為用戶的存取金鑰 ( Access key ) 或稱用戶名稱 ( Username )
+ ```SECRETKEY``` 為用戶的秘密金鑰 ( Secret Key ) 或稱密碼 ( Password )

建議 ```ACCESSKEY``` 與 ```SECRETKEY``` 由唯一且長的亂數字串組成。

建立完成的用戶需添加政策，可使用 [```mc admin policy attach```](https://min.io/docs/minio/linux/reference/minio-mc-admin/mc-admin-policy-attach.html) 命令：

```
mc admin policy attach [ALIAS] readwrite --user=[USERNAME]
```

+ ```ALIAS``` 為設置於 alias 中的 MinIO 部屬。
+ ```USERNAME``` 為前述用戶設定的 ```ACCESSKEY```。

#### Delete a User

移除用戶可使用 [```mc admin user rm```](https://min.io/docs/minio/linux/reference/minio-mc-admin/mc-admin-user-rm.html) 命令：

```
mc admin user rm [ALIAS] [USERNAME]
```

+ ```ALIAS``` 為設置於 alias 中的 MinIO 部屬。
+ ```USERNAME``` 為前述用戶設定的 ```ACCESSKEY```。

#### Access Keys

MinIO 存取金鑰，舊稱為服務帳戶 ( Service Accounts ) 是經過身份驗證的 MinIO 用戶的子身份；每個存取金鑰具有原用戶與群組的相同政策權限，或增加內聯政策 ( inline policy ) 來更加限縮擁有的權限。

MinIO 用戶可以產生任意數量的存取金鑰，這些金鑰產生無需管理者授權即可自行產生，由於金鑰的權限僅能等同用戶或更限制，因此管理者優先管理的是用戶自身擁有的權限。

MinIo 用戶若要建立存取金鑰，可使用 [```mc admin user svcacct```](https://min.io/docs/minio/linux/reference/minio-mc-admin/mc-admin-user-svcacct.html#command-mc.admin.user.svcacct) 命令來管理。

### Group Management

MinIO 群組是 MinIO 用戶的集合，並且擁有至少一個的政策 ( Policy )，這些策略明確列出允許或拒絕群組成員存取的操作和資源。

群組管理可使用 [```mc admin group```](https://min.io/docs/minio/linux/reference/minio-mc-admin/mc-admin-group.html) 命令，需注意建立群組與添加用戶皆使用 [```mc admin group add```](https://min.io/docs/minio/linux/reference/minio-mc-admin/mc-admin-group-add.html) 命令。

### Access Management

MinIO 使用基於政策的存取控制 ( Policy-Based Access Control、PBAC ) 來定義經過驗證的用戶可以存取的授權操作和資源；每個策略描述至少一個操作和條件，概述用戶或群組的權限。

MinIO PBAC 使用的政策語法、結構、行為相容於 AWS IAM 系統，使其政策可共用於 MinIO 部屬與 AWS S3 服務。

政策設定使用 [```mc admin policy```](https://min.io/docs/minio/linux/reference/minio-mc-admin/mc-admin-policy.html) 命令，在增加政策時須提供一個政策檔案，其文件結構如下：

```
{
   "Version" : "2012-10-17",
   "Statement" : [
      {
         "Effect" : "Allow",
         "Action" : [ "s3:<ActionName>", ... ],
         "Resource" : "arn:aws:s3:::*",
         "Condition" : { ... }
      },
      {
         "Effect" : "Deny",
         "Action" : [ "s3:<ActionName>", ... ],
         "Resource" : "arn:aws:s3:::*",
         "Condition" : { ... }
      }
   ]
}
```

+ ```Statement.Action``` 指定該資源的 S3 行為政策，語法參考 [Supported S3 Policy Actions](https://min.io/docs/minio/container/administration/identity-access-management/policy-based-access-control.html#supported-s3-policy-actions)
+ ```Statement.Resource``` 描述目標儲存桶 ( Bucket )
    - 資源描述語法參考 [Policy resources for Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security_iam_service-with-iam.html#security_iam_service-with-iam-id-based-policies-resources)，其句型的前綴 ```arn:aws:s3:::``` 為固定描述具，其後才是目標儲存桶名稱與路徑
    - 使用符號 ```*``` 使白名單，指這之後所有內容皆受影響，舉例來說 ```arn:aws:s3:::data*``` 則儲存桶 ```data```、```data_private``` 皆會被納入
+ ```Statement.Condition``` 指額外條件，語法參考 [Supported S3 Policy Condition Keys](https://min.io/docs/minio/container/administration/identity-access-management/policy-based-access-control.html#minio-policy-conditions)
