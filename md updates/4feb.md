# Security Updates & Infrastructure Enhancements
CCS6344 – Assignment 2  
Group: [Your Group Name]  
Updated By: [Your Name(s)]  
Date: [Update date]

---

## 1. Purpose of This Document

This document explains **all security-related updates, architectural changes, and Terraform improvements** made after the initial implementation.

The goal of these updates is to ensure **full alignment with the assignment rubric**, particularly for:

- Secure VPC design
- Least-privilege IAM
- Encrypted storage (S3 & RDS)
- HTTPS (SSL/TLS) enforcement
- Web Application Firewall (WAF)
- Demonstrable security validation (Part E)

Where AWS Academy Learner Lab restrictions prevent deployment, evidence is provided through:
- Successful `terraform validate` and `terraform plan`
- `terraform apply` error output indicating Service Control Policy (SCP) restrictions

---

## 2. Application-Level Security Improvements

### 2.1 Removal of Hardcoded Credentials (Flask Application)

**Before**
- Database credentials were hardcoded inside `app.py`, which poses a security risk.

**After**
- Database connection parameters are now loaded from environment variables:
  - `DB_HOST`
  - `DB_USER`
  - `DB_PASSWORD`
  - `DB_NAME`

**Security Benefit**
- Prevents credential leakage
- Aligns with secure configuration and secrets management practices

---

## 3. Network Architecture Enhancements (Terraform)

### 3.1 Highly Available VPC Design

The VPC was redesigned to support **high availability and network segmentation**:

| Tier | Subnets | Availability Zones |
|----|----|----|
| Public (ALB) | 2 | us-east-1a, us-east-1b |
| Private Application (EC2) | 2 | us-east-1a, us-east-1b |
| Private Database (RDS) | 2 | us-east-1a, us-east-1b |

**Security Benefit**
- Prevents single points of failure
- Ensures database isolation from public access

---

### 3.2 Internet Gateway, NAT Gateway & Routing

**Added Components**
- Internet Gateway (IGW) for public subnets
- NAT Gateway for private application subnets
- Separate route tables for public and private tiers

**Security Benefit**
- EC2 instances remain private
- Outbound internet access allowed only when required (updates, dependencies)

---

## 4. Security Group Hardening

Security Groups were rewritten to strictly follow **least exposure principles**:

### 4.1 Application Load Balancer (ALB)
- Allows inbound: `80 (HTTP)` and `443 (HTTPS)` from the internet
- Forwards traffic internally only

### 4.2 Application EC2 Instances
- Allows inbound **only from ALB** on port `5000`
- No public IPs assigned

### 4.3 RDS Database
- Allows inbound **only from application EC2 security group** on port `3306`
- Completely inaccessible from public networks

**Security Benefit**
- Eliminates lateral and public access risks
- Demonstrates strict network access control

---

## 5. HTTPS (SSL/TLS) Implementation

### 5.1 TLS Certificate Setup
- A self-signed certificate was generated using Terraform (`tls` provider)
- Certificate imported into AWS ACM

### 5.2 ALB HTTPS Configuration
- HTTP (port 80) automatically redirects to HTTPS (port 443)
- TLS termination handled at the Application Load Balancer

**Security Benefit**
- Ensures encryption in transit
- Satisfies HTTPS/SSL requirement in the rubric

> Note: Browser warnings may appear due to self-signed certificates; this is acceptable for academic demonstration purposes.

---

## 6. Web Application Firewall (WAF)

### 6.1 WAF Rules
- AWS Managed Rules enabled:
  - SQL Injection protection
  - Common Web Exploit protections

### 6.2 WAF Enforcement
- Web ACL is explicitly **associated with the ALB**
- Requests are inspected before reaching the application

**Security Benefit**
- Demonstrates active attack prevention
- Meets WAF enforcement requirement

---

## 7. IAM Least-Privilege Redesign

### 7.1 Previous Issue
- Broad AWS-managed policies were initially attached (over-privileged)

### 7.2 Current Implementation
A custom IAM policy was created that allows:
- Read-only access to the specific S3 bucket used by the application
- CloudWatch Logs permissions for basic monitoring

No administrative or wildcard permissions are granted.

**Security Benefit**
- Strict least-privilege compliance
- Reduces blast radius if EC2 is compromised

---

## 8. Encrypted Storage

### 8.1 Amazon RDS
- Storage encryption enabled
- Multi-AZ deployment enabled
- Database deployed in private subnets only

### 8.2 Amazon S3
- Server-side encryption enabled (AES-256)
- Public access blocked

**Security Benefit**
- Data encrypted at rest
- Protects sensitive records from unauthorized access

---

## 9. Security Validation (Part E)

At least **three security validations** were performed:

### 9.1 Port Scanning
- Nmap scan conducted against the ALB endpoint
- Results show only ports `80` and `443` are open

### 9.2 WAF Blocking Test
- Simulated SQL injection payloads sent
- Requests were blocked by AWS WAF rules

### 9.3 Encryption Verification
- AWS Console screenshots confirm:
  - S3 encryption enabled
  - RDS `storage_encrypted = true`

---

## 10. AWS Academy Learner Lab Limitations

Some AWS services are restricted due to **Service Control Policies (SCPs)** in the AWS Academy Learner Lab environment.

Examples:
- CloudTrail advanced configuration
- Certain IAM or Object Lock features

**Mitigation**
- All Terraform code passes `terraform validate` and `terraform plan`
- Screenshots of `terraform apply` failures are included as evidence
- Errors clearly indicate permission restrictions rather than configuration issues

This approach follows academic best practices and demonstrates correct infrastructure-as-code design despite environment limitations.

---

## 11. Conclusion

These updates ensure the project:
- Fully aligns with the assignment rubric
- Demonstrates real-world cloud security practices
- Clearly distinguishes design correctness from lab environment constraints

The system now reflects a **secure, scalable, and production-aligned architecture** suitable for evaluation.

---
