provider "kubernetes" {
  config_context = "minikube"
}

resource "kubernetes_deployment" "tomcat" {
  metadata {
    name = "tomcat"
    namespace = "a2"
    labels {
      name = "tomcat"
    }
  }

  spec {
    replicas = 1
    
    selector {
      match_labels {
        name = "tomcat"
      }
    }  

    template {
      metadata {
        labels {
          name = "tomcat"
        }
      }

      spec {
        container {
          image = "tomcat:8.5-a2"
          name = "tomcat"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "tomcat" {
  metadata {
    name = "tomcat-service"
    namespace = "a2"
  }
  spec {
    selector {
      name = "${kubernetes_deployment.tomcat.metadata.0.labels.name}"
    }
    port {
      port = 8090
      target_port = 8080
    }

    type = "NodePort"
  }
}

# nginx resources
resource "kubernetes_deployment" "apache" {
  metadata {
    name = "apache"
    namespace = "a2"
    labels {
      name = "apache"
    }
  }

  spec {
  	replicas = 3
    selector {
      match_labels {
        name = "apache"
      }
    }  

    template {
      metadata {
        labels {
          name = "apache"
        }
      }

      spec {
        container {
          image = "apache:a2"
          name = "apache"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "apache" {
  metadata {
    name = "apache-service"
    namespace = "a2"
  }
  spec {
    selector {
      name = "${kubernetes_deployment.apache.metadata.0.labels.name}"
    }
    port {
      port = 8080
      target_port = 80
    }

    type = "NodePort"
  }
}