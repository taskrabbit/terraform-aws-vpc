# Peering Connection

## Set Terraform version constraint
terraform {
  required_version = ">= 0.12"
}

## Provisions VPC peering
resource "aws_vpc_peering_connection" "peer" {
  count = length(var.vpc_peering_connection_id) > 0 ? "0" : "1"

  auto_accept   = var.accepter_region != "" ? "false" : var.auto_accept
  peer_owner_id = var.accepter_owner_id
  peer_region   = var.accepter_region
  peer_vpc_id   = var.accepter_vpc_id
  vpc_id        = var.requester_vpc_id

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_dns
  }

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_dns
  }

  tags = {
    application = var.stack_item_fullname
    managed_by  = "terraform"
    Name        = "${var.stack_item_label}-peer"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer_accept" {
  count = length(var.vpc_peering_connection_id) > 0 ? "1" : "0"

  auto_accept               = var.accepter_auto_accept
  vpc_peering_connection_id = var.vpc_peering_connection_id

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_dns
  }

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_dns
  }

  tags = {
    application = var.stack_item_fullname
    managed_by  = "terraform"
    Name        = "${var.stack_item_label}-peer"
  }
}

