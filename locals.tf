locals {

  # This local is used to define the address of Terraform Cloud (e.g., https://app.terraform.io without a trailing slash).
  tfc_hostname = "app.terraform.io"

  # This local is used to define the organization name.
  tfc_organization_name = "ConseilsTI"



  # This local is used to define the project from which this role will be used.
  tfc_project_name = "*"

  # This local is used to define the workspace from which this role will be used.
  tfc_workspace_name = "*"

}