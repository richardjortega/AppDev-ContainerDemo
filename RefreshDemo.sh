#!/bin/bash
echo "This script will re-clone the Github repository and re-apply environment template values to he source directories."
echo ""
echo ""

source /source/appdev-demo-EnvironmentTemplateValues
echo ""
echo "Current Template Values:"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX
echo "      DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
echo "      DEMO_REGISTRY_SERVER-NAME="$DEMO_REGISTRY_SERVER_NAME
echo "      DEMO_REGISTRY_USER_NAME="$DEMO_REGISTRY_USER_NAME
echo "      DEMO_REGISTRY_PASSWORD="$DEMO_REGISTRY_PASSWORD
echo "      DEMO_OMS_WORKSPACE="$DEMO_OMS_WORKSPACE
echo "      DEMO_OMS_PRIMARYKEY="$DEMO_OMS_PRIMARYKEY
echo "      DEMO_APPLICATION_INSIGHTS_KEY="$DEMO_APPLICATION_INSIGHTS_KEY
echo ""
echo "The remainder of this script deletes the existing /source/AppDev-ContainerDemo directory, reclones and resets script executables."
read -p "Press any key to continue or CTRL-C to exit... " startscript
echo ""

echo "    Remove existing demo environment ./AppDev-ContainerDemo" 
sudo rm -rf /source/AppDev-ContainerDemo
echo "    Reclone github repository https://github.com/dansand71/AppDev-ContainerDemo"

cd /source
#Necessary for demos to build and restore .NET application
sudo chmod -R 777 /source

sudo git clone https://github.com/dansand71/AppDev-ContainerDemo 
sudo chmod +x /source/AppDev-ContainerDemo/1-create-settings-file.sh
sudo chmod +x /source/AppDev-ContainerDemo/2-setup-demo.sh
cp /source/AppDev-ContainerDemo/RefreshDemo.sh /source/refresh-appdev-container-demo.sh
sudo chmod +x /source/refresh-appdev-container-demo.sh


#Leverage the existing public key for new VM creation script
echo "--------------------------------------------"
echo "Reading ~/.ssh/id_rsa.pub and writing values to /source/AppDev-ContainerDemo/*"
sshpubkey=$(< ~/.ssh/id_rsa.pub)
echo "Using public key:" ${sshpubkey}
sudo grep -rl REPLACE-SSH-KEY /source/AppDev-ContainerDemo --exclude 1-SetupDemo.sh | sudo xargs sed -i -e "s#REPLACE-SSH-KEY#$sshpubkey#g" 
echo "--------------------------------------------"

echo "Configuring demo scripts"
sudo echo "export ANSIBLE_HOST_KEY_CHECKING=false" >> ~/.bashrc
export ANSIBLE_HOST_KEY_CHECKING=false
cd /source
sudo grep -rl VALUEOF-UNIQUE-SERVER-PREFIX /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-SERVER-PREFIX@$DEMO_UNIQUE_SERVER_PREFIX@g"
sudo grep -rl VALUEOF-UNIQUE-STORAGE-ACCOUNT /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-UNIQUE-STORAGE-ACCOUNT@$DEMO_STORAGE_ACCOUNT@g" 
sudo grep -rl VALUEOF-REGISTRY-SERVER-NAME /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-SERVER-NAME@$DEMO_REGISTRY_SERVER_NAME@g" 
sudo grep -rl VALUEOF-REGISTRY-USER-NAME /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-USER-NAME@$DEMO_REGISTRY_USER_NAME@g" 
sudo grep -rl VALUEOF-REGISTRY-PASSWORD /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REGISTRY-PASSWORD@$DEMO_REGISTRY_PASSWORD@g" 
sudo grep -rl VALUEOF-REPLACE-OMS-WORKSPACE /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-WORKSPACE@$DEMO_OMS_WORKSPACE@g" 
sudo grep -rl VALUEOF-REPLACE-OMS-PRIMARYKEY /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-REPLACE-OMS-PRIMARYKEY@$DEMO_OMS_PRIMARYKEY@g" 
sudo grep -rl VALUEOF-APPLICATION-INSIGHTS-KEY /source/AppDev-ContainerDemo --exclude /source/AppDev-ContainerDemo/2-setup-demo.sh  | sudo xargs sed -i -e "s@VALUEOF-APPLICATION-INSIGHTS-KEY@$DEMO_APPLICATION_INSIGHTS_KEY@g"

#Set Scripts as executable
echo ".Setting scripts as executable"
sudo chmod +x /source/AppDev-ContainerDemo/envrionment/set-scripts-executable.sh
/source/AppDev-ContainerDemo/envrionment/set-scripts-executable.sh



sudo chmod 777 -R /source

echo ""
echo "Complete"
echo ""
