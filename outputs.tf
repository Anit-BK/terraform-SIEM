output "elk_public_ip" {
  value = aws_instance.elk.public_ip
}

output "splunk_public_ip" {
  value = aws_instance.splunk.public_ip
}

output "cribl_public_ip" {
  value = aws_instance.cribl.public_ip
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

