resource "tls_private_key" "alb_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "alb_cert" {
  private_key_pem = tls_private_key.alb_key.private_key_pem

  subject {
    common_name  = "student-app.local"
    organization = "CCS6344"
  }

  validity_period_hours = 720  # 30 days
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "imported_selfsigned" {
  private_key      = tls_private_key.alb_key.private_key_pem
  certificate_body = tls_self_signed_cert.alb_cert.cert_pem
}
