# Root variables
region  = "ap-southeast-1"
service = "event-driven-app"

# VPC variable value
main_vpc_cidr    = "10.0.0.0/24"
public_subnet_a  = "10.0.0.0/26"
public_subnet_b  = "10.0.0.64/26"
private_subnet_a = "10.0.0.128/26"
private_subnet_b = "10.0.0.192/26"
dns_support      = true
dns_hostnames    = true
state            = "available"

# RDS variable value 
allocated_storage = 20
engine            = "mysql"
engine_version    = "5.7"
instance_class    = "db.t2.micro"
name              = "eventDrivenApp"
username          = "admin"

# S3 buckets variable value
event_driven_app_bucket_acl = "private"
s3_bucket_names             = ["event-driven-app-csv-bucket", "rds-cert-bucket"]


# IAM variable value
db_user       = "user-event-driven"
iam_user_name = "event-app"

# SQS variable value
sqs_name = "event-driven-sqs"
