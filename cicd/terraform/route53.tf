resource "aws_route53_record" "artifactory-ci" {
  zone_id = var.ZONE_ID
  name    = "artifactory-ci.devgovcio.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.artifactory-elb.dns_name]
}

resource "aws_route53_record" "gitlab-ci" {
  zone_id = var.ZONE_ID
  name    = "gitlab-ci.devgovcio.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.gitlab-elb.dns_name]
}

resource "aws_route53_record" "jenkins-ci" {
  zone_id = var.ZONE_ID
  name    = "jenkins-ci.devgovcio.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.jenkins-elb.dns_name]
}

resource "aws_route53_record" "sonar-ci" {
  zone_id = var.ZONE_ID
  name    = "sonar-ci.devgovcio.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.sonar-elb.dns_name]
}

resource "aws_route53_record" "dashboard-ci" {
  zone_id = var.ZONE_ID
  name    = "dashboard-ci.devgovcio.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.dashboard-elb.dns_name]
}

