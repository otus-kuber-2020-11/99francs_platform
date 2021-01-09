local env = {
  name: std.extVar('qbec.io/env'),
  namespace: std.extVar('qbec.io/defaultNs'),
};
local p = import '../params.libsonnet';
local params = p.components.common;

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      labels: { app: params.name },
      name: params.name,
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: params.name,
        },
      },
      template: {
        metadata: {
          labels: { app: params.name },
        },
        spec: {
          terminationGracePeriodSeconds: 5,
          containers: [
            {
              name: 'server',
              image: params.image,
              env: [{
                 name: "PORT",
                 value: "9555"
              }],
              resources: {
                limits: {
                  cpu: "300m",
                  memory: "300Mi"
                },
                requests: {
                  cpu: "200m",
                  memory: "180Mi"
                }

              },
              ports: [
                {
                  containerPort: params.containerPort,
                },
              ],
            },
          ],
          nodeSelector: params.nodeSelector,
          tolerations: params.tolerations,
          imagePullSecrets: [{ name: 'regsecret' }],

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
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      labels: { app: params.name },
      name: params.name,
    },
    spec: {
      selector: {
        app: params.name,
      },
      ports: [
        {
          port: params.servicePort,
          targetPort: params.containerPort,
        },
      ],
    },
  }
]
