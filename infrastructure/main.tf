#configure the Azure provider
provider "azurerm" {
	features {}
	skip_provider_registration = true
}

#configure Terraform
terraform {
	required_version = ">= 1.8.0, < 2.0.0"
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "3.106.1"
	   }
	}
	backend "azurerm" {	    
	}
}