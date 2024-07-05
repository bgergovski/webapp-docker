resource "aws_appautoscaling_target" "webapp_target" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.webapp.name}/${aws_ecs_service.webapp.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "webapp_memory" {
  name               = "webapp-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.webapp_target.resource_id
  scalable_dimension = aws_appautoscaling_target.webapp_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.webapp_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "webapp_cpu" {
  name               = "webapp-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.webapp_target.resource_id
  scalable_dimension = aws_appautoscaling_target.webapp_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.webapp_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
