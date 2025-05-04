# extract cluster security group and add necessary inbound rules
cluster_sec_group=$(aws eks describe-cluster --name staging --region eu-north-1 --query cluster.resourcesVpcConfig.clusterSecurityGroupId)

if [[ $cluster_sec_group = *[!\ ]* ]]
 then
	aws ec2 authorize-security-group-ingress --group-id ${cluster_sec_group} --region eu-north-1 --protocol all --port all --cidr 172.31.0.0/16
	wait
	# enable private access and disable public access
	eksctl utils update-cluster-endpoints --cluster staging --region eu-north-1 --public-access=false --private-access=true --approve
 else
 	exit -1
 fi
