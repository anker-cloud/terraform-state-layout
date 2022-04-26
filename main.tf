provider "aws" {
  region     = "eu-central-1"  
}

terraform {
  backend "s3" {
    bucket = "5154-7336-5226-terraform-states"
    key    = "task3/"
    region = "eu-central-1"  
  }
}

locals {
  tag_name = "task3"
  function_name = "task3-athena-query"
}

module "terraform-bucket1"{
    source      = "./module/bucket"
    tag-name    = local.tag_name
    bucket-name = "raw"
}

module "terraform-bucket2"{
    source      = "./module/bucket"
    tag-name    = local.tag_name
    bucket-name = "curated"
}

module "terraform-bucket3"{
    source      = "./module/bucket"
    tag-name    = local.tag_name
    bucket-name = "use-case-a"
}

resource "aws_glue_catalog_database" "db" {
  name = "terraform-raw"
}

resource "aws_glue_catalog_database" "db2" {
  name = "terraform-curated"
}

module "crawler"{
    source      = "./module/glue-crawler"
    name        = "raw-crawler-terraform"
    cata-name   = aws_glue_catalog_database.db.name
    tag_name    = local.tag_name
    bucket      = module.buck1.bucket.id
}

module "crawler2"{
    source      = "./module/glue-crawler"
    name        = "curated-crawler-terraform"
    cata-name   = aws_glue_catalog_database.db2.name
    tag_name    = local.tag_name
    bucket      = module.buck2.bucket.id
}

module "terraform-bucket4"{
    source      = "./module/bucket"
    tag-name    = local.tag_name
    bucket-name = "glue-job-scripts"
}

module "glue-job"{
    source      = "./module/glue-job"
    name        = "terraform-etl"
    tag_name    = local.tag_name
    bucket      = module.buck4.bucket.id
    bucket2     = module.buck1.bucket.id
    bucket3     = module.buck2.bucket.id
}

module "lambda"{
    source              = "./module/lambda-func"
    tag-name            = local.tag_name
    lambda-handler      = var.lambda-handler
    lambda-func-name    = local.function_name
    location-lambda-zip = var.location-lambda-zip
    timeout             = var.timeout
    python-version      = var.python-version
    bucket-id-trigger   = module.buck1.bucket.id
}
