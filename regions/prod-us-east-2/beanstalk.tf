#Python Flask App Application
 resource "aws_elastic_beanstalk_application" "python_flask_app" {
  name        = "Python-FLask-App"
  description = "Python Flask App Application"
 }

#Python Flask App Beanstalk
 resource "aws_elastic_beanstalk_environment" "python_flask_app" {
    name = "Python-FLask-API"
    application = aws_elastic_beanstalk_application.python_flask_app.name
    solution_stack_name = "64bit Amazon Linux 2 v3.5.3 running Docker"
    tier = "WebServer"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.vpc_main.id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.elasticbeanstalk_instance_profile.name
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = false
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", [ aws_subnet.main_private_a.id, aws_subnet.main_private_b.id ])
  }

 setting {
     namespace = "aws:elasticbeanstalk:environment"
     name = "EnvironmentType"
     value = "LoadBalanced"
   }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }
   setting  {
     namespace = "aws:elbv2:loadbalancer"
     name      = "ManagedSecurityGroup"
     value     = aws_security_group.python_flask_app_beanstalk_alb.id
   }

   setting  {
     namespace = "aws:elbv2:loadbalancer"
     name      = "SecurityGroups"
     value     = aws_security_group.python_flask_app_beanstalk_alb.id
   }

   setting{
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", [ aws_subnet.main_public_a.id, aws_subnet.main_public_b.id ])
  } 

   setting {
     namespace = "aws:autoscaling:launchconfiguration"
     name      = "SecurityGroups"
     value     = aws_security_group.python_flask_app_beanstalk.id
   }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.python_flask_app_size
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 1
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
   setting {
     namespace = "aws:elasticbeanstalk:command"
     name      = "IgnoreHealthCheck"
     value     = true
   }

   setting {
     namespace = "aws:autoscaling:trigger"
     name      = "MeasureName"
     value     = "CPUUtilization"
   }
   setting {
     namespace = "aws:autoscaling:trigger"
     name      = "Statistic"
     value     = "Average"
   }
   setting {
     namespace = "aws:autoscaling:trigger"
     name      = "Unit"
     value     = "Percent"
   }

   setting {
     namespace = "aws:autoscaling:trigger"
     name      = "LowerThreshold"
     value     = 20
   }

   setting {
     namespace = "aws:autoscaling:trigger"
     name      = "LowerBreachScaleIncrement"
     value     = -1
   }

   setting {
     namespace = "aws:autoscaling:trigger"
     name      = "UpperThreshold"
     value     = 80
   }

   setting {
     namespace = "aws:autoscaling:trigger"
     name      = "UpperBreachScaleIncrement"
     value     = 1
   }

   setting {
     namespace = "aws:elasticbeanstalk:cloudwatch:logs"
     name      = "StreamLogs"
     value     = true
   }
   setting { 
     name = "ConfigDocument"
     namespace = "aws:elasticbeanstalk:healthreporting:system"
     value = "{\"Version\":1,\"Rules\":{\"Environment\":{\"ELB\":{\"ELBRequests4xx\":{\"Enabled\":false}},\"Application\":{\"ApplicationRequests4xx\":{\"Enabled\":false}}}}}"
   }

   setting{
       namespace = "aws:elasticbeanstalk:application:environment"
       name      = "DATABASE_URL"
       value     = "postgres://${var.postgres_db_username}:${random_password.db_pass.result}@${aws_db_instance.postgresdb.endpoint}:5432/postgres"
   }
   depends_on = [
     aws_iam_role.elasticbeanstalk_role,
     aws_security_group.python_flask_app_beanstalk_alb
     ]
 }
