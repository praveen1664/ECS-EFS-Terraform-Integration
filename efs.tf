resource "aws_efs_file_system" "bitcoin" {
  tags = {
    Name = "ECS-EFS-FS"
  }
}

resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.bitcoin.id
  subnet_id      = aws_subnet.alpha.id
  /* tags = {
    Name = "ECS-EFS-MNT"
  } */
}
