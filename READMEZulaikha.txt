Zulaikha (PART D & E)

1) rds.tf (Secure Database)
Purpose: Provisions an AWS RDS MySQL database with storage_encrypted = true to ensure student records are encrypted at rest.
Status:  Code Valid. (Passed terraform plan).
Deployment Result:  Restricted. The code is correct, Partial/Halted. The Terraform script crashed because of the S3 permission errors.
The database creation was halted (or rolled back) because the rest of the security architecture failed.(CUBA TRY )

2) s3.tf (Secure Storage)
Purpose: Creates an S3 bucket for file storage with Versioning (recovery) and Server-Side Encryption (AES-256) enabled. 
Also configures public access blocks.
Status:  Code Valid. (Passed terraform plan).
Deployment Result:  Blocked by Lab Policy. The deployment failed with AccessDenied because the student account is restricted 
from configuring Object Lock settings.

3) logging.tf (Audit Logging)
Purpose: Configures AWS CloudTrail to create an automated "security camera" that logs all API actions and user sign-ins for auditing.
Status:  Code Valid. (Passed terraform plan).
Deployment Result:  Blocked by Lab Policy. The deployment failed because the Learner Lab account lacks the IAM permissions 
required to create account-level trails.


Implementation Note for Report:
All Terraform configurations (.tf files) were successfully validated and planned (Green Status). However, the final terraform apply phase
encountered AccessDenied errors due to the strict Service Control Policies (SCPs) of the AWS Academy Learner Lab environment, which blocks
students from enabling Object Lock and CloudTrail. Screenshots of the successful Plan and the Permission Errors have been saved as evidence.
