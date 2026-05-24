resource "aws_ecs_cluster" "demo_cluster" {
  name = "demo-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

//IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ecs_task_execution_role"
  }
}

//IAM Policy for ECS Task Execution
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["ecs:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

//Task Definition
resource "aws_ecs_task_definition" "demo_task" {
  family                   = "demo-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "demo-nginx-container"
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name = "demo_task"
  }
}

//ECS Service
resource "aws_ecs_service" "demo_service" {
  name            = "demo-service"
  cluster         = aws_ecs_cluster.demo_cluster.id
  task_definition = aws_ecs_task_definition.demo_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [for s in aws_subnet.private_subnets : s.id]
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.demo_target_group.arn
    container_name   = "demo-nginx-container"
    container_port   = 80
  }

}