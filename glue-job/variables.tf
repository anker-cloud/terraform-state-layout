variable "bucket"{
    type = string
    description = "s3 bucket with the pyspark scripts"
}
variable "bucket2"{
    type = string
    description = "s3 bucket which the job uses as input"
}
variable "bucket3"{
    type = string
    description = "s3 bucket which the job uses as output"
}

variable "tag_name"{
    type = string
    description = "tag for the ressources"
}

variable "name"{
    type = string
    description = "tjob name"
}