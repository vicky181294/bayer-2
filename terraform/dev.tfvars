#variables for dev env
aws_region            = "us-east-1"
log_group_name        = "/aws/dev/ecs/bayer"
env                   = "dev"
domain                = "bayer"
tag_env               = "Development"
ecs_cluster_id        = "arn:aws:ecs:us-east-1:539935451710:cluster/bayer-cluster-dev"
# ECSTaskExecution_role = "ECSTaskExecution_role"
retention_day         = 30

ecs_services = [
  {
    name          = "appointment"
    cpu           = 512
    memory        = 1024
    desired_count = 2
  },
  {
    name          = "patient"
    cpu           = 256
    memory        = 512
    desired_count = 2
  }
]

#terraform init -backend-config=backend-dev.hcl
#terraform plan -var-file="dev.tfvars"
#terraform apply -var-file="dev.tfvars"
#dev accound id =379722418906