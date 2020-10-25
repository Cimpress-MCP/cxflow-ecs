data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-production-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#resource "aws_iam_role" "ecs_task_role" {
#  name               = "role-name-task"
#  description        = "SSM rights for ECS"
#  assume_role_policy = <<EOF
#{
# "Version": "2012-10-17",
# "Statement": [
#   {
#     "Action": "sts:AssumeRole",
#     "Principal": {
#       "Service": "ecs-tasks.amazonaws.com"
#     },
#     "Effect": "Allow",
#     "Sid": ""
#   }
# ]
#}
#EOF
#}

#resource "aws_iam_policy" "ecs-ssm-policy" {
#  name = "ecs-ssm-policy"
#
#  policy = file("ssm-policy.json")
#}

#resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
#  role       = aws_iam_role.ecs_task_execution_role.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#}

#resource "aws_iam_role_policy_attachment" "ecs_task_role-policy-attachment" {
#  role       = aws_iam_role.ecs_task_role.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#}

#resource "aws_iam_role_policy_attachment" "xxx_nodes_role_policy_attachment" {
#  role       = aws_iam_role.ecs-ssm-policy1.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#}
