terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

# Trust Relationship Policy Document (Enforcing STS External ID)
data "aws_iam_policy_document" "cloudfrugal_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.cloudfrugal_account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id]
    }
  }
}

# CloudFrugal S3 Read-Only IAM Role
resource "aws_iam_role" "cloudfrugal_s3_readonly" {
  name                 = var.role_name
  description          = "Allows CloudFrugal to inspect S3 storage configurations, lifecycle policies, and tiering metrics"
  assume_role_policy   = data.aws_iam_policy_document.cloudfrugal_assume_role.json
}

# Managed Read-Only Policy Attachment
resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.cloudfrugal_s3_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Least-Privilege S3 Inspection Inline Policy
data "aws_iam_policy_document" "s3_audit_permissions" {
  statement {
    sid    = "S3MetadataAndMetricsRead"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetLifecycleConfiguration",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "s3:GetBucketPolicyStatus",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketIntelligentTieringConfiguration",
      "s3:GetAnalyticsConfiguration",
      "s3:GetMetricsConfiguration",
      "s3:GetInventoryConfiguration"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cloudfrugal_s3_audit" {
  name   = "CloudFrugalLeastPrivilegeS3Audit"
  role   = aws_iam_role.cloudfrugal_s3_readonly.id
  policy = data.aws_iam_policy_document.s3_audit_permissions.json
}

