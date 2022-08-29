sss
/*

    Jarvis-Demo v_0.1
    ---------------------------------------------------------------

    jarvis-vyos-ams0  <--- BGP ---> jarvis-vyos-rg0
         |                               |
    jarvis-nginx-ams0               jarvis-nginx-rg0


    DEPLOY
    ---------------------------------------------------------------
    export TF_VAR_qemu_host=***.***.***

    export TF_VAR_vyos_ams0_mgmt_ipaddress=**.**.**.234/29
    export TF_VAR_vyos_ams0_mgmt_gateway=**.**.**.233

    export TF_VAR_vyos_rg0_mgmt_ipaddress=**.**.**.235/29
    export TF_VAR_vyos_rg0_mgmt_gateway=**.**.**.233/29

    export TF_VAR_nginx_ams0_mgmt_ipaddress=172.17.22.15/24
    export TF_VAR_nginx_ams0_mgmt_gateway=172.17.22.1

    export TF_VAR_nginx_rg0_mgmt_ipaddress=172.16.18.99/24
    export TF_VAR_nginx_rg0_mgmt_gateway=172.16.18.1

*/

#
# VARS
#
variable "qemu_host" {}

variable "vyos_ams0_mgmt_ipaddress" {}
variable "vyos_ams0_mgmt_gateway" {}

variable "vyos_rg0_mgmt_ipaddress" {}
variable "vyos_rg0_mgmt_gateway" {}

variable "nginx_ams0_mgmt_ipaddress" {}
variable "nginx_ams0_mgmt_gateway" {}

variable "nginx_rg0_mgmt_ipaddress" {}
variable "nginx_rg0_mgmt_gateway" {}


#
# RESOURCE
#

#
# 2x VyOS (ams0, rg0)
#
module "jarvis-vyos-ams0" {
  source = "github.com/di-starss/openarch-vm-vyos"

  qemu_host = var.qemu_host

  vm_name = "jarvis-vyos-ams0"
  vm_cpu = 2
  vm_mem = 2048

  mgmt_ipaddress = var.vyos_ams0_mgmt_ipaddress
  mgmt_gateway = var.vyos_ams0_mgmt_gateway
  mgmt_interface = "eth0"

  network_interface = {
    "net0" = "br3472"
    "net1" = "br2255"
  }
}

module "jarvis-vyos-rg0" {
  source = "github.com/di-starss/openarch-vm-vyos"

  qemu_host = var.qemu_host

  vm_name = "jarvis-vyos-rg0"
  vm_cpu = 2
  vm_mem = 2048

  mgmt_ipaddress = var.vyos_rg0_mgmt_ipaddress
  mgmt_gateway = var.vyos_rg0_mgmt_gateway
  mgmt_interface = "eth0"

  network_interface = {
    "net0" = "br3472"
    "net1" = "br2260"
  }
}

#
# 2x Nginx (ams0, rg0)
#
module "jarvis-nginx-ams0" {
  source = "github.com/di-starss/openarch-vm-debian"

  qemu_host = var.qemu_host

  vm_name = "jarvis-nginx-ams0"
  vm_cpu = 2
  vm_mem = 2048

  mgmt_ipaddress = var.nginx_ams0_mgmt_ipaddress
  mgmt_gateway = var.nginx_ams0_mgmt_gateway
  mgmt_interface = "ens3"

  network_interface = {
    "net2" = "br2255"
  }
}

module "jarvis-nginx-rg0" {
  source = "github.com/di-starss/openarch-vm-debian"

  qemu_host = var.qemu_host

  vm_name = "jarvis-nginx-rg0"
  vm_cpu = 2
  vm_mem = 2048

  mgmt_ipaddress = var.nginx_rg0_mgmt_ipaddress
  mgmt_gateway = var.nginx_rg0_mgmt_gateway
  mgmt_interface = "ens3"

  network_interface = {
    "net2" = "br2260"
  }
}


#
# OUTPUT
#
output "jarvis-vyos-ams0__mgmt_ipaddress" {
  value = module.jarvis-vyos-ams0.mgmt_ipaddress
}

output "jarvis-vyos-rg0__mgmt_ipaddress" {
  value = module.jarvis-vyos-rg0.mgmt_ipaddress
}

output "jarvis-nginx-ams0__mgmt_ipaddress" {
  value = module.jarvis-nginx-ams0.mgmt_ipaddress
}

output "jarvis-nginx-rg0__mgmt_ipaddress" {
  value = module.jarvis-nginx-rg0.mgmt_ipaddress
}
