# GitLab managed Terraform State
# https://docs.gitlab.com/ee/user/infrastructure/#gitlab-managed-terraform-state
#
# Note: In GitLab versions 13.2 and greater, Maintainer access is required to lock, unlock and write to the state (using terraform apply),
#  while Developer access is required to read the state (using terraform plan -lock=false)

terraform {
  backend "http" {
  }
}
