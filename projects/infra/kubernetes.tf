provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

resource "kubernetes_storage_class" "nfs" {
  metadata {
    name = "filestore"
  }
  reclaim_policy      = "Retain"
  storage_provisioner = "nfs"
}

resource "kubernetes_persistent_volume" "efs_data" {
  metadata {
    name = "nfs-volume"
  }
  spec {
    capacity = {
      storage = "1T"
    }
    storage_class_name = kubernetes_storage_class.nfs.metadata[0].name
    access_modes       = ["ReadWriteMany"]
    persistent_volume_source {
      nfs {
        server = ""
        path   = ""
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "example" {
  metadata {
    name      = "litcoin-data"
    namespace = "litcoin"
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = kubernetes_storage_class.nfs.metadata[0].name
    volume_name        = kubernetes_persistent_volume.efs_data.metadata[0].name
    resources {
      requests = {
        storage = "1T"
      }
    }
  }
}


resource "kubernetes_csi_driver" "efs" {
  metadata {
    name = "efs.csi.aws.com"
  }

  spec {
    attach_required = false
    volume_lifecycle_modes = [
      "Persistent"
    ]
  }
}

resource "kubernetes_storage_class" "efs" {
  metadata {
    name = "efs-sc"
  }
  storage_provisioner = kubernetes_csi_driver.efs.metadata[0].name
  reclaim_policy      = "Retain"
}

resource "kubernetes_cluster_role_binding" "efs_pre" {
  metadata {
    name = "efs_role_pre"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "pre"
  }
}

resource "kubernetes_cluster_role_binding" "efs_live" {
  metadata {
    name = "efs_role_live"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "live"
  }
}