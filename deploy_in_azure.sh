#!/bin/bash

repo_name=$1
branch_name=$2
webapp_name=$3
is_first_deployment=$4

if [ -z "${repo_name}" ] ;then
   echo "Git Repository name is not passed! So exiting !"
   exit 1
fi

if [ -z "${branch_name}" ] ;then
   echo "Branch name is not passed! So exiting !"
   exit 1
fi

if [ -z "${webapp_name}" ] ;then
   echo "Applicatio name is not passed! So exiting !"
   exit 1
fi


git_directory=~/repositories/${repo_name}

echo "Checking whether Azure cli is installed"
is_azcli_installed=`az --version | grep -c "azure-cli"`
if [ $is_azcli_installed = 0 ] ;then
 echo "Azure cli is not installed ! Please install it at first!!"
 echo "After fixinng it use the below command to continue the execution"
 echo "bash ~/DeploymentScripts/deploy_in_azure.sh <repository_name> <branch_name> <application_name> <is_first_deployment>"
 echo "Example bash ~/DeploymentScripts/deploy_in_azure.sh loginradius master loginradius 1"
 exit 1
fi

if [ $is_first_deployment = 1 ] ;then
	echo "List of available regions is 'centralus,eastasia,southeastasia,eastus,eastus2,westus,westus2,northcentralus,southcentralus,westcentralus,northeurope,westeurope,japaneast,japanwest,brazilsouth,australiasoutheast,australiaeast,westindia,southindia,centralindia,canadacentral,canadaeast,uksouth,ukwest,koreacentral,koreasouth,francecentral,southafricanorth,uaenorth'"

	read -p "Enter one of the location mentioned above to create the resource group: " location
	read -p "Enter the username that to be used to set account level deployment credentials: " username
	read -p "Enter the password that to be used to set account level deployment credentials: " password

	resource_group=${webapp_name}'${location}'

	# Create a resource group.
	az group create --location ${location} --name ${resource_group}
	if [ $? -ne 0 ] ;then
	 echo "Problem in creating resource location . Fix the above mentioned error and retry! "
         echo "After fixinng it use the below command to continue the execution"
	 echo "bash ~/DeploymentScripts/deploy_in_azure.sh <repository_name> <branch_name> <application_name> <is_first_deployment>"
	 echo "Example bash ~/DeploymentScripts/deploy_in_azure.sh loginradius master loginradius 1"
	 #az group delete --name myResourceGroup
	 exit 1
	fi

	# Create an App Service plan in FREE tier.
	az appservice plan create --name ${webapp_name} --resource-group ${resource_group} --sku FREE
	if [ $? -ne 0 ] ;then
	 echo "Problem in creating Appservice plan . Fix the above mentioned error and retry! "
	 echo "Cleaning up the created resources"
	 az group delete --name ${resource_group}
         echo "After fixinng it use the below command to continue the execution"
	 echo "bash ~/DeploymentScripts/deploy_in_azure.sh <repository_name> <branch_name> <application_name> <is_first_deployment>"
	 echo "Example bash ~/DeploymentScripts/deploy_in_azure.sh loginradius master loginradius 1"
	 exit 1
	fi


	# Create a web app.
	az webapp create --name ${webapp_name} --resource-group ${resource_group} --plan ${webappname}
	if [ $? -ne 0 ] ;then
	 echo "Problem in creating WebApplication . Fix the above mentioned error and retry! "
	 echo "Cleaning up the created resources"
	 az group delete --name ${resource_group}
	 echo "After fixinng it use the below command to continue the execution"
	 echo "bash ~/DeploymentScripts/deploy_in_azure.sh <repository_name> <branch_name> <application_name> <is_first_deployment>"
	 echo "Example bash ~/DeploymentScripts/deploy_in_azure.sh loginradius master loginradius 1"
	 exit 1
	fi

	# Set the account-level deployment credentials
	az webapp deployment user set --user-name $username --password $password
	if [ $? -ne 0 ] ;then
	 echo "Problem in creating deployment user . Fix the above mentioned error and retry! "
	 echo "Cleaning up the created resources"
	 az group delete --name ${resource_group}
	 echo "After fixinng it use the below command to continue the execution"
	 echo "bash ~/DeploymentScripts/deploy_in_azure.sh <repository_name> <branch_name> <application_name> <is_first_deployment>"
	 echo "Example bash ~/DeploymentScripts/deploy_in_azure.sh loginradius master loginradius 1"
	 exit 1
	fi


	az webapp config appsettings set --resource-group ${resource_group} --name ${webapp_name} --settings WEBSITE_NODE_DEFAULT_VERSION=10.14.1

	# Configure local Git and get deployment URL
	url=$(az webapp deployment source config-local-git --name ${webapp_name} \
	--resource-group ${resource_group} --query url --output tsv)
	if [ $? -ne 0 ] ;then
	 echo "Problem in configuring deployment source . Fix the above mentioned error and retry! "
	 echo "Cleaning up the created resources"
	 az group delete --name ${resource_group}
	 echo "After fixinng it use the below command to continue the execution"
	 echo "bash ~/DeploymentScripts/deploy_in_azure.sh <repository_name> <branch_name> <application_name> <is_first_deployment>"
	 echo "Example bash ~/DeploymentScripts/deploy_in_azure.sh loginradius master loginradius 1"
	 exit 1
	fi

fi


# Add the Azure remote to your local Git respository and push your code
cd $git_directory

if [ $is_first_deployment = 1 ] ;then
	git remote add 'azure'${repo_name} $url
fi

echo "When prompted for username and password, provide the credentials that you have given during Setting the account-level deployment credentials"

git push 'azure'${repo_name} ${branch_name}:master

# Copy the result of the following command into a browser to see the web app.
echo " And Thats it!! Navigate to the following URL : http://${webapp_name}.azurewebsites.net "
