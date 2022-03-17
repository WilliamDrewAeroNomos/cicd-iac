output "Artifactory_URL" {
  value = aws_route53_record.artifactory-ci.name
}

output "GitLab_URL" {
  value = aws_route53_record.gitlab-ci.name
}

output "Jenkins_URL" {
  value = aws_route53_record.jenkins-ci.name
}

output "Sonar_URL" {
  value = aws_route53_record.sonar-ci.name
}

output "Dashboard_URL" {
  value = aws_route53_record.dashboard-ci.name
}

output "Artifactory_RDS_end_point" {
  value = aws_db_instance.artifactorydb-ci.endpoint
}

output "GitLab_RDS_end_point" {
  value = aws_db_instance.gitlabdb-ci.endpoint
}

output "Sonar_RDS_end_point" {
  value = aws_db_instance.sonardb-ci.endpoint
}

