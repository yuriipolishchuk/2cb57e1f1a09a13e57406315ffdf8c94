# SSH Bastion: build AMI with packer, test it with GOSS and deploy with terraform

### Install prerequisites
```
brew install packer

wget https://github.com/YaleUniversity/packer-provisioner-goss/releases/download/v0.3.0/packer-provisioner-goss-v0.3.0-darwin-amd64 -O ~/.packer.d/plugins/packer-provisioner-goss

chmod +x ~/.packer.d/plugins/packer-provisioner-goss

brew install warrensbox/tap/tfswitch
tfswitch 0.12.3
```

### 1. Create variables file and edit it with appropriate configuration
```
mv vars.json.example vars.json
```

### 2. Build an AMI
```
cd ./packer
make
```

### 3. Deploy bastion host

```
cd ./terraform/environments/dev/global
terraform init; terraform plan -out plan ; terraform apply plan
```

Follow instructions in global/README.md to move terraform state for global into a s3 bucket

Deploy bastion
```
cd ./terraform/environments/dev/us-east-1/vpc
terraform init; terraform plan -out plan ; terraform apply plan

cd ./terraform/environments/dev/us-east-1/ssh_bastion
terraform init; terraform plan -out plan ; terraform apply plan
```

# TODO:
* remove ansible from ami
* terragrunt
* atlantis
