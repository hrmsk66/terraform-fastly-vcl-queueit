# Terraform module for provisioning Queue-it connectors on the Fastly platform (Varnish)

An example Terraform module that creates a Fastly service for the Queue-it connector, issues and deploys a certificate, and adds DNS records to point traffic to Fastly. Once the changes are completed successfully, the Fastly service will be ready to process requests over HTTPS.

In this example, we assume that the DNS records are added to Route 53.

## Usage

Start by creating a directory and a .tf file.

```
mkdir tf && touch tf/main.tf
```

Example of a .tf file:

```hcl
provider "aws" {
    region = "ap-northeast-1"
}

locals {
  service_name = "my-queueit-connector"

  domain = "my.example.com"

  dns_zone = "example.com"

  dictionary = {
    name = "queueit_config"
    items = {
      "CustomerId"          = "XXX"
      "EventId"             = "XXX"
      "Queue_Baseurl"       = "XXX"
      "Secret_Key"          = "XXX"
      "Session_cookie_name" = "QueueITAccepted-SDFrts345E"
    }
  }
}

module "service" {
    source = "github.com/hrmsk66/terraform-fastly-vcl-queueit?ref=latest"
    service_name = local.service_name
    domain = local.domain
    dns_zone = local.dns_zone
    dictionary = local.dictionary
}

output "service" {
    value = module.service.service
}
```

Then...

```
terraform init
terraform apply
```
