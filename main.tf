module "target" {
  source          = "StayWell/alb-target/aws"
  version         = "0.1.1"
  env             = "${var.env}"
  tags            = "${var.tags}"
  vpc_id          = "${var.vpc_id}"
  listener_arn    = "${var.listener_arn}"
  lb_dns_name     = "${var.lb_dns_name}"
  lb_zone_id      = "${var.lb_zone_id}"
  host            = "${var.name}"
  port            = "${var.container_port}"
  domain          = "${var.domain}"
  route53_zone_id = "${var.route53_zone_id}"
  matcher         = "${var.matcher}"
}

data "template_file" "this" {
  template = "${file("${path.module}/templates/container.json.tpl")}"

  vars {
    name      = "${var.name}"
    image     = "${var.image}"
    port      = "${var.container_port}"
    region    = "${var.region}"
    log_path  = "${var.name}"
    log_group = "${aws_cloudwatch_log_group.this.name}"

    env_vars = "${
      jsonencode(
        concat(
          list(
            map("name", "HTTP_X_FORWARDED_PROTO", "value", "https"),
            map("name", "WORDPRESS_DB_NAME", "value", "${var.name}"),
            map("name", "WORDPRESS_DB_HOST", "value", "${var.db_host}"),
            map("name", "WORDPRESS_DB_USER", "value", "${var.db_user}"),
            map("name", "WORDPRESS_DB_PASSWORD", "value", "${var.db_password}")
          )
        )
      )
    }"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.env}-${var.name}"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  container_definitions    = "${data.template_file.this.rendered}"
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"
  tags                     = "${var.tags}"

  volume {
    name      = "wp-content"
    host_path = "${var.wp_data_host_path}"
  }
}

resource "aws_ecs_service" "this" {
  name            = "${var.name}"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.this.arn}"
  desired_count   = "${var.desired_count}"
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = "${module.target.target_group_arn}"
    container_name   = "${var.name}"
    container_port   = "${var.container_port}"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.env}-${var.name}"
  tags = "${var.tags}"
}

resource "aws_lb_target_group" "this" {
  name        = "${var.env}-${var.name}"
  port        = "${var.container_port}"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"

  health_check {
    path = "/"
  }

  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
}
