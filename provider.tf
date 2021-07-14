terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "qa"
      Project     = "homet"
      Costcenter  = "ondemandht"
    }
  }

}

provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}


provider "kubernetes" {
  host                   = aws_eks_cluster.eks-cluster.endpoint                                    // k8s에서 연동할 endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data) // eks 생성될 떄 k8s와 연동가능한 인증서와 토큰이 발급됨
  token                  = aws_eks_cluster.eks-cluster.token
  load_config_file       = false // true면 kubeconfig와 같이 로컬에서 접근하는 인증을 뜻함. 위 cert와 token을 사용하니 false로 셋팅
}
