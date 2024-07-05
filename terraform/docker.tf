resource "docker_image" "webapp" {
  name = "${aws_ecr_repository.webapp.repository_url}:${var.docker_tag}"
  build {
    context    = "../."
    dockerfile = "../Dockerfile"

  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "../src/*") : filesha1(f)]))
  }
}

resource "docker_registry_image" "webapp" {
  name          = docker_image.webapp.name
  keep_remotely = true
}