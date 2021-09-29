output "public_subnet_ids" {
  value = aws_subnet.application_public_subnet.*.id
}