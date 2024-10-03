data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "nest-ecs-tfstate-bucket"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
