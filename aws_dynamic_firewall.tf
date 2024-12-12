provider "aws" {
  region = "us-east-1"
}

variable "sg_iports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [8200, 8201, 8300, 9200, 9500]

}

variable "sg_eports" {
  type        = list(number)
  description = "lis of egress ports"
  default     = [8080, 443, 80, 22, 21]
}

resource "aws_security_group" "dynamicsg" {
  name        = "dynamic-firewall"
  description = "Ingress & Egress"

  dynamic "ingress" {
    for_each = var.sg_iports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_eports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

    lifecycle {
    create_before_destroy = true
  }
}
