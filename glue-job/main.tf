data "aws_iam_policy" "glue" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role" "glue-job-role" {
  name = "AWSGlueServiceRole-${var.name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [data.aws_iam_policy.glue.arn]
  tags = {
    Name = var.tag_name
  }
}

resource "aws_iam_role_policy" "s3-access" {
  name = "${var.bucket}-access-policy-for-${var.name}"
  role = aws_iam_role.glue-job-role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": [
        "arn:aws:s3:::${var.bucket}",
        "arn:aws:s3:::${var.bucket}/*",
        "arn:aws:s3:::${var.bucket2}",
        "arn:aws:s3:::${var.bucket2}/*",
        "arn:aws:s3:::${var.bucket3}",
        "arn:aws:s3:::${var.bucket3}/*"]
    }
  ]
}
EOF
}

resource "aws_glue_job" "example" {
    name                = var.name
    role_arn            = aws_iam_role.glue-job-role.arn
    command {
        script_location = "s3://${var.bucket}/pyspark-code/etl-script.py"
    }
    timeout             = 5
    glue_version        = "3.0"
    worker_type         = "G.1X"
    number_of_workers   = 2
    default_arguments = {
    # ... potentially other arguments ...
    #"--continuous-log-logGroup"          = aws_cloudwatch_log_group.example.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
  }
}