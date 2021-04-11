/**
 * example of using statefulset with efs with static provisioning
 * https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/examples/kubernetes/statefulset/specs/example.yaml
 */
 
resource "kubernetes_storage_class" "ebs" {
  metadata {
    name = local.storage_class_name
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
}

resource "kubernetes_stateful_set" "litecoin-node" {
  metadata {
    annotations = {
      SomeAnnotation = local.app
    }

    labels = {
      k8s-app                           = local.app
      "kubernetes.io/cluster-service"   = "true"
      "addonmanager.kubernetes.io/mode" = "Reconcile"
      version                           = "v2.2.1"
    }

    name = local.app
  }

  spec {
    pod_management_policy  = "Parallel"
    replicas               = 1
    revision_history_limit = 5

    selector {
      match_labels = {
        k8s-app = local.app
      }
    }

    service_name = local.app

    template {
      metadata {
        labels = {
          k8s-app = local.app
        }

        annotations = {}
      }

      spec {
        service_account_name = local.app

        init_container {
          name              = "init-chown-data"
          image             = "busybox:latest"
          image_pull_policy = "IfNotPresent"
          command           = ["chown", "-R", "1010:1010", "/litecoin"]

          volume_mount {
            name       = "${local.app}-data"
            mount_path = "/litecoin"
            sub_path   = ""
          }
        }


        container {
          name              = "litecoin-node-server"
          image             = "001518439974.dkr.ecr.us-west-1.amazonaws.com/litecoin:devops"
          image_pull_policy = "Always"

          port {
            container_port = 9333
          }

          port {
            container_port = 9332
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "1000Mi"
            }

            requests = {
              cpu    = "200m"
              memory = "1000Mi"
            }
          }

          volume_mount {
            name       = "litecoin-node-data"
            mount_path = "/litecoin"
            sub_path   = ""
          }

          readiness_probe {
            tcp_socket {
              port = 9333
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }

          liveness_probe {
            tcp_socket {
              port = 9333
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }
        }

        termination_grace_period_seconds = 300
      }
    }

    update_strategy {
      type = "RollingUpdate"

      rolling_update {
        partition = 1
      }
    }

    volume_claim_template {
      metadata {
        name = "litecoin-node-data"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "standard"

        resources {
          requests = {
            storage = "60Gi"
          }
        }
      }
    }
  }
}