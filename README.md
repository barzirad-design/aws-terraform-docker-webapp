# Highly Available Web Application with Terraform & Docker ☁️

## Overview
This project demonstrates a production-grade cloud architecture by deploying a containerized Nginx web application across multiple Availability Zones (Multi-AZ) using **AWS**, **Terraform**, and **Docker**.

## Architecture & Technologies
* **Infrastructure as Code (IaC):** Terraform (`main.tf`)
* **Cloud Provider:** Amazon Web Services (AWS)
* **High Availability:** Application Load Balancer (ALB) & Multi-AZ EC2 Instances
* **Containerization:** Docker & Docker Hub
* **Web Server:** Nginx (Alpine Linux)

## How It Works
1. A custom `Dockerfile` packages an HTML page into a lightweight Nginx container image.
2. The image is published to a public Docker Hub repository.
3. Terraform automates the infrastructure deployment by provisioning **two `t2.micro` EC2 instances** in separate Availability Zones.
4. An **Application Load Balancer (ALB)** is configured to distribute incoming HTTP traffic evenly across both instances, ensuring fault tolerance.
5. An automated `user_data` script runs upon boot on both servers, installs Docker, pulls the image, and runs the container.

## Project Screenshots

### 1. Infrastructure Provisioning (Terraform Apply)


### 2. Deployed Application Running on AWS EC2
<img width="1552" height="267" alt="צילום מסך 2026-09-02 113556" src="https://github.com/user-attachments/assets/15a5c2d0-fc7f-4479-81b7-aa471534d838" />


### 3. Resource Cleanup (Terraform Destroy)
<img width="1511" height="911" alt="צילום מסך 2026-09-02 203954" src="https://github.com/user-attachments/assets/9bece5c7-7390-41cc-bba2-c213c10c8125" />

