# BM-Task

## Application
This is a simple HTTP API with Live endpoint that connects to a database. if the connection is successful, it will display a message "Well Done. if not, it will display the word "Maintenance". Spring Boot framework was used in the development of this application with a class called Demo Application that contans the main function and a Live Controller class with the Rest Controller responsible for the connection with the database.

## Terraform
To provide the infrastructure needed for this application, Terraform was used. All the configurations needed will be found in the main.tf configuration file under the Terraform folder. This configuration include: An Azure app service to deploy our application on, A SQL server and database, an autoscale monitor to avoid overload on our service, a security group to control incoming and outgoing packets, and finally a monitor for HTTP error with an alerting function.

## Azure
The infrastructure provided is used to deploy this application on Azure components. Terraform creates an app service and a database integrated with Azure. Use Azure pipelines to run the terraform. yaml file to create the infrastructure components. Afterwards, use the cicd.yaml file to build and deploy the application to the created app service on Azure.

