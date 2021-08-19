<h1 align="center">
AWS CLI
</h1>
<p align="center">By Sanjeev Thiyagarajan</p>

1. [AWS Configure](#aws-configure)
2. [Key Pairs](#key-pairs)
3. [Instances](#instances)


## AWS Configure

Create ~/.aws/credentials and ~/.aws/configure.
```
> aws configure

# from the AWS console, go to user profile, My Security Credentials, Access Keys
# then Create New Access Key, Show Access Key

AWS Access Key ID [****************UENB]: 
AWS Secret Access Key [****************J6pH]: 
Default region name [us-west-2]: us-west-1
Default output format [None]: json
```

## Key Pairs

1. Create key pair
```
aws ec2 create-key-pair --key-name MyKey --query 'KeyMaterial' --output text > MyKey.pem
```

2. Delete key pair
```
aws ec2 delete-key-pair --key-name MyKey
```

3. Describe key pairs
```
# describe all key pairs
aws ec2 describe-key-pairs 
# describe specific key pair
aws ec2 describe-key-pairs  --key-name MyKey 
```

## Instances

1. Create instance
```
aws ec2 run-instances --image-id ami-0d382e80be7ffdae5 --count 1 --instance-type t2.micro --key-name MyKey --security-group-id sg-0f828466c4004b762
```

2. Add tags to instance
```
aws ec2 create-tags --resource i-0b2a534d557812995 --tags Key=Name, Value=prod-webserver
```

3. Describe instances
```
# describe all instances
aws ec2 describe-instances
# describe specific instance
aws ec2 describe-instances --instance-id i-0b2a534d557812995
```

4. Delete instances
```
aws ec2 terminate-instances --instance-ids i-0b2a534d557812995 i-0149aad80b05a0eea
```