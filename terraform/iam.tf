data "aws_iam_policy_document" "webapp_ecs_generic" {
  statement {
    sid = "AllowAccessToECRandLogs"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "events:DescribeRule",
      "events:ListTargetsByRule",
      "logs:DescribeLogGroups"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    sid = "AllowLBActions"

    effect = "Allow"

    actions = [
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]

    resources = [
      aws_lb.webapp_elb.arn
    ]
  }
}

data "aws_iam_policy_document" "webapp_ecs_service_scaling" {

  statement {
    effect = "Allow"

    actions = [
      "application-autoscaling:*",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "iam:CreateServiceLinkedRole",
      "sns:CreateTopic",
      "sns:Subscribe",
      "sns:Get*",
      "sns:List*"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "webapp_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ecs:${var.aws_region}:${local.account_id}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${local.account_id}"]
    }

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_policy" "webapp_generic_policy" {
  name        = "webapp-ecs-generic-policy"
  description = "Policy to ECR and Cloudwatch."
  policy      = data.aws_iam_policy_document.webapp_ecs_generic.json
  tags        = merge(local.tags)
}

resource "aws_iam_policy" "webapp_scale_policy" {
  name        = "webapp-ecs-scale-policy"
  description = "Policy for the ECS auto-scaling."
  policy      = data.aws_iam_policy_document.webapp_ecs_service_scaling.json
  tags        = merge(local.tags)
}


resource "aws_iam_role" "webapp_ecs" {
  assume_role_policy = data.aws_iam_policy_document.webapp_assume_role_policy.json
  name               = "webapp-docker-ecs-role"
  tags               = merge(local.tags)
}


resource "aws_iam_role_policy_attachment" "webapp_generic" {
  policy_arn = aws_iam_policy.webapp_generic_policy.arn
  role       = aws_iam_role.webapp_ecs.name
}

resource "aws_iam_role_policy_attachment" "webapp_scale" {
  policy_arn = aws_iam_policy.webapp_scale_policy.arn
  role       = aws_iam_role.webapp_ecs.name
}