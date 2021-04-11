# Global Configs
{% for key, value in config['global'].items() %}
variable "{{key}}" {
  default = {{value | jsonify}}
}
{% endfor %}

# State Configs
{% for key, value in config['state'].items() %}

variable "{{key}}" {
  default = "{{value}}"
}

{% endfor %}

variable "services" {
  type = map(string)

  default = {}
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "001518439974",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::001518439974:role/dev-role"
      username = "dev-role"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::001518439974:user/dev-user"
      username = "dev-user"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::001518439974:root"
      username = "root"
      groups   = ["system:masters"]
    }
  ]
}