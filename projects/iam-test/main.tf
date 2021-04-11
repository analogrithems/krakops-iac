resource "aws_iam_role" "no_access" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  name = local.role_name

  tags = {
    name = "no-permissions"
  }
}


resource "aws_iam_policy" "group_assume_policy" {
  name        = local.policy_name
  path        = "/"
  description = "This policy will allow you to assume the no-access role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AssumeNoAccess",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "${aws_iam_role.no_access.arn}"
            ]
        },
        {
            "Sid": "ListRoles",
            "Effect": "Allow",
            "Action": [
				"iam:ListRoles"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_group_policy_attachment" "no_access" {
  group      = aws_iam_group.no_access_group.name
  policy_arn = aws_iam_policy.group_assume_policy.arn
}

resource "aws_iam_group" "no_access_group" {
  name = local.group_name
}

resource "aws_iam_group_membership" "no_access_group" {
  name = "no-access-group-membership"

  users = [
    aws_iam_user.example_user.name,
  ]

  group = aws_iam_group.no_access_group.name
}

resource "aws_iam_user" "example_user" {
  name = local.user_name
}