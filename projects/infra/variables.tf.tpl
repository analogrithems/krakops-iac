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
