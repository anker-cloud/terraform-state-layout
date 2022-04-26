variable "timeout"{
    type = number
    description = "time till aws lambda will timeout"
}

variable "python-version"{
    type = string
    description = "name of the python version, eg python3.6"
}

variable "location-lambda-zip"{
    type = string
    description = "file path lambda code"
}

variable "lambda-handler"{
    type = string
    description = "function name of the lambda handler"
}
