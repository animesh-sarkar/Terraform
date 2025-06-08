### Introduction to Terraform
Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It allows users to define and provision cloud and on-premises infrastructure using a declarative configuration language called HashiCorp Configuration Language (HCL).
Why Terraform?
- Multi-cloud support: Works with AWS, Azure, Google Cloud, and many other providers.
- Declarative approach: You describe the desired state, and Terraform ensures it happens.
- State management: Keeps track of infrastructure changes to maintain consistency.
- Automation & scalability: Helps DevOps teams automate infrastructure provisioning.
  
### How Terraform Works:

- Write: Define infrastructure in configuration files.
- Plan: Terraform generates an execution plan showing what will change.
- Apply: Terraform provisions or updates resources based on the plan.

***Below are the links of some standatd Azure-Terraform repositories***



1.[AzureProvider](https://github.com/animesh-sarkar/Terraform/blob/main/Provider.tf "AzureProvider")

2.[Azure RG](https://github.com/animesh-sarkar/Terraform/blob/main/ResourceGroup.tf "Azure RG")

3.[Vnet-Creation](https://github.com/animesh-sarkar/Terraform/blob/main/Vnet.tf "Vnet-Creation")

4.[Vnet-with-Subnets](https://github.com/animesh-sarkar/Terraform/blob/main/Vnet_with_Subnet.tf "Vnet-with-Subnets")

5.[Vnet Peering - Same Region](https://github.com/animesh-sarkar/Terraform/blob/main/Vnet_peering_same-Region.tf "Vnet Peering - Same Region")

6.[Vnet-Peering Cross-region Type-1](https://github.com/animesh-sarkar/Terraform/blob/main/Vnet-Peering_CrossRegion-1.tf "Vnet-Peering Cross-region Type-1")

7.[Vnet-Peering Cross-region Type-2](https://github.com/animesh-sarkar/Terraform/blob/main/Vnet-Peering_CrossRegion-2.tf "Vnet-Peering Cross-region Type-2")

8.[Single ubuntu VM creation ](https://github.com/animesh-sarkar/Terraform/blob/main/ubuntuVM.tf "Single ubuntu VM creation ")

  This script will create a single ubuntu Virtual machine with user_id and password as authentication method

9. [Apache-Ubuntu](https://github.com/animesh-sarkar/Terraform/blob/main/Apache-Ubuntu.tf "Apache-Ubuntu")
    
**The script automatically:-**

1.Creates all necessary networking components

2.Launches an Ubuntu VM

3.Installs and starts Apache

4.Opens the necessary firewall ports

5.Provides the endpoint URL and VM public IP in the output

you can access the Apache default page at the URL and IP provided in the output

If the Apache IP is not showing in the output, it is likely because the public IP address isn't being populated immediately when the VM is created
