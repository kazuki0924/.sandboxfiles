output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.cognito_user_pool.id
  sensitive = true
}
