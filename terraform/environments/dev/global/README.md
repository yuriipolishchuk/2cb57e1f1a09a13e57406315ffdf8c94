To resolve "chicken and egg" problem:
1. Uncomment this block after first `terraform apply`
2. do `terraform init` and answer `yes` when terraform will ask to copy the state
3. remove old state files with `rm terraform.tfstate*`
