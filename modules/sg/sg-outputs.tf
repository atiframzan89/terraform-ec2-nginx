output "alb-ext-sg" {
    value = aws_security_group.alb-ext-sg.id
}

output "ec2-bastion-sg" {
    value = aws_security_group.ec2-bastion-sg.id
}

output "ec2-web-sg" {
    value = aws_security_group.ec2-web-sg.id
}
