1. **Download Terraform in cloudshell**

cd ~

curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/1.6.6/terraform\_1.6.6\_linux\_amd64.zip

unzip terraform.zip

mkdir -p ~/.local/bin

mv terraform ~/.local/bin/

echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc

source ~/.bashrc

terraform -version



2\. **Applying terraform**

terraform init

terraform validate

terraform plan

terraform apply



