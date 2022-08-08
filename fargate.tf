
resource "aws_ecs_cluster" "bitcoin" {
  name = "efs-bitcoin-example"
}

resource "aws_security_group" "allow_all_a" {
  name        = "sgfargate"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.bitcoin.id

  ingress {
    protocol    = "6"
    from_port   = 80
    to_port     = 8000
    cidr_blocks = [aws_vpc.bitcoin.cidr_block]
  }
}

resource "aws_ecs_service" "bitcoin_ecs_service" {
  name             = "efs-bitcoin-example-service"
  cluster          = aws_ecs_cluster.bitcoin.id
  task_definition  = aws_ecs_task_definition.bitcoin-efs-task.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "1.4.0" //not specfying this version explictly will not currently work for mounting EFS to Fargate
  
  network_configuration {
    security_groups  = [aws_security_group.allow_all_a.id]
    subnets          = [aws_subnet.alpha.id]
    assign_public_ip = false
  }
}

resource "aws_ecs_task_definition" "bitcoin-efs-task" {
  family                   = "efs-bitcoin-example-task-fargate"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode = "awsvpc"

  container_definitions = <<DEFINITION
[
  {
      "memory": 128,
      "cpu": 10,
      "portMappings": [
          {
              "hostPort": 80,
              "containerPort": 80,
              "protocol": "tcp"
          }
      ],
      "essential": true,
      "mountPoints": [
          {
              "containerPath": "/usr/share/nginx/html",
              "sourceVolume": "efs-data"
          }
      ],
      "name": "nginx",
      "image": "nginx"
  }
]
DEFINITION

  volume {
    name      = "efs-data"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.bitcoin.id
      root_directory = "/path/to/my/data"
    }
  }
}