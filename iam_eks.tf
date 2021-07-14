# 1~2 : EKS 사용을 위한 기본 IAM 정책 적용
#'EKS 클러스터(Control plan)' 와 'Worker Node'에 대한 role을 각각 생성하고 각 정책에 연결함
# 3. 서비스 시나리오 (node -> s3접근)을 위한 IAM 정책 적용


# 1-1. EKS 클러스터에 접근하기 위한 Role 생성
resource "aws_iam_role" "role_eks" {
  name = "iam-${var.env}-${var.pjt}-role-eks"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    Name    = "iam-${var.env}-${var.pjt}-role-eks",
    Service = "role-eks"
  }
}

# 1-2. EKS 클러스터를 위한 Role과 정책 연결
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.role_eks.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.role_eks.name
}


# 2-1. worker node를 위한 role 생성
resource "aws_iam_role" "role_node" {
  name = "iam-${var.env}-${var.pjt}-role-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    Name    = "iam-${var.env}-${var.pjt}-role-node",
    Service = "role-node"
  }
}

# 2-2. worker node를 위한 role과 정책 연결
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.role_node.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" { // AWS CNI가 VPC CIDR을 가지고 IP 할당하기에 필요 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.role_node.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.role_node.name
}

# 3-1. node -> s3 접근을 위한 정책 생성
resource "aws_iam_policy" "policy_nodes3" {
  name = "iam-${var.env}-${var.pjt}-policy-nodes3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::s3-qa-homet-original",
          "arn:aws:s3:::s3-qa-homet-original/*",
          "arn:aws:s3:::s3-qa-homet-transcoded",
          "arn:aws:s3:::s3-qa-homet-transcoded/*",
        ]
      },
    ]
  })

  tags = {
    Name    = "iam-${var.env}-${var.pjt}-policy-nodes3",
    Service = "policy-nodes3"
  }
}

resource "aws_iam_policy" "policy_ecr" {
  name = "poli-dev-homet-ecr-pod"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      }
    ]
  })
}


# 3-2. 3-1에서 만든 정책을 node role 에 연결
resource "aws_iam_role_policy_attachment" "policy_nodes3" {
  depends_on = [aws_iam_policy.policy_nodes3]
  policy_arn = aws_iam_policy.policy_nodes3.arn
  #    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = aws_iam_role.role_node.name
}

resource "aws_iam_role_policy_attachment" "policy_ecr" {
  depends_on = [aws_iam_policy.policy_ecr]
  policy_arn = aws_iam_policy.policy_ecr.arn
  #    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = aws_iam_role.role_node.name
}
