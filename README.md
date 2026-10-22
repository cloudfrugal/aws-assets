# CloudFrugal Public AWS Assets (`aws-assets`)

Public repository hosting AWS CloudFormation templates and IAM policies for CloudFrugal onboarding.

## Structure

- `templates/cloudfrugal-s3-onboarding.yaml`: Generalized CloudFormation template for 1-Click stack creation. **Zero hardcoded values**; parameters are injected dynamically at stack creation time.
- `policies/s3-readonly-policy.json`: Standalone S3 read-only permission policy for Terraform and manual IAM configuration.
- `policies/trust-relationship-policy.json`: STS AssumeRole trust relationship policy enforcing External ID matching.

## Public Access URL

For CloudFormation Quick-Create:
```text
https://raw.githubusercontent.com/cloudfrugal/aws-assets/main/templates/cloudfrugal-s3-onboarding.yaml
```
