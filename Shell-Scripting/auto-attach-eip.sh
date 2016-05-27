#Set AWS_ACCESS_KEY, AWS_SECRET_KEY and  AWS_DEFAULT_REGION
cd /home/ec2-user
rm -rf awscli-bundle
rm -rf awscli-bundle.zip
wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
./awscli-bundle/install -b ~/bin/aws
echo $PATH | grep ~/bin
export PATH=~/bin:$PATH
aws configure set aws_access_key_id AKIAJ44ATOLXMDW65KEA
aws configure set aws_secret_access_key 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
aws configure set region us-east-1
aws configure set output json
# Allocate a new EIP and store it in a variable (say allocated_eip)
allocated_eip=$(aws ec2 allocate-address --output table | perl -lne 'print $& if /(\d+\.){3}\d+/')
#Get the instance ID of the current instance from its metadata 
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
#Associate allocated_eip to instance_id
aws ec2 associate-address --instance-id $instance_id --public-ip $allocated_eip


#############################################################
#This script is wor king for single instance in auto scaling group

#!/bin/bash
#aws cli installation
cd /home/ec2-user
rm -rf awscli-bundle
rm -rf awscli-bundle.zip
wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
./awscli-bundle/install -b ~/bin/aws
echo $PATH | grep ~/bin
export PATH=~/bin:$PATH
aws configure set aws_access_key_id AKIAJ44ATOLXMDW65KEA
aws configure set aws_secret_access_key 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
aws configure set region us-east-1
aws configure set output json
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
ALLOCATION_ID=eipalloc-cb8758b2
aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $ALLOCATION_ID --allow-reassociation

