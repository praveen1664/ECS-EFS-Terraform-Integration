/* resource "aws_ecs_cluster" "bitcoin" {
  name = "efs-bitcoin-example"
} */

/* resource "aws_ecs_service" "bitcoin_ecs_service" {
  name            = "efs-bitcoin-example-service"
  cluster         = aws_ecs_cluster.bitcoin.id
  task_definition = aws_ecs_task_definition.bitcoin-efs-task.arn
  desired_count   = 2
  launch_type     = "EC2"
  
  network_configuration {
    subnets = [aws_subnet.alpha.id]
  }
} */
/* 
resource "aws_ecs_task_definition" "bitcoin-efs-task" {
  family        = "efs-bitcoin-example-task"

  container_definitions = <<DEFINITION
[
  {
      "memory": 128,
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
} */