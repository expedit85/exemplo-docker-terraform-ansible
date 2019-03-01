data "terraform_remote_state" "default" {
  backend = "local"

  config {
    path = "../cluster/terraform.tfstate"
  }
}



locals {
    public_address = "${data.terraform_remote_state.default.public_ip}"    

    private_key_file = "${data.terraform_remote_state.default.private_key_file}"

    ssh_port = "${data.terraform_remote_state.default.ssh_port}"
}

data "template_file" "hostname" {
    template = "${file("${path.module}/hostname.tpl")}"
    vars = {
        name  = "server"
        index = 1
        host  = "${local.public_address}"
        extra = ""
    }
}

data "template_file" "inventory" {
    template = "${file("${path.module}/inventory.tpl")}"
    vars {
        ssh_private_key_file = "${local.private_key_file}"
        ssh_port      = "${local.ssh_port}"
        sample_host   = "${data.template_file.hostname.rendered}"
        manager_hosts = "${format("%s\n", data.template_file.hostname.rendered)}"
        primary_host  = "${data.template_file.hostname.rendered}"
    }
}

output "inventory" {
	value = "${data.template_file.inventory.rendered}"
}

output "public_ip" {
    value = "${local.public_address}"
}
