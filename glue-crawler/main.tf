data "aws_iam_policy" "glue" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role" "crawler-role" {
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
  name = "${var.bucket}-access-policy"
  role = aws_iam_role.crawler-role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": [
        "arn:aws:s3:::${var.bucket}",
        "arn:aws:s3:::${var.bucket}/*"]
    }
  ]
}
EOF
}

/* resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.crawler-role.name
  policy_arn = aws_iam_role_policy.s3-access
} */

resource "aws_glue_crawler" "crawler" {
    database_name   = var.cata-name
    name            = var.name
    role            = aws_iam_role.crawler-role.arn
    s3_target {
        path        = "s3://${var.bucket}"
    }
    tags            = {
        Name        = var.tag_name
    } 
}

