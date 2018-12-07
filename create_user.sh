#!/bin/bash
set -e

#echo "AWS Region: "
#read region
echo "IAM Group Name: "
read group
echo "IAM User Name: "
read user

aws iam create-group --group-name $group

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name $group
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name $group
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name $group
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name $group
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name $group

aws iam create-user --user-name $user

aws iam add-user-to-group --user-name $user --group-name $group

aws iam create-access-key --user-name $user
