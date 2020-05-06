variable "realm" {
	description = "KeyCloak realm where terraform client has been created and where users/groups to be created/manipulated exist."
	type        = string
}

variable "terraform_auth_client_id" {
	description = "Client ID of client that terraform will authenticate against in order to do its work."
	type        = string
}

variable "terraform_auth_client_secret" {
	description = "Client secret used by Terraform KeyCloak provider authenticate against KeyCloak."
	type = string
}

variable "iam_auth_client_id" {
	description = "Client ID of client where IAM roles will be created."
	type        = string
}

variable "keycloak_base_url" {
	description = "Base URL of KeyCloak instance to interact with."
	type = string
}

variable "workload_accounts" {
	description = "List of accounts that product teams' workloads run within."
	type = list(object({
		name = string
		account_number = string
	}))
}

variable "shared_accounts" {
	description = "List of accounts that contain artifacts and services that apply across multiple accounts."
	type = list(object({}))
}

variable "master_account" {
	description = "The top level account in the organization."
	type = object({})
}

variable "readonly_role_name" {
	description = "Name of readonly  role."
	type = string
	default = "BCGOV_workload_readonly"
}

variable "admin_role_name" {
	description = "Name of admin role."
	type = string
	default =  "BCGOV_workload_admin"
}

variable "readonly_group_name" {
	description = "Name of the readonly KeyCloak group to create."
	type = string
	default = "aws_readonly_users"
}

variable "admin_group_name" {
	description = "Name of the admin KeyCloak group to create."
	type = string
	default = "aws_admin_users"
}

variable "idp_name" {
	description = "Name of configured IDP in AWS."
	type = string
	default = "BCGovKeyCloak"
}
