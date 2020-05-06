provider "keycloak" {
	client_id     = var.terraform_auth_client_id
	client_secret = var.terraform_auth_client_secret
	realm		  = var.realm
	url           = var.keycloak_base_url
}

locals {
	iam_arn_prefix = "arn:aws:iam"
	saml_provider = "saml-provider"
	role = "role"
}

resource "keycloak_group" "groups" {
	for_each = {
	for group in list(var.admin_group_name, var.readonly_group_name): group => group
	}

	realm_id = var.realm
	name     = each.value
}

resource "keycloak_role" "readonly_roles" {
	for_each = {
	for account in var.workload_accounts : "${account.name}" => account
	}
	realm_id    = var.realm
	client_id   = var.iam_auth_client_id
	name        = "${local.iam_arn_prefix}::${each.value.account_number}:${local.saml_provider}/${var.idp_name},${local.iam_arn_prefix}::${each.value.account_number}:${local.role}/${var.readonly_role_name}"
}

resource "keycloak_group_roles" "viewer_group_roles" {
	realm_id = var.realm
	group_id = keycloak_group.groups[var.readonly_group_name].id

	role_ids = [
	for role in keycloak_role.readonly_roles:
	role.id
	]
}

resource "keycloak_role" "admin_roles" {
	for_each = {
	for account in var.workload_accounts : "${account.name}" => account
	}
	realm_id    = var.realm
	client_id   = var.iam_auth_client_id
	name        = "${local.iam_arn_prefix}::${each.value.account_number}:${local.saml_provider}/${var.idp_name},${local.iam_arn_prefix}::${each.value.account_number}:${local.role}/${var.admin_role_name}"
}

resource "keycloak_group_roles" "admin_group_roles" {
	realm_id = var.realm
	group_id = keycloak_group.groups[var.admin_group_name].id

	role_ids = [
	for role in keycloak_role.admin_roles:
	role.id
	]
}
