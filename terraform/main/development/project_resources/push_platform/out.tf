output "sqs_arn" {
  value = aws_sqs_queue.queue.arn
}

output "sqs_url" {
  value = aws_sqs_queue.queue.url
}

output "sqs_dlq_arn" {
  value = aws_sqs_queue.queue_deadletter.arn
}

output "sqs_dlq_url" {
  value = aws_sqs_queue.queue_deadletter.url
}