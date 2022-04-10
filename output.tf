output "service" {
  value = {
    id     = fastly_service_vcl.service.id
    domain = one(fastly_service_vcl.service.domain).name
  }
}

output "cert" {
  value = {
    domain          = one(fastly_tls_subscription.subscription.domains)
    created_at      = fastly_tls_subscription.subscription.created_at
    updated_at      = fastly_tls_subscription.subscription.updated_at
    tls_config_name = data.fastly_tls_configuration.configuration.name
  }
}

output "dns" {
  value = {
    name   = aws_route53_record.record.name
    type   = aws_route53_record.record.type
    record = one(aws_route53_record.record.records)
    ttl    = aws_route53_record.record.ttl
  }
}
