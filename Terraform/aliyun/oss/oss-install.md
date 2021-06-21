# Terraform manager oss

```shell
# 参考: https://help.aliyun.com/document_detail/98848.html?spm=a2c4g.11186623.6.1763.223a7d14PccF0v
# 必须设置账号有OSS最高管理权限
# https://help.aliyun.com/document_detail/98855.htm?spm=a2c4g.11186623.2.6.6eb01e81Bhhqey#concept-nqx-wps-zfb
# mkdir aliyun-oss
# 参考 https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/oss_bucket
# terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/alicloud...
- Installing hashicorp/alicloud v1.124.3...
- Installed hashicorp/alicloud v1.124.3 (self-signed, key ID 34365D9472D7468F)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.


Warning: Additional provider information from registry

The remote registry returned warnings for
registry.terraform.io/hashicorp/alicloud:
- For users on Terraform 0.13 or greater, this provider has moved to
aliyun/alicloud. Please update your source in required_providers.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

```shell
# export TF_VAR_access_key=
# export TF_VAR_secret_key=
# export TF_VAR_aliyun_oss_bucket_name="terrofrom-ops-bucket"
# terraform validate
Success! The configuration is valid.
# terraform plan

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # alicloud_oss_bucket.terraform_oss_bucket will be created
  + resource "alicloud_oss_bucket" "terraform_oss_bucket" {
      + acl               = "private"
      + bucket            = "terrofrom-ops-bucket"
      + creation_date     = (known after apply)
      + extranet_endpoint = (known after apply)
      + force_destroy     = false
      + id                = (known after apply)
      + intranet_endpoint = (known after apply)
      + location          = (known after apply)
      + owner             = (known after apply)
      + redundancy_type   = "LRS"
      + storage_class     = "Standard"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
# terraform apply -auto-approve
alicloud_oss_bucket.terraform_oss_bucket: Creating...
alicloud_oss_bucket.terraform_oss_bucket: Creation complete after 4s [id=terrofrom-ops-bucket]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

# 删除
# terraform destroy -auto-approve
alicloud_oss_bucket.terraform_oss_bucket: Destroying... [id=terrofrom-ops-bucket]
alicloud_oss_bucket.terraform_oss_bucket: Destruction complete after 1s

Destroy complete! Resources: 1 destroyed.
```
