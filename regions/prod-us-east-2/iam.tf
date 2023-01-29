data "aws_iam_policy_document" "ec2_assume" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_instance_profile" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  name = "aws-${var.region}-ec2-instance-role"
  inline_policy {
    name = "AmazonEC2ContainerRegistryFullAccess"
    policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ecr:*",
                    "cloudtrail:LookupEvents"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "iam:CreateServiceLinkedRole"
                ],
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "iam:AWSServiceName": [
                            "replication.ecr.amazonaws.com"
                        ]
                    }
                }
            }
        ]
    }
    )
  }


  inline_policy {
    name = "CloudWatchFullAccess"
    policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "autoscaling:Describe*",
                    "cloudwatch:*",
                    "logs:*",
                    "sns:*",
                    "iam:GetPolicy",
                    "iam:GetPolicyVersion",
                    "iam:GetRole",
                    "oam:ListSinks"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": "iam:CreateServiceLinkedRole",
                "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
                "Condition": {
                    "StringLike": {
                        "iam:AWSServiceName": "events.amazonaws.com"
                    }
                }
            },
            {
                "Effect": "Allow",
                "Action": [
                    "oam:ListAttachedLinks"
                ],
                "Resource": "arn:aws:oam:*:*:sink/*"
            }
        ]
    }
    )
  }



    inline_policy {
    name = "AmazonSSMManagedInstanceCore"
    policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ssm:DescribeAssociation",
                    "ssm:GetDeployablePatchSnapshotForInstance",
                    "ssm:GetDocument",
                    "ssm:DescribeDocument",
                    "ssm:GetManifest",
                    "ssm:GetParameter",
                    "ssm:GetParameters",
                    "ssm:ListAssociations",
                    "ssm:ListInstanceAssociations",
                    "ssm:PutInventory",
                    "ssm:PutComplianceItems",
                    "ssm:PutConfigurePackageResult",
                    "ssm:UpdateAssociationStatus",
                    "ssm:UpdateInstanceAssociationStatus",
                    "ssm:UpdateInstanceInformation"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ssmmessages:CreateControlChannel",
                    "ssmmessages:CreateDataChannel",
                    "ssmmessages:OpenControlChannel",
                    "ssmmessages:OpenDataChannel"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ec2messages:AcknowledgeMessage",
                    "ec2messages:DeleteMessage",
                    "ec2messages:FailMessage",
                    "ec2messages:GetEndpoint",
                    "ec2messages:GetMessages",
                    "ec2messages:SendReply"
                ],
                "Resource": "*"
            }
        ]
    }
    )
  }


    inline_policy {
    name = "AmazonSSMManagedInstanceCore"
    policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "cloudwatch:PutMetricData",
                    "ds:CreateComputer",
                    "ds:DescribeDirectories",
                    "ec2:DescribeInstanceStatus",
                    "logs:*",
                    "ssm:*",
                    "ec2messages:*"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": "iam:CreateServiceLinkedRole",
                "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
                "Condition": {
                    "StringLike": {
                        "iam:AWSServiceName": "ssm.amazonaws.com"
                    }
                }
            },
            {
                "Effect": "Allow",
                "Action": [
                    "iam:DeleteServiceLinkedRole",
                    "iam:GetServiceLinkedRoleDeletionStatus"
                ],
                "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ssmmessages:CreateControlChannel",
                    "ssmmessages:CreateDataChannel",
                    "ssmmessages:OpenControlChannel",
                    "ssmmessages:OpenDataChannel"
                ],
                "Resource": "*"
            }
        ]
    }
    )
  }


  }


resource "aws_iam_role_policy_attachment" "ssm_ec2" {
  role       = aws_iam_role.ec2_instance_profile.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

  depends_on = [
    aws_iam_role.ec2_instance_profile
  ]
}

