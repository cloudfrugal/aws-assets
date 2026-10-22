output "role_arn" {
  description = "The ARN of the IAM Role created for CloudFrugal onboarding"
  value       = aws_iam_role.cloudfrugal_s3_readonly.arn
}

