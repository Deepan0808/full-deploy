
#Security-group

resource "aws_security_group" "sg" {
  name   = "Devops-workflow-sg"
  vpc_id = aws_vpc.main.id

  ingress = []
  egress  = []
}

#EC2-keypair

resource "aws_key_pair" "main"{
  key_name = "backend"
  public_key = file(ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD5WUcOC8Bx6QdQDPJJoDXuhn8715LcdXDJXPqTKO2D1tI+JIYeyn7Q5JWg9eZ2odS1GIPHM5A0XzLaoY4/BnuW7smBjtFVTP80D+4+blfVFtnTcuE7+RLb/wxvD8F2CFXHy643A9oM2HukCT9o5lHg5JdtftpQnInH1WGsVJ7uu7IUNn6UhOfy3nrQkgdNez1aCMNV6fchblZ4iTEEZ+0NR1XFhyUEk/cJj3gbjUx/edqxhh4cYiPiJTS0S7G1E/PSG6QalXQIxNq2c6uUqbQ3dUzz8XWCEB/G/m8TApWluh+otWp35OodiZ7wMBdyDeJ4IV0Jdx51xw2IMiv7VZ47pklPwJOaOa/CBGfcvhQ1PnZPantmoUbsapMGOtWosXxVvnQLUWvDH9X2O27FKVAOOtdz88BeP1VCDTI5ZlA2iSCsZ0EPwkSYE0j94zl0SmQflXCrr8eKXvhQS6dJqCN/wyUlqHM9HKO975UO2HswtnUdUeRuLqy7+MY2XBdaQItmf/sVCf6n0/JRwivXNm0AxrbSyWsMLvzKxvNYFhQowSA4u/4XwruLTuiIFRVUud+Gv2qUw3BqbVWK6hWPMTkmTGlaZCND9GD/vrw/l990b/SDkYNSQfwVzOEoVWrkCN5EXvgkOtsn+q4fNBfG6XMJKUAumdmGQckk+kpTBS3elw== kiaq-lap-119@kiaq-lap-119-HP-ProBook-645-G4
)
}

#Ec2-Creation

resource "aws_instance" "ins" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"

  tags = {
    Name = "Devops-workflow"
  }
}
