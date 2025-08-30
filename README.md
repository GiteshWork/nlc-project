====================================================================== S E C U R E S E R V E R L E S S P L A T F O R M o n A W S
This repository contains a comprehensive, production-ready serverless application on AWS. This project serves as a practical, hands-on demonstration of the key AWS-native skills required for the DevOps Engineer (AWS Focus) role at No Limit Creatives, including serverless architecture, secure data management, and global content delivery.

🏛️ ARCHITECTURE OVERVIEW
The architecture is built on a secure, multi-AZ foundation within a custom VPC. It features an event-driven pipeline where an S3 upload triggers a Lambda function. This function securely interacts with an RDS database for data and is delivered globally and protected by CloudFront and AWS WAF.

+---------------------+      +----------------+      +-------------------+
|      End User       | ---> |   CloudFront   | ---> |    API Gateway    |
+---------------------+      |      (WAF)     |      +-------------------+
                           +----------------+             |
                                                          | (Invokes)
                                                          v
                                                    +-------------------+
                                                    |   AWS Lambda      |
                                                    | (Application Logic) |
                                                    +-------------------+
                                                          |         ^
                                                          |         | (Trigger)
                           (Reads Secret)                 v         |
+--------------------------+      +-------------------+      +-------------+
|   AWS Secrets Manager    | <--- |   Amazon RDS      |      |  Amazon S3  |
| (Database Credentials)   |      | (PostgreSQL)      | <--- |  (Uploads)  |
+--------------------------+      +-------------------+      +-------------+


A high-level diagram of the deployed serverless infrastructure.

Core Components:
🌐 Networking: A custom AWS VPC with public and private subnets.

🗄️ Data Tier: A managed Amazon RDS for PostgreSQL instance in a private subnet.

🔐 Secrets Management: Database credentials are securely generated and stored in AWS Secrets Manager.

💻 Serverless Compute: An AWS Lambda function (Python) acts as the application's core logic.

⚡ Event Trigger: An Amazon S3 bucket that triggers the Lambda function upon new object creation.

🛡️ Delivery & Security: An API Gateway provides an endpoint for the Lambda, which is then served globally by Amazon CloudFront and protected by AWS WAF.

📊 Monitoring: A custom CloudWatch Dashboard provides a single-pane-of-glass view of the entire stack's health.

✅ KEY SKILLS DEMONSTRATED (vs. NLC Job Description)
This project is a direct showcase of the following key skills and responsibilities:

JD Requirement

How It's Demonstrated in This Project

AWS Infrastructure Management

Deployed and configured RDS, S3, Lambda, and CloudFront.

Serverless Application Design

Built an event-driven, serverless pipeline from scratch, demonstrating a modern architectural approach.

Security & Compliance

Implemented IAM best practices, managed credentials with AWS Secrets Manager, and protected the application with AWS WAF.

Infrastructure as Code (IaC)

The entire infrastructure is defined and managed using Terraform.

Monitoring & Incident Response

Created a custom CloudWatch Dashboard from code to monitor the performance of all key services.

Networking & CDN Management

Configured a multi-AZ VPC and used CloudFront to deliver the application globally.

🚀 STEP-BY-STEP IMPLEMENTATION GUIDE
Follow these steps to deploy the complete infrastructure and application.

1. Prerequisites
An AWS account with the AWS CLI configured.

Terraform (>= 1.0.0) installed.

2. Deploy the Infrastructure
This project is defined in a single, consolidated Terraform configuration.

# Create a unique S3 bucket for the Terraform backend
# (Replace 'your-unique-name' with a globally unique bucket name)
aws s3api create-bucket --bucket your-unique-name --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1

# Initialize Terraform (will download necessary providers and modules)
terraform init

# Deploy the entire infrastructure stack
terraform apply -auto-approve

3. Test the Application
Once terraform apply is complete, the CloudFront distribution URL will be in the output.

Test the Serverless API: Paste the cloudfront_domain_name output into your browser. This will invoke the Lambda function.

Test the S3 Trigger:

Find the S3 bucket named nlc-serverless-raw-uploads-... in your AWS Console.

Upload any image file to it.

Go to the CloudWatch service, find the log group for the nlc-image-processor Lambda function, and you will see the log output from the successful trigger.

4. View the Monitoring Dashboard
Navigate to the CloudWatch service in your AWS Console.

Click on Dashboards in the left menu.

Click on the "NLC-Serverless-Platform-Dashboard" to see the live metrics from your RDS, Lambda, CloudFront, and WAF resources.

5. Clean Up
To avoid incurring AWS costs, you can destroy all the resources created by this project with a single command:

terraform destroy -auto-approve
