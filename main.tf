# The following resource block is used to create an IAM OpenID Connect provider resource.

resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}

# The following resource block is used to create an IAM OpenID Connect provider resource.

resource "aws_iam_role" "tfc_role" {
  name = "tfc-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
       "Federated": "${aws_iam_openid_connect_provider.tfc_provider.arn}"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringEquals": {
         "${local.tfc_hostname}:aud": "${one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)}"
       },
       "StringLike": {
         "${local.tfc_hostname}:sub": "organization:${local.tfc_organization_name}:project:${local.tfc_project_name}:workspace:${local.tfc_workspace_name}:run_phase:*"
       }
     }
   }
 ]
}
EOF
}

# The following resource block is used to create an IAM policy.

resource "aws_iam_policy" "tfc_policy" {
  name        = "tfc-policy"
  description = "TFC run policy"

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "*"
     ],
     "Resource": "*"
   }
 ]
}
EOF
}

# The following resource block is used to attache a managed IAM policy to an IAM role.

resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = aws_iam_policy.tfc_policy.arn
}