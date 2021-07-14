#####################
# default tag
#####################
variable "env" {
  default = "qa"
}

variable "pjt" {
  default = "homet"
}

variable "costc" {
  default = "ondemandht"
}





#####################
# vpc
#####################
variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "az_a" {
  default = "ap-northeast-2a"
}

variable "az_c" {
  default = "ap-northeast-2c"
}

variable "vpc_cidr" {
  type    = string
  default = "172.31.62.128/25"
}

variable "secondary_cidr" {
  description = "pod에 ip 할당하기 위함"
  default     = "100.64.2.0/23"
}

#####################
# subnet
#####################
variable "puba_cidr" {
  type    = string
  default = "172.31.62.128/28"
}

variable "pubc_cidr" {
  default = "172.31.62.144/28"
}

variable "pria_cidr" {
  default = "172.31.62.160/27"
}

variable "pric_cidr" {
  default = "172.31.62.192/27"
}
variable "pria_db_cidr" {
  default = "172.31.62.224/28"
}
variable "pric_db_cidr" {
  default = "172.31.62.240/28"
}
variable "pria_pod_cidr" {
  default = "100.64.2.0/24"
}
variable "pric_pod_cidr" {
  default = "100.64.3.0/24"
}

#####################
# bastion-ec2
#####################
variable "key_name" {
  default = "bastion-key"
}

variable "bastion_ami" {
  default = "ami-027ce4ce0590e3c98"
}

variable "bastion_type" {
  default = "t2.small"
}

variable "bastion_cidr_block" {
  description = "bastion 서버 ingress 허용하는 cidr_block"
  type        = list(string)
  default     = ["211.196.252.99/32","219.248.137.8/32","219.248.137.7/32","27.122.140.10/32","210.181.108.242/32","164.124.106.147/32","164.124.106.224/32", "0.0.0.0/0"]
}

#####################
# eks-node
#####################
variable "node_instance_types" {
  type    = list(string)
  default = ["m5.large"]
}

variable "node_disk_size" {
  type    = number
  default = 100
}

variable "scailing_desired" {
  description = "scailing cofnig. desired size"
  type        = number
  default     = 2
}

variable "scailing_max" {
  description = "scailing cofnig. max size"
  type        = number
  default     = 3
}

variable "scailing_min" {
  description = "scailing cofnig. min size"
  type        = number
  default     = 2
}

#####################
# ecr
#####################
variable "image_tag_mutability" {
  description = "동일 이미지 태그 덮어쓰기 가능여부, MUTABLE: 가능/ IMMUTABLE: 불가능"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "리포지토리에 푸시된 후 각 이미지를 자동으로 스캔여부"
  type        = bool
  default     = false
}

#####################
# s3, cloudfront
#####################
variable "domain" {
  type    = string
  default = "space308.synology.me"
#  default = "qa.htnow.uplus.co.kr"
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  type        = string
  default     = "index.html"
}

variable "origin_id" {
  type    = string
  default = "s3-transcoded-origin"
}

#####################
# lambda
#####################
variable "lambda_runtime" {
  type    = string
  default = "python3.8"
}



#####################
# db
#####################

variable "db_engine" {
  description = "Oracle Enterprise Edition (BYOL만 가능), Standard Edition 2 (license-included 가능한 에디션)"
  default     = "oracle-ee"
}

variable "db_engine_version" {
  default = "19.0.0.0.ru-2021-01.rur-2021-01.r2"
}

variable "db_license_model" {
  default = "bring-your-own-license"
}

variable "db_name" {
  description = "DB이름. 대문자 필수"
  type        = list(string)
  default     = ["SERVICE", "STAT"]
}

variable "db_instance_class" {
  type    = list(string)
  default = ["db.m5.large", "db.m5.large"]
}

variable "db_allocated_storage" {
  type    = list(number)
  default = [100, 100]
}

variable "db_port" {
  type    = list(number)
  default = [1521, 1521]
}

variable "db_username" {
  type    = list(string)
  default = ["admin", "admin"]
}

variable "db_password" {
  type    = list(string)
  default = ["password", "password"]
}

variable "db_character_set_name" {
  type    = string
  default = "UTF8"
}

#####################
# db - parameter group
#####################


variable "db_family" {
  description = "db parameter group family"
  type        = string
  default     = "oracle-ee-19"
}

#####################
# db - option group
#####################
variable "db_engine_name" {
  type    = string
  default = "oracle-ee"
}

variable "db_major_engine_version" {
  type    = string
  default = "19"
}


#####################
# elasticsearch
#####################
variable "es_version" {
  description = "도메인에 대한 ES 버전, 최신 버전 권장"
  type        = string
  default     = "7.10"
}

variable "es_zone" {
  description = "cluster config - zone_awareness_enabled > 다중 az 배포 시 true, default 2개의 az이고 3개의 az로 설정 시 availability_zone_count 추가 필요"
  type        = bool
  default     = true
}


variable "es_type" {
  description = "cluster config - instance type"
  type        = string
  default     = "t3.medium.elasticsearch"
}

variable "es_count" {
  description = "cluster config - instance type"
  type        = number
  default     = 2
}

variable "es_ebs" {
  description = "ebs options - ebs 활성화 여부"
  type        = bool
  default     = true
}


variable "es_ebs_type" {
  description = "ebs options - volume type"
  type        = string
  default     = "gp2"
}

variable "es_ebs_size" {
  description = "ebs options - volume size"
  type        = string
  default     = "100"
}
