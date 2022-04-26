resource "aws_s3_bucket" "b" {
  bucket = "${terraform.workspace}-${var.tag-name}-${var.bucket-name}"
  tags = {
    Name = var.tag-name
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.b.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
/* 
data "aws_iam_policy_document" "bp" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::515473365226:user/dev_elias"]
    }
    effect = "Allow"
    actions = ["s3:ListBucket"]

    resources = [
      aws_s3_bucket.b.arn,
      "${aws_s3_bucket.b.arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:username"

      values = [
        "arn:aws:iam::515473365226:user/dev_elias"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.bp.json
} */
