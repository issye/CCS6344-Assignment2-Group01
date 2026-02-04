Deployment Limitations Due to AWS Academy Learner Lab Permissions (Evidence: Terraform Apply Output)

During deployment, terraform plan succeeded (46 resources planned), confirming the Terraform configuration and dependencies were valid. However, terraform apply encountered multiple AccessDenied (403) errors when attempting to create or configure certain AWS services. These restrictions are caused by the AWS Academy Learner Lab environment, where the assumed role voclabs/... is limited by identity-based policies and explicit denies.

1) IAM Role Creation Blocked

Terraform resource: aws_iam_role.ec2_role (iam.tf)
Action blocked: iam:CreateRole
Error summary: AccessDenied (403) — “no identity-based policy allows the iam:CreateRole action”
Impact: The EC2 instance profile / role required for least-privilege access could not be created in this lab environment.
Evidence: Terraform apply error shows the CreateRole failure for ec2-app-role.

2) RDS Database Instance Creation Blocked

Terraform resource: aws_db_instance.default (rds.tf)
Action blocked: rds:CreateDBInstance
Error summary: AccessDenied (403) — “no identity-based policy allows the rds:CreateDBInstance action”
Impact: The encrypted Multi-AZ MySQL RDS instance could not be provisioned through Terraform in this account.
Evidence: Terraform apply output shows CreateDBInstance is denied for the assumed voclabs role.

3) S3 Object Lock Configuration Read is Explicitly Denied (Log Bucket)

Terraform resource: aws_s3_bucket.log_bucket (logging.tf)
Action blocked: s3:GetBucketObjectLockConfiguration
Error summary: AccessDenied (403) — “explicit deny in an identity-based policy”
Impact: Terraform could not read/verify Object Lock settings on the security log bucket. This is a lab policy restriction and not a Terraform configuration issue.
Evidence: Terraform output shows GetObjectLockConfiguration denied on the generated security-logs-... bucket.

4) S3 Object Lock Configuration Read is Explicitly Denied (Secure Storage Bucket)

Terraform resource: aws_s3_bucket.secure_storage (s3.tf)
Action blocked: s3:GetBucketObjectLockConfiguration
Error summary: AccessDenied (403) — “explicit deny in an identity-based policy”
Impact: Terraform could not read/verify Object Lock configuration on the main secure storage bucket, even though encryption and public access blocking are configured in code.
Evidence: Terraform output shows GetObjectLockConfiguration denied on student-records-storage-....

5) ACM Certificate Import Blocked (SSL/TLS Setup)

Terraform resource: aws_acm_certificate.imported_selfsigned (tls_acm.tf)
Action blocked: acm:ImportCertificate
Error summary: AccessDeniedException (400) — “no identity-based policy allows the acm:ImportCertificate action”
Impact: Importing a self-signed certificate into ACM (for HTTPS termination at the ALB) is not permitted in this lab environment.
Evidence: Terraform apply output shows acm:ImportCertificate denied.

6) AWS WAFv2 Web ACL Creation Blocked

Terraform resource: aws_wafv2_web_acl.web_acl (waf.tf)
Action blocked: wafv2:CreateWebACL
Error summary: AccessDeniedException (400) — “no identity-based policy allows the wafv2:CreateWebACL action”
Impact: The Web Application Firewall (WAF) could not be created and attached to the ALB via Terraform due to account restrictions.
Evidence: Terraform apply output shows CreateWebACL denied.

Notes on Resources That Were Successfully Created

Despite the restrictions above, Terraform successfully created several core infrastructure components including (as shown in apply output):

VPC, subnets (public/private), Internet Gateway

NAT Gateway and route tables

ALB and HTTP listener

Security groups (ALB/App/DB)
These successful creations demonstrate that the overall network segmentation and infrastructure design are valid and deployable, and that the blocked items are specifically due to the AWS Academy lab permissions.

Conclusion

All blocked actions are due to AWS Academy Learner Lab permission constraints (identity-based policy limitations and explicit denies). The Terraform code remains valid and follows secure design principles, but certain security services (IAM role creation, RDS provisioning, ACM certificate import, WAF creation, and S3 Object Lock configuration checks) cannot be fully deployed within this restricted environment. Screenshots of terraform plan and the detailed terraform apply error output are provided as deployment evidence.