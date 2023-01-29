output "event_driven_app_csv_buckets_id" {
  value = aws_s3_bucket.event_driven_app_buckets[0].id
}

output "event_driven_app_csv_buckets_arn" {
  value = aws_s3_bucket.event_driven_app_buckets[0].arn
}

output "event_driven_app_csv_buckets_name" {
  value = aws_s3_bucket.event_driven_app_buckets[0].bucket
}

output "event_driven_app_ssl_buckets_name" {
  value = aws_s3_bucket.event_driven_app_buckets[1].bucket
}

output "s3_vpce_prefix_list" {
  value = data.aws_prefix_list.s3_vpce_prefix_list
}
