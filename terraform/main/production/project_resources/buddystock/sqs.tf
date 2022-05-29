resource "aws_sqs_queue" "queue" {
  name                      = "${local.meta.team}-${local.meta.service_queue}-${local.meta.env}"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.queue_deadletter.arn
    maxReceiveCount     = 4
  })
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.queue_deadletter.arn]
  })

  tags = {
    Name        = "${local.meta.team}-${local.meta.service_queue}-${local.meta.env}"
    Service     = local.meta.service_queue
    Environment = local.meta.env
    Team        = local.meta.team
  }
}

resource "aws_sqs_queue" "queue_deadletter" {
  name                      = "${local.meta.team}-${local.meta.service_queue}-deadletter-${local.meta.env}"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Name        = "${local.meta.team}-${local.meta.service_queue}-${local.meta.env}"
    Service     = local.meta.service_queue
    Environment = local.meta.env
    Team        = local.meta.team
  }
}