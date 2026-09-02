provider "aws" {
  region = "us-east-1"
}

# משיכת נתונים על הרשת הדיפולטית של אמזון כדי לחסוך לנו הקמה של רשת מאפס
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# משיכת ה-AMI העדכני ביותר של אובונטו
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# קבוצת אבטחה
resource "aws_security_group" "web_sg" {
  name        = "ha-web-sg"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# הקמת 2 שרתים במקביל
resource "aws_instance" "web_server" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.default.ids[count.index]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              docker run -d -p 80:80 barzirad/my-first-app:latest
              EOF

  tags = {
    Name = "WebServer-${count.index + 1}"
  }
}

# הקמת נתב העומסים (ALB)
resource "aws_lb" "app_alb" {
  name               = "web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [data.aws_subnets.default.ids[0], data.aws_subnets.default.ids[1]]
}

# הגדרת קבוצת המטרה שאליה נתב העומסים יעביר את התעבורה
resource "aws_lb_target_group" "app_tg" {
  name     = "web-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

# חיבור שני השרתים שלנו לקבוצת המטרה
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.web_server[count.index].id
  port             = 80
}

# הגדרת ה"מאזין" של נתב העומסים (על איזה פורט הוא מקבל בקשות מבחוץ)
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# הדפסת הכתובת של נתב העומסים בסיום ההתקנה
output "load_balancer_dns" {
  value = aws_lb.app_alb.dns_name
}
