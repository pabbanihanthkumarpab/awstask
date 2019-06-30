#!/bin/bash

echo "Checking whether Elastic beanstalk cli is installed"
is_ebcli_installed=`eb --version | grep -c "EB CLI"`
if [ $is_ebcli_installed = 0 ] ;then
 echo "Elastic beanstalk cli is not installed ! Please install it at first!!"
 exit 1
fi
echo "ebcli is installed . Good to go!! "

read -p "Enter the Application Name: "  appName
mkdir -p ~/$appName"-directory"
mkdir -p ~/repositories

read -p "Enter git repository name! " repoName

cd ~/repositories/

is_repo_already_exists=`ls | grep -c -w '^${repoName}$'`

echo $is_repo_already_exists

if [ $is_repo_already_exists = 0 ] ;then
	read -p "Enter git Url! " gitUrl
	git clone $gitUrl
	if [ $? -ne 0 ] ;then
	  echo "Problem in cloning the git! Check the credentials or Url "
	  exit 1
	fi
else
	cd ~/repositories/$repoName
	git pull
        if [ $? -ne 0 ] ;then
          echo "Problem in pulling the latest code! Check the credentials !! "
          exit 1
        fi
fi	

cd ~/repositories/$repoName
read -p "Enter git branch that to be deployed! " gitBranch
git checkout $gitBranch
if [ $? -ne 0 ] ;then
 echo "Problem in checking out the git branch ! Check if the branch exists in git "
 exit 1
fi

cp -r ~/repositories/$repoName/* ~/$appName"-directory/"
cd ~/$appName"-directory"

read -p "Press 1 if it is 1st time deployment! else 0 !! " is_first_deployment
if [ $is_first_deployment = 1 ] ;then
 eb init
 eb create
fi 

eb deploy

url=`eb status | grep CNAME: | cut -d ':' -f2 | awk '{$1=$1};1'`

echo "=========================================================================================================="
echo " And Thats it!! Navigate to the following URL : " $url
echo "=========================================================================================================="

echo "Azure deployment starts in 15 seconds ..! "
sleep 20

bash deploy_in_azure.sh $repoName $gitBranch $appName $is_first_deployment
