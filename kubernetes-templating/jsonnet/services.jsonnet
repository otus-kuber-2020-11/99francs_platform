local kube = import "https://raw.githubusercontent.com/bitnami-labs/kube-libsonnet/v1.14.1/kube.libsonnet";
local common(name) = {

  service: kube.Service(name) {
    target_pod:: $.deployment.spec.template,
  },

  deployment: kube.Deployment(name) {
    spec+: {
      template+: {
        spec+: {
          containers_: {
            common: kube.Container("common") {
              env: [{name: "PORT", value: "50051"}],
              ports: [{containerPort: 50051}],
              securityContext: {
                readOnlyRootFilesystem: true,
                runAsNonRoot: true,
                runAsUser: 10001,
              },
              readinessProbe: {
                  initialDelaySeconds: 20,
                  periodSeconds: 15,
                  exec: {
                      command: [
                          "/bin/grpc_health_probe",
                          "-addr=:50051",
                      ],
                  },
              },
              livenessProbe: {
                  initialDelaySeconds: 20,
                  periodSeconds: 15,
                  exec: {
                      command: [
                          "/bin/grpc_health_probe",
                          "-addr=:50051",
                      ],
                  },
              },
            },
          },
        },
      },
    },
  },
};

{
  paymentservice: common("paymentservice") {
    deployment+:  {
      spec+: {
        template+: {
          spec+: {
            containers_+: {
              common+: {
                name: "paymentservice",
                image: "gcr.io/google-samples/microservices-demo/paymentservice:v0.1.3"
              }
            }
          }
        }
      }
    }
  },
  shippingservice: common("shippingservice") {
    deployment+: {
      spec+: {
        template+: {
          spec+: {
            containers_+: {
              common+: {
                name: "shippingservice",
                image: "gcr.io/google-samples/microservices-demo/shippingservice:v0.1.3"
              }
            }
          }
        }
      }
    }
  }
}