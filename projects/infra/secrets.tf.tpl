{% for lane in secrets %}


    {% for service in secrets[lane] %}
        {% for secret_key, secret_value in secrets[lane][service].items() %}

# Swimlane: {{lane}}, Service: {{service}}, SecretName: {{secret_key}}
resource "aws_ssm_parameter" "{{lane}}_{{service}}_{{secret_key}}" {
  name      = "/${var.vpc_name}/{{lane}}/{{service}}/{{service}}/v1/{{secret_key}}"
  overwrite = true
  type      = "SecureString"
  value     = {{secret_value |jsonify}}

  tags = merge(
    local.common_tags,
    {
      "client_name"  = "{{lane}}"
      "cluster_name"  = "${var.vpc_name}-{{lane}}"
      "Name"    = "{{secret_key}}"
      "Service" = "{{service}}"
    },
  )
}


        {% endfor %}
    {% endfor %}
{% endfor %}

