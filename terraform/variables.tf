variable "cloudfrugal_account_id" {
  type        = string
  description = "The CloudFrugal AWS Account ID authorized to assume this role"
}

variable "external_id" {
  type        = string
  description = "Unique External ID provided by CloudFrugal to prevent the Confused Deputy problem"
}

variable "role_name" {
  type        = string
  default     = "CloudFrugalS3ReadOnlyRole"
  description = "Name of the IAM Role created for CloudFrugal"
}

