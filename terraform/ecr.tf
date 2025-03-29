resource "aws_ecr_repository" "ECR_registry_patient" {
  name = "${var.env}/${var.domain}/patient"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.default_tags
}

resource "aws_ecr_repository" "ECR_registry_appointment" {
  name = "${var.env}/${var.domain}/appointment"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.default_tags
}