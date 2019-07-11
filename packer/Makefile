all: validate build

validate:
	packer validate bastion-ami.json

build:
	packer build -var-file vars.json -only amazon-ebs  bastion-ami.json

docker:
	packer build -var-file vars.json -only docker bastion-ami.json
