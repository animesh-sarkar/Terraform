### Introduction to Terraform
Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It allows users to define and provision cloud and on-premises infrastructure using a declarative configuration language called HashiCorp Configuration Language (HCL).
Why Terraform?
- Multi-cloud support: Works with AWS, Azure, Google Cloud, and many other providers.
- Declarative approach: You describe the desired state, and Terraform ensures it happens.
- State management: Keeps track of infrastructure changes to maintain consistency.
- Automation & scalability: Helps DevOps teams automate infrastructure provisioning.
How Terraform Works:
- Write: Define infrastructure in configuration files.
- Plan: Terraform generates an execution plan showing what will change.
- Apply: Terraform provisions or updates resources based on the plan.

***Below are the links of some standatd Azure-Terraform repositories***

**1.Terraform Providers**

Terraform providers are plugins that allow Terraform to interact with various cloud platforms, SaaS providers, and APIs. They enable Terraform to manage infrastructure resources across different environments. Each provider adds a set of resource types and data sources that Terraform can use.

In Terraform, the Azure provider block is used to configure the Microsoft Azure provider (azurerm) so that Terraform can manage Azure resources. 

Here's a basic example link:

[AzureProvider](https://github.com/animesh-sarkar/Terraform/blob/main/Provider.tf "AzureProvider")
