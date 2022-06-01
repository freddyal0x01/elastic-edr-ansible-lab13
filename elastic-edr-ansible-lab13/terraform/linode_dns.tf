data "linode_domain" "domain" {
  domain = "freddyal.com"
}
resource "linode_domain_record" "elk_elastic" {
  domain_id = "${data.linode_domain.domain.id}"
  record_type   = "A"
  name   = "elastic"
  target  = linode_instance.elk.ip_address
}
resource "linode_domain_record" "elk_kibana" {
  domain_id = "${data.linode_domain.domain.id}"
  record_type   = "A"
  name   = "kibana"
  target  = linode_instance.elk.ip_address
}
resource "linode_domain_record" "elk_fleet" {
  domain_id = "${data.linode_domain.domain.id}"
  record_type   = "A"
  name   = "fleet"
  target  = linode_instance.elk.ip_address
}
