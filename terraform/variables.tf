#variables from Jenkins job
# variable "access_key" {
#   description = "AWS access key"
# }

# variable "secret_key" {
#   description = "AWS secret key"
# }

variable "retention_day" {
  type = number
}

# variables to be changed based on env or cluster
variable "log_group_name" {
  description = "The name of the log group."
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "domain" {
  description = "Based on the cluster domain value is assigned"
  type        = string
}

variable "ecs_cluster_id" {
  description = "The id of the cluster"
  type        = string
}

variable "ECSTaskExecution_role" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "tag_env" {
  description = "enter name for the tag resource"
  type        = string
}

locals {
  default_tags = {
    Author                    = "Vignesh Chakravarthy"
    ApplicationName           = "Bayer"
    BackupPolicy              = ""
    BusinessOwner             = ""
    Customer                  = ""
    DataHighestClassification = "Confidential"
    DataPCI                   = "Yes"
    DataPII                   = "Yes"
    Department                = "Data Transformation"
    Environment               = var.tag_env
    ProjectID                 = "PRJ0026689"
    ProjectManager            = ""
    ProjectName               = "Bayer-ecs"
    ResourceFunction          = "Data Processor"
    ResourceRequestID         = ""
    Retention                 = ""
    RotateImage               = ""
    ScannablePorts            = ""
    TechnicalOwner            = ""
    Template                  = ""
    TemplateURL               = ""
    Terraform                 = true
  }
}


variable "ecs_services" {
  description = "List of ECS services"
  type = list(object({
    name          = string
    cpu           = number
    memory        = number
    desired_count = number
  }))
}

