locals {
  application               = lookup (var.tags_stage_mapping,var.stage).application
  Owner                     = lookup (var.tags_stage_mapping,var.stage).Owner
  BusinessUnit              = lookup (var.tags_stage_mapping,var.stage).BusinessUnit
  sign_up_enabled           =  var.stage == "AzureDev"
	sign_in_enabled           =  var.stage == "AzureDev"
	delegation_enabled        =  var.stage == "AzureDev"
}
