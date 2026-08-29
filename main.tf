# 1. הגדרת ספק הענן והאזור
provider "aws" {
  region = "us-east-1"
}

# 2. חוקי אבטחה (Security Group) - חשיפת האתר לעולם
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP traffic"

  # הגדרת Ingress - כניסה: מאפשרים גישה לאתר מכל מקום באינטרנט (פורט 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # הגדרת Egress - יציאה: מאפשרים לשרת שלנו לגלוש החוצה כדי להוריד את הקונטיינר
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. השרת הוירטואלי שלנו (EC2 Instance)
resource "aws_instance" "web_server" {
  ami           = "ami-080e1f13689e07408" # מערכת הפעלה: Ubuntu 22.04
  instance_type = "t2.micro"              # סוג שרת: קטן וזול מאוד
  
  # חיבור השרת לקבוצת האבטחה שיצרנו למעלה
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # האוטומציה האמיתית: סקריפט שרץ פעם אחת אוטומטית כשהשרת עולה
  user_data = <<-EOF
              #!/bin/bash
              # עדכון השרת והתקנת Docker
              apt-get update -y
              apt-get install docker.io -y
              systemctl start docker
              systemctl enable docker
              
              # משיכת הקונטיינר שלך מהענן והרצתו על פורט 80!
              docker run -d -p 80:80 barzirad/my-first-app
              EOF

  tags = {
    Name = "MyCloudAppServer"
  }
}

# 4. הדפסת הכתובת של האתר בסיום הבנייה
output "website_url" {
  description = "The URL of the website"
  value       = "http://${aws_instance.web_server.public_ip}"
}