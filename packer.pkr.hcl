packer {
    required_plugins {
        amazon = {
            source = "github.com/hashicorp/amazon"
            version = ">= 1.3.0"
        }
    }
}

# Lanuches temporary instance
source "amazon-ebs" "ubuntu" {
    region = "us-east-1"
    instance_type = "t2.micro"
    ssh_username = "ubuntu"

    source_ami_filter {
        filters = {
            name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
            virtualization-type = "hvm"
            root-device-type = "ebs"
        }

        owners = ["099720109477"] # Canonical
        most_recent = true
    }

    ami_name = "secure-goldne-image-${formatdate("YYYYMMDD-hhmm", timestamp())}"
}

build {
    sources = [
        "source.amazon-ebs.ubuntu"
    ]

    # Run Ansible playbook to configure system
    provisioner "ansible" {
        playbook_file = "./ansible/playbook.yml"
    }
}

