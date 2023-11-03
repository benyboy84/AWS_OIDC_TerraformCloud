data "tls_certificate" "tfc_certificate" {
  url = "https://${local.tfc_hostname}"
}