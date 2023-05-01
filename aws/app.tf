provider "aws" {
  region = "ap-southeast-1"
}

# Create public and private subnets in the default VPC
resource "aws_subnet" "public1" {
  vpc_id     = "vpc-07ec720b71abaa8db"
  cidr_block = "10.0.2.0/28"
  availability_zone = "ap-southeast-1a"
}

resource "aws_subnet" "public2" {
  vpc_id     = "vpc-07ec720b71abaa8db"
  cidr_block = "10.0.3.0/28"
  availability_zone = "ap-southeast-1b"
}

resource "aws_subnet" "private" {
  vpc_id     = "vpc-07ec720b71abaa8db"
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1b"
}

resource "aws_subnet" "private1" {
  vpc_id     = "vpc-07ec720b71abaa8db"
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-1a"
}

# Create an application load balancer in the public subnet
resource "aws_lb" "example" {
  name               = "example-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

  tags = {
    Environment = "dev"
  }


}


# calling from iam.tf
##data "aws_iam_role" "ec2_s3_access_role" {
##  name = "ecsaccessrole"
##}

#creating iam instance profile
resource "aws_iam_instance_profile" "ecs_access_role_profile" {
  name = "ecsaccessrole"
  role = aws_iam_role.ec2_s3_access_role.name
}


# Create an Auto Scaling Group with nginx installed in the private subnet
resource "aws_launch_template" "web" {
  image_id = "ami-0cc5068cb89c82f5e"
  instance_type = "t2.micro"
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo aws s3 cp s3://mys3bucksg/index.html .
              sudo aws s3 cp s3://mys3bucksg/counter.js .
              sudo aws s3 cp s3://mys3bucksg/counter.css .
              sudo mv /usr/share/nginx/html/index.html /var/tmp/
              sudo mv index.html /usr/share/nginx/html/
              sudo mv counter.js /usr/share/nginx/html/
              sudo mv counter.css /usr/share/nginx/html/
              sudo service nginx stop
              sudo service nginx start
              EOF
	      )
 iam_instance_profile {
    name = aws_iam_instance_profile.ecs_access_role_profile.name
    #name = "ecsaccessrole"
  }

}

resource "aws_autoscaling_group" "web" {
  desired_capacity     = 3
  max_size             = 3
  min_size             = 3
  #vpc_zone_identifier  = [aws_subnet.public1.id,aws_subnet.public2.id]
  vpc_zone_identifier  = [aws_subnet.private1.id,aws_subnet.private.id]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.web.id
        version            = "$Latest"
      }
      override {
        instance_type = "t2.micro"
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

  target_group_arns    = [aws_alb_target_group.example.arn]
}

# Configure the ALB to forward traffic to the Auto Scaling Group
resource "aws_alb_target_group" "example" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-07ec720b71abaa8db"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/"
  }
}

resource "aws_alb_listener" "example" {
  load_balancer_arn = "${aws_lb.example.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.example.arn}"
    type             = "forward"
  }
}

# Create an IAM policy that allows access to the S3 bucket
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::mys3bucksg",
          "arn:aws:s3:::mys3bucksg/*"
        ]
      }
    ]
  })
}

# Create an IAM role and attach the policy to it
resource "aws_iam_role" "ec2_s3_access_role" {
  name = "ecsaccessrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

}


resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.ec2_s3_access_role.name
}
