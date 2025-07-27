# Task 6: Deploy Strapi on AWS ECS Fargate using Terraform

## Overview

This task sets up a production-grade deployment of a Dockerized Strapi application on AWS ECS using Fargate. All infrastructure is managed using Terraform.

## Steps Performed

1. **Containerized Strapi App**  
   - Created a `Dockerfile` to build the Strapi app image.
   - Pushed image to Amazon ECR.

2. **Terraform Infrastructure Setup**
   - Used default VPC.
   - Created ECS Cluster.
   - Defined ECS Task Definition using Docker image from ECR.
   - Created ECS Service (Fargate).
   - Created Load Balancer and Security Groups.

3. **Access**  
   - Public URL is exposed via the Application Load Balancer.

## Commands

```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars" ```
Output
Load Balancer DNS: http://<alb-dns-name>

ECS Cluster: <madhan-cluster->

Task Definition: <madhan-strapi-task>


---

## ✅ **📁 Task #5: Automate Deployment with GitHub Actions + Terraform**

```markdown
# Task 5: Automate Strapi Deployment with GitHub Actions and Terraform

## Goal

Automate CI/CD for Strapi using GitHub Actions:
- CI: Build and push Docker image on every code push.
- CD: Manually trigger Terraform workflow to deploy on EC2.

## CI Workflow - `.github/workflows/ci.yml`

- Runs on push to `main`
- Builds Docker image and tags with Git SHA
- Pushes to Docker Hub
- Saves image tag as output

## CD Workflow - `.github/workflows/terraform.yml`

- Manually triggered
- Pulls latest Docker image using output tag
- Runs `terraform init`, `plan`, `apply`
- SSH into EC2 and runs Docker container with new image

## GitHub Secrets Used

- `DOCKER_USERNAME`, `DOCKER_PASSWORD`
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- `EC2_PUBLIC_IP`, `EC2_KEY`, etc.

## Notes

- Fully automated pipeline from code push to deployment.
- Redeployment possible by re-running the workflow.
# Task 4: Deploy Strapi on EC2 using Terraform and Docker

## Objective

Provision an EC2 instance using Terraform and deploy a Dockerized Strapi application automatically.

## Steps Performed

1. **Wrote Dockerfile**
   - Containerized the Strapi app
   - Tagged and pushed image to Docker Hub

2. **Terraform EC2 Setup**
   - Created EC2 instance (Amazon Linux)
   - User data script:
     - Installed Docker
     - Pulled Strapi image
     - Ran container

3. **Automation**
   - EC2 automatically runs Strapi on instance boot

## Terraform Files

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `terraform.tfvars`

## Access

- Application available at `http://<123:453:22:76>:1337`


# Task 3: Dockerized Strapi with PostgreSQL and Nginx Reverse Proxy

## Objective

Run Strapi with PostgreSQL database and expose it via Nginx on port 80.

## Docker Services

- **Strapi** – Node.js-based headless CMS
- **PostgreSQL** – For persistent database
- **Nginx** – Reverse proxy to expose Strapi dashboard on port 80

## Files Created

- `Dockerfile` – Builds the Strapi app
- `docker-compose.yml` – Defines services and networks
- `nginx.conf` – Custom Nginx config for reverse proxy

## Usage

```bash
docker network create strapi-net
docker-compose up --build

Access
Strapi Admin: http://66:54:66:321:1337
Notes
All containers run on same Docker network (strapi-net)

PostgreSQL credentials set via .env


---

## ✅ **📁 Task #2: Dockerize Strapi Locally**

```markdown
# Task 2: Dockerize Strapi Application

## Objective

Create a Dockerfile to containerize the Strapi app and run it locally.

## Files

- `Dockerfile`
- `.dockerignore`

## Dockerfile Summary

- Uses Node 18 base image
- Installs dependencies
- Copies source files
- Builds Strapi admin
- Runs the app on port 1337

## Commands

```bash
docker build -t my-strapi-app .
docker run -p 1337:1337 my-strapi-app


---

## ✅ **📁 Task #1: Clone and Run Strapi Locally**

```markdown
# Task 1: Clone & Run Strapi Locally

## Objective

- Clone Strapi from the official repo.
- Explore folder structure.
- Start the admin dashboard.
- Create a sample content type.

## Steps

1. Cloned the repo:
   ```bash
   git clone https://github.com/strapi/strapi.git
   cd strapi
Installed dependencies:

bash
Copy
Edit
npm install
Ran development server:

bash
Copy
Edit
npm run develop
Opened admin panel:

URL: http://localhost:1337/admin

Created a content type:

Name: Article

Fields: title, body

Output
Local Strapi admin panel working
