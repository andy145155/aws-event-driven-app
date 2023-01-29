output "sqs_arn" {
  value = aws_sqs_queue.event_driven_sqs.arn
}