resource "aws_iam_role" "elasticbeanstalk_role" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  name = "python-pre_aws_elasticbeanstalk_role"

  inline_policy {
    name = "AWSElasticBeanstalkWebTier"
    policy = jsonencode(
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "BucketAccess",
            "Action": [
              "s3:Get*",
              "s3:List*",
              "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:s3:::elasticbeanstalk-*",
              "arn:aws:s3:::elasticbeanstalk-*/*"
            ]
          },
          {
            "Sid": "XRayAccess",
            "Action": [
              "xray:PutTraceSegments",
              "xray:PutTelemetryRecords",
              "xray:GetSamplingRules",
              "xray:GetSamplingTargets",
              "xray:GetSamplingStatisticSummaries"
            ],
            "Effect": "Allow",
            "Resource": "*"
          },
          {
            "Sid": "CloudWatchLogsAccess",
            "Action": [
              "logs:PutLogEvents",
              "logs:CreateLogStream",
              "logs:DescribeLogStreams",
              "logs:DescribeLogGroups"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
            ]
          },
          {
            "Sid": "ElasticBeanstalkHealthAccess",
            "Action": [
              "elasticbeanstalk:PutInstanceStatistics"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:elasticbeanstalk:*:*:application/*",
              "arn:aws:elasticbeanstalk:*:*:environment/*"
            ]
          }
        ]
      }
    )
  }

  inline_policy {
    name = "AWSElasticBeanstalkMulticontainerDocker"
    policy = jsonencode(
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "ECSAccess",
            "Effect": "Allow",
            "Action": [
              "ecs:Poll",
              "ecs:StartTask",
              "ecs:StopTask",
              "ecs:DiscoverPollEndpoint",
              "ecs:StartTelemetrySession",
              "ecs:RegisterContainerInstance",
              "ecs:DeregisterContainerInstance",
              "ecs:DescribeContainerInstances",
              "ecs:Submit*",
              "ecs:DescribeTasks"
            ],
            "Resource": "*"
          }
        ]
      }
    )
  }

  inline_policy{
    name = "AWSElasticBeanstalkWorkerTier"
    policy = jsonencode(
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "MetricsAccess",
            "Action": [
              "cloudwatch:PutMetricData"
            ],
            "Effect": "Allow",
            "Resource": "*"
          },
          {
            "Sid": "XRayAccess",
            "Action": [
              "xray:PutTraceSegments",
              "xray:PutTelemetryRecords",
              "xray:GetSamplingRules",
              "xray:GetSamplingTargets",
              "xray:GetSamplingStatisticSummaries"
            ],
            "Effect": "Allow",
            "Resource": "*"
          },
          {
            "Sid": "QueueAccess",
            "Action": [
              "sqs:ChangeMessageVisibility",
              "sqs:DeleteMessage",
              "sqs:ReceiveMessage",
              "sqs:SendMessage"
            ],
            "Effect": "Allow",
            "Resource": "*"
          },
          {
            "Sid": "BucketAccess",
            "Action": [
              "s3:Get*",
              "s3:List*",
              "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:s3:::elasticbeanstalk-*",
              "arn:aws:s3:::elasticbeanstalk-*/*"
            ]
          },
          {
            "Sid": "DynamoPeriodicTasks",
            "Action": [
              "dynamodb:BatchGetItem",
              "dynamodb:BatchWriteItem",
              "dynamodb:DeleteItem",
              "dynamodb:GetItem",
              "dynamodb:PutItem",
              "dynamodb:Query",
              "dynamodb:Scan",
              "dynamodb:UpdateItem"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:dynamodb:*:*:table/*-stack-AWSEBWorkerCronLeaderRegistry*"
            ]
          },
          {
            "Sid": "CloudWatchLogsAccess",
            "Action": [
              "logs:PutLogEvents",
              "logs:CreateLogStream"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
            ]
          },
          {
            "Sid": "ElasticBeanstalkHealthAccess",
            "Action": [
              "elasticbeanstalk:PutInstanceStatistics"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:elasticbeanstalk:*:*:application/*",
              "arn:aws:elasticbeanstalk:*:*:environment/*"
            ]
          }
        ]
      }
    )
  }

  inline_policy {
    name = "SSMECRFullAccess"
    policy = jsonencode(
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "imagebuilder:GetComponent",
              "imagebuilder:GetContainerRecipe",
              "ecr:GetAuthorizationToken",
              "ecr:BatchGetImage",
              "ecr:InitiateLayerUpload",
              "ecr:UploadLayerPart",
              "ecr:CompleteLayerUpload",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:PutImage"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "kms:Decrypt"
            ],
            "Resource": "*",
            "Condition": {
              "ForAnyValue:StringEquals": {
                "kms:EncryptionContextKeys": "aws:imagebuilder:arn",
                "aws:CalledVia": [
                  "imagebuilder.amazonaws.com"
                ]
              }
            }
          },
          {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::ec2imagebuilder*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogStream",
              "logs:CreateLogGroup",
              "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/imagebuilder/*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "ssm:DescribeAssociation",
              "ssm:GetDeployablePatchSnapshotForInstance",
              "ssm:GetDocument",
              "ssm:DescribeDocument",
              "ssm:GetManifest",
              "ssm:GetParameters",
              "ssm:ListAssociations",
              "ssm:ListInstanceAssociations",
              "ssm:PutInventory",
              "ssm:PutComplianceItems",
              "ssm:PutConfigurePackageResult",
              "ssm:UpdateAssociationStatus",
              "ssm:UpdateInstanceAssociationStatus",
              "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "ssmmessages:CreateControlChannel",
              "ssmmessages:CreateDataChannel",
              "ssmmessages:OpenControlChannel",
              "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "ec2messages:AcknowledgeMessage",
              "ec2messages:DeleteMessage",
              "ec2messages:FailMessage",
              "ec2messages:GetEndpoint",
              "ec2messages:GetMessages",
              "ec2messages:SendReply"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "cloudwatch:PutMetricData"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "ec2:DescribeInstanceStatus"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "ds:CreateComputer",
              "ds:DescribeDirectories"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:DescribeLogGroups",
              "logs:DescribeLogStreams",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
              "s3:GetBucketLocation",
              "s3:PutObject",
              "s3:GetObject",
              "s3:GetEncryptionConfiguration",
              "s3:AbortMultipartUpload",
              "s3:ListMultipartUploadParts",
              "s3:ListBucket",
              "s3:ListBucketMultipartUploads"
            ],
            "Resource": "*"
          }
        ]
      }
    )
  }
}

resource "aws_iam_instance_profile" "elasticbeanstalk_instance_profile"  {
  name = "pythonpre-aws-elasticbeanstalk-ec2-instance-profile"
  role = aws_iam_role.elasticbeanstalk_role.name

  depends_on = [
    aws_iam_role.elasticbeanstalk_role
  ]
}