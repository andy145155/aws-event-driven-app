resource "aws_sqs_queue" "event_driven_sqs" {
  name                       = var.sqs_name
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 25
}

resource "aws_sqs_queue" "event_driven_sqs_deadletter" {
  name = "${var.service}-deadletter-queue"
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.event_driven_sqs.arn]
  })
}

resource "aws_sqs_queue_redrive_policy" "redrive_policy" {
  queue_url = aws_sqs_queue.event_driven_sqs.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.event_driven_sqs_deadletter.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.event_driven_sqs.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "sqspolicy",
    "Statement" : [
      {
        "Sid" : "allowS3ToSqs",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com",
        },
        "Action" : [
          "SQS:SendMessage"
        ],
        "Resource" : "${aws_sqs_queue.event_driven_sqs.arn}",
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "${var.event_driven_app_csv_buckets_arn}"
          },
        }
      }
    ]
  })
}
