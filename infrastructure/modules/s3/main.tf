resource "aws_s3_bucket" "event_driven_app_buckets" {
  count  = length(var.s3_bucket_names)
  bucket = var.s3_bucket_names[count.index]
}

resource "aws_s3_bucket_acl" "event_driven_app_buckets" {
  count  = length(var.s3_bucket_names)
  bucket = aws_s3_bucket.event_driven_app_buckets[count.index].id
  acl    = var.event_driven_app_bucket_acl
}

resource "aws_s3_bucket_versioning" "event_driven_app_buckets" {
  count  = length(var.s3_bucket_names)
  bucket = aws_s3_bucket.event_driven_app_buckets[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "event_driven_app_buckets" {
  count  = length(var.s3_bucket_names)
  bucket = aws_s3_bucket.event_driven_app_buckets[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_object" "event_driven_app_rds_ssl_cert" {
  bucket = aws_s3_bucket.event_driven_app_buckets[1].id
  key    = "ap-southeast-1-bundle.pem"
  acl    = var.event_driven_app_bucket_acl
  source = "/workspaces/event-driven-app/.credentials/ap-southeast-1-bundle.pem"
  etag   = filemd5("/workspaces/event-driven-app/.credentials/ap-southeast-1-bundle.pem")

}

resource "aws_vpc_endpoint" "event_driven_app_buckets" {
  vpc_id            = var.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.ap-southeast-1.s3"
  route_table_ids = [
    var.private_route_table_id
  ]
  private_dns_enabled = false

  tags = {
    Name = "Event driven app s3 vpc endpoint"
  }
}

resource "aws_vpc_endpoint_policy" "event_driven_app_buckets" {
  vpc_endpoint_id = aws_vpc_endpoint.event_driven_app_buckets.id
  count           = length(var.s3_bucket_names)

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Access-to-specific-s3-only",
        "Principal" : "*",
        "Action" : [
          "s3:GetObject",
          "s3:GetBucketPolicy",
        ],
        "Effect" : "Allow",
        "Resource" : [
          "${aws_s3_bucket.event_driven_app_buckets[0].arn}",
          "${aws_s3_bucket.event_driven_app_buckets[0].arn}/*",
          "${aws_s3_bucket.event_driven_app_buckets[1].arn}",
          "${aws_s3_bucket.event_driven_app_buckets[1].arn}/*"
        ],
      }
    ]
  })
}


resource "aws_vpc_endpoint_route_table_association" "gw_endpoint_rt_association" {
  route_table_id  = var.private_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.event_driven_app_buckets.id
}

resource "aws_s3_bucket_policy" "csv_bucket_policy" {
  bucket = aws_s3_bucket.event_driven_app_buckets[count.index].id
  count  = length(var.s3_bucket_names)
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "${var.service}-bucket-policy",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:GetBucketPolicy",
        ],
        "Resource" : [
          "${aws_s3_bucket.event_driven_app_buckets[count.index].arn}",
          "${aws_s3_bucket.event_driven_app_buckets[count.index].arn}/*"
        ],
        "Principal" : {
          "AWS" : "${var.current_iam_caller_account_id}"
        },
        "Condition" : {
          "StringEquals" : {
            "aws:sourceVpce" : "${aws_vpc_endpoint.event_driven_app_buckets.id}",
          },
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.event_driven_app_buckets[0].id

  queue {
    queue_arn = var.sqs_arn
    events    = ["s3:ObjectCreated:*"]
  }
}

data "aws_prefix_list" "s3_vpce_prefix_list" {
  prefix_list_id = aws_vpc_endpoint.event_driven_app_buckets.prefix_list_id
}
