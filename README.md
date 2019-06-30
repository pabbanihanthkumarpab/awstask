
Instructions:
1) Deployment scripts uses cli commands of aws and azure to perform the deployments in Elastic beanstalk and Azure App Service.
   So , please make sure that ebcli and azcli are installed .
2) Steps to install those if not installed : 
   sudo apt-get update -y 
   sudo apt-get install python3.7 -y 
   sudo apt-get install python3-pip -y  
   pip3 install awsebcli --upgrade --user
   export PATH=~/.local/bin:$PATH
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
Note : Steps are sent only for ubuntu . Run those as sudo user
3) After the above steps are completed , make sure that below commands works
   eb --version -->  EB CLI 3.15.2 (Python 3.6.8)
   az --version -->  azure-cli 2.0.67
4) Login to Azure account using the below command and follow according to the prompt
   az login  --use-device-code
5) Please do not press ctrl+c as it stops the execution even the message  "-- Events -- (safe to Ctrl+C) " is shown on the      screen.
6) Please read the directions/prompts that are printed on the screen carefully.
7) For the 1st time deployment , it takes little time . Please be patient and follow the logs printed on the screen

8) Here starts the actual installation , run the below command and give the inputs according to the prompts .
   Sample inputs are also provided below .
   
   command:
   mkdir -p ~/DeploymentScripts && cd  ~/DeploymentScripts && \
   git clone https://github.com/pabbanihanthkumarpab/awstask.git &&  bash ~/DeploymentScripts/awstask/deploy_in_aws.sh
 
 Sample inputs:
 Enter the Application Name: loginradius
 Enter source git repository name: loginradiusrepo
 Enter git Url to clone the repository: https://github.com/pabbanihanthkumarpab/loginradiusrepo.git
 Enter git branch that to be deployed! : master
 Press 1 if it is 1st time deployment! else 0 !! --> 1
 Select a default region : <just press enter>
 Select an application to use : <Choose the number that suggests the "Create New Application!">
 Enter Application Name : <just press enter>
 It appears you are using Node.js. Is this correct? (y/n): y
 Do you want to set up SSH for your instances?(y/n): n
 Enter Environment Name:<just press enter>
 Enter DNS CNAME prefix: <just press enter>
 Select a load balancer type: 2
   
 Wait till the following is shown and navigate to the url shown
 
 =============================================================================================================
 And Thats it!! Navigate to the following URL :  loginradius-directory2-dev.ap-southeast-1.elasticbeanstalk.com
 ==============================================================================================================

 Enter one of the location mentioned above to create the resource group: centralus
 Enter the username that to be used to set account level deployment credentials : abcdefg
 Enter the password that to be used to set account level deployment credentials: 123456
 Password for 'https://pabbanihanthkumarpab@loginradius.scm.azurewebsites.net': 123456

 Wait till the following is shown and navigate to the url shown
 =============================================================================================================
 And Thats it!! Navigate to the following URL : http://loginradius.azurewebsites.net 
 =============================================================================================================

 
   


   
