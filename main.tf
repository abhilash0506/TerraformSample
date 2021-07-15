terraform {
  backend "s3" {
    bucket = "terraform-static-website-s3-abhilash115"
    encrypt = true
    region = "ap-south-1"
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_state" {
 bucket = "terraform-static-website-s3-abhilash115"
 tags = {
  Name="my-website-bucket"
}

policy =<<-EOF
{
  "Id": "BucketPolicy",
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Sid": "AllAccess",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
         "arn:aws:s3:::${var.my-bucket}",
         "arn:aws:s3:::${var.my-bucket}/*"
      ],
      "Principal": "*"
    }
  ]
}
EOF
website {
  index_document = "index.html"
  error_document = "error.html"
  }

 versioning {
 enabled = true
 }
}
resource "aws_s3_bucket_object" "upload-index-html" {
  bucket = var.my-bucket
  key = "index.html"
  content_type = "text/html"
  source = "index.html"
  depends_on = [aws_s3_bucket.terraform_state]
}
resource "aws_s3_bucket_object" "upload-error-html" {
  bucket = var.my-bucket
  key = "error.html"
  content_type = "text/html"
  source = "error.html"
  depends_on = [aws_s3_bucket.terraform_state]
}
 
resource "aws_instance" "NewServer" {
     ami           = "ami-011c99152163a87ae"
     instance_type = "t3.micro"

     tags = {
       Name = "Linux"
  }
}


resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}
