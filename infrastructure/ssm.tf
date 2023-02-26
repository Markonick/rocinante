resource "aws_ssm_parameter" "api-sentry-dsn" {
  name        = "/${local.project}/SENTRY_DSN"
  description = "Sentry DSN credentials"
  type        = "SecureString"
  value       = local.sentry_dsn
  overwrite   = true
}