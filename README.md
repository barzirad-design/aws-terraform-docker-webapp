# Automated Web Server Provisioning with Terraform & Docker ☁️

## Overview
This project demonstrates the automation of cloud infrastructure using **Terraform** to provision an **AWS EC2 instance**, and **Docker** to containerize and deploy a custom Nginx web application. 

## Architecture & Technologies
* **Infrastructure as Code (IaC):** Terraform (`main.tf`)
* **Cloud Provider:** Amazon Web Services (AWS)
* **Containerization:** Docker & Docker Hub
* **Web Server:** Nginx (Alpine Linux)

## How It Works
1. A custom `Dockerfile` packages an HTML page into a lightweight Nginx container image.
2. The image is published to a public Docker Hub repository.
3. Terraform automates the infrastructure deployment by provisioning a `t2.micro` EC2 instance and configuring a Security Group to allow inbound HTTP traffic (Port 80).
4. An automated `user_data` bash script runs upon server boot, installs Docker, pulls the image from Docker Hub, and runs the container.

## Project Screenshots

### 1. Infrastructure Provisioning (Terraform Apply)
![Terraform Apply](<225201 2026-08-29 צילום מסך.png>)

### 2. Deployed Application Running on AWS EC2
![Web App](<225305 2026-08-29 צילום מסך.png>)

### 3. Resource Cleanup (Terraform Destroy)
![Terraform Destroy](<225644 2026-08-29 צילום מסך.png>)
