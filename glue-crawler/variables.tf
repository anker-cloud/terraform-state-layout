variable "cata-name"{
    type = string
    description = "name of the glue catalogue which will be enriched"
}

variable "name"{
    type = string
    description = "name of the glue crawler"
}

variable "bucket"{
    type = string
    description = "s3 bucket which the rawler accesses"
}

variable "tag_name"{
    type = string
    description = "tag for the ressources"
}