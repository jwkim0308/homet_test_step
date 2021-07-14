# s3 bucket은 총 2개 -원본영상(node access), 변환된 영상(cloudfront access)
# 모두 private으로 구성함

# 1. 원본영상(node access)
resource "aws_s3_bucket" "before" {
  bucket = "s3-${var.env}-${var.pjt}-original" // bucket naming rule에서 _ 허용 안됨. 
  acl    = "private"                         // Owner gets FULL_CONTROL. No one else has access rights (default).

  versioning {
    enabled = true // 버킷 버전 관리
  }
  tags = {
    Name    = "s3-${var.env}-${var.pjt}-original",
    Service = "original"
  }

}

resource "aws_s3_bucket_public_access_block" "before" {
  bucket = aws_s3_bucket.before.id

  block_public_acls   = true
  block_public_policy = true
}


# 2. 변환된 영상(cloudfront access) 
# 2-1. OAI 포함된 iam policy 불러와서 s3 bucket policy에 정책 넣기. 
# OAI (Origin Access ID)
# S3 버킷을 CloudFront 배포의 오리진으로 처음 설정 시 모든 사용자에게 버킷의 파일에 대한권한 부여하게됨. 누구나 CF or S3 URL 통해 파일 액세스 가능
# 이를 막기 위해 CF에서 OAI를 생성해 오리진에 접근하는 방식


# 2-2. s3 bucket 생성
resource "aws_s3_bucket" "after" {
  bucket = "s3-${var.env}-${var.pjt}-transcoded" // bucket naming rule에서 _ 허용 안됨.
  acl    = "private"                        // Owner gets FULL_CONTROL. No one else has access rights (default).

  versioning {
    enabled = true // 버킷 버전 관리
  }
  cors_rule { // 해당 버킷에 허용하는 룰. 관리자 페이지에서 영상 업로드 예정이라 GET, PUT, POST만 넣으줌
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
  tags = {
    Name    = "s3-${var.env}-${var.pjt}-transcoded",
    Service = "transcoded"
  }

}

resource "aws_s3_bucket_public_access_block" "after" {
  bucket = aws_s3_bucket.after.id

  block_public_acls   = true
  block_public_policy = true
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.after.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.OAI.iam_arn] // cloudfront.tf 파일에서 생성함
    }
  }
}

resource "aws_s3_bucket_policy" "after" {
  bucket = aws_s3_bucket.after.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
