resource "fastly_service_vcl" "service" {
  name = var.domain

  domain {
    name = var.domain
  }

  backend {
    name              = "httpbin"
    address           = "httpbin.org"
    port              = 443
    use_ssl           = true
    ssl_cert_hostname = "httpbin.org"
    ssl_sni_hostname  = "httpbin.org"
  }

  vcl {
    name    = "main"
    content = file("${path.module}/vcl/main.vcl")
    main    = true
  }

  vcl {
    name    = "queueit_conn"
    content = templatefile("${path.module}/vcl/queueit_conn.vcl", { config_table = var.config.name, routing_table = var.routing.name })
  }

  dictionary {
    name = var.dictionary.name
  }

  dictionary {
    name = var.routing.name
  }

  force_destroy = true
}

resource "fastly_service_dictionary_items" "config" {
  for_each = {
    for d in fastly_service_vcl.service.dictionary : d.name => d if d.name == var.config.name
  }

  service_id    = fastly_service_vcl.service.id
  dictionary_id = each.value.dictionary_id
  items         = var.config.items

  manage_items = true
}

resource "fastly_service_dictionary_items" "routing" {
  for_each = {
    for d in fastly_service_vcl.service.dictionary : d.name => d if d.name == var.routing.name
  }

  service_id    = fastly_service_vcl.service.id
  dictionary_id = each.value.dictionary_id
  items         = var.routing.items

  manage_items = true
}
