
# CCS6344 Assignment 2 – Student Information System  
*Flask + MySQL + Terraform*

## Overview
This project is a **Student Information System** built using **Flask** and **MySQL**, with **Terraform** included to demonstrate Infrastructure as Code (IaC) concepts for CCS6344 Assignment 2.

The system displays student records from a MySQL database in real time and includes a basic Terraform setup for EC2 and security group planning.

---

## Prerequisites

### Local Application
- Python 3.x
- MySQL (remember your root password)
- Git

### Terraform
- Terraform installed and added to PATH  
  https://developer.hashicorp.com/terraform

---

## Repository Setup

1. Clone the repository:
```bash
git clone <repository-url>
````

---

# Part A: Flask + MySQL Setup

## Folder Preparation

1. Create a `static` folder under `app/`
2. Place `style.css` inside:

```text
app/static/style.css
```

3. Place `init.sql` into the `database/` folder

---

## Temporary Local Database Configuration

Edit `app.py` and **temporarily replace** the database configuration:

```python
db_config = {
    "host": "localhost",
    "user": "root",
    "password": "YOUR_ROOT_PASSWORD",
    "database": "studentdb"
}
```

---

## Update `index.html`

* Link external CSS
* Adjusted code to reflect **real-time database content**
* Added **students table** to display student information

```html
<link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
```

---

## MySQL Setup (Command Prompt)

1. Check MySQL installation:

```bash
mysql --version
```

2. Login:

```bash
mysql -u root -p
```

3. Create database and table:

```sql
CREATE DATABASE studentdb;
USE studentdb;

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    course VARCHAR(100)
);

INSERT INTO students (name, course) VALUES
('Ali', 'Cybersecurity'),
('Aisyah', 'Computer Science'),
('Daniel', 'Data Science');
```

4. Verify:

```sql
SELECT * FROM students;
```

**Expected:** three student records appear.

---

## Running Flask

Open a new Command Prompt:

```bash
cd C:\YOUR_PATH\CCS6344-Assignment2-GroupA\app
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

Open in browser:

```
http://127.0.0.1:5000
```

**Expected result:**

* Student table displayed
* CSS applied
* System status shows Online

---

# Part B: Terraform Setup

## Terraform Folder Structure

Terraform files are stored in a dedicated folder:

```text
terraform/
├── provider.tf
├── variables.tf
├── security.tf
├── ec2.tf
├── random.tf
├── etc...
```

---

## security.tf Changes (Tasneem)

* Updated **2 instances** to reference the correct VPC ID:

```hcl
vpc_id = aws_vpc.main.id
```

* Ensures Terraform `plan` runs without undeclared resource errors
* No other modifications were made; groupmates’ code remains compatible

---

## ec2.tf

* Defines an **EC2 instance** for demonstration
* References the updated security group
* **No actual resources are required to be deployed for assignment purposes**

---

## Running Terraform

Navigate to the Terraform directory:

```bash
cd terraform
```

### Initialize

```bash
terraform init
```

### Plan

```bash
terraform plan
```

**Expected output:**

* Terraform shows planned resources (`+ create`)
* Plan runs successfully without undeclared resource errors

**Notes:**

* `terraform plan` works **without AWS credentials**
* Errors about missing credentials when running `apply` are expected
* Group members can safely run `init` and `plan` without AWS account

---

## Contributors

* Issye, Zulaikha (Group A – CCS6344)
* Tasneem – index.html adjustments (students table + DB content + CSS), security.tf VPC ID fix, ec2.tf, documentation
