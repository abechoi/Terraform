<h1 align="center">
Packer</h1>
<p align="center">By Sanjeev Thiyagarajan</p>

1. [AWS Configure](#aws-configure)
2. [Key Pairs](#key-pairs)
3. [Instances](#instances)
4. [S3 Buckets](#s3-buckets)


## AWS Configure

Create ~/.aws/credentials and ~/.aws/configure.
```
aws configure

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

## S3 Buckets

1. List buckets
```
# list all buckets
aws s3 ls

# list contents of a bucket
aws s3 ls s3://abechoi-bucket

# list contents of a bucket folder
aws s3 ls s3://abechoi-bucket/test-folder
```

2. Create a bucket
```
# bucket name must be globally unique
aws s3 mb s3://abechoi-bucket
```

3. Copy files
```
# copy file to bucket
aws s3 cp file.txt s3://abechoi-bucket

# copy file to a new bucket folder
aws s3 cp file.txt s3://abechoi-bucket/new-folder
```

4. Move files
```
# move file to bucket
aws s3 mv file.txt s3://abechoi-bucket
```

5. Sync up local folders to bucket
```
# sync current directory to a bucket folder
aws s3 sync . s3://abechoi-bucket/aws-cli/

# reverse-sync bucket folder to current directory
aws s3 sync s3://abechoi-bucket/aws-cli/ .

# pass delete flag to delete bucket files
aws s3 sync . s3://abechoi-bucket/aws-cli/ --delete
```

6. Delete a file
```
aws s3 rm s3://abechoi-bucket/MyKey.pem
```

6. Delete a bucket
```
# use --force if bucket is not empty
aws s3 rb s3://abechoi-bucket
```