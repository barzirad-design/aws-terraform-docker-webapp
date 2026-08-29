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
<img width="1528" height="963" alt="צילום מסך 2026-08-29 225201" src="https://github.com/user-attachments/assets/ebfc0d9d-abd2-476c-bb96-6f517b9d2280" />


### 2. Deployed Application Running on AWS EC2
<img width="1916" height="795" alt="צילום מסך 2026-08-29 225305" src="https://github.com/user-attachments/assets/f5a9f1b8-4296-4717-a191-81d52084efca" />


### 3. Resource Cleanup (Terraform Destroy)
<img width="1505" height="957" alt="צילום מסך 2026-08-29 225644" src="https://github.com/user-attachments/assets/555dc7da-b209-4bae-96ec-d3be0a29f058" />

