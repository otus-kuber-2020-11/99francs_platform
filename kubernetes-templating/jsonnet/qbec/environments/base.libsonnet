{
  components: {
    common: {
      name: 'adservice',
      image: 'gcr.io/google-samples/microservices-demo/adservice:v0.1.3',
      replicas: 1,
      containerPort: 9555,
      servicePort: 9555,
      nodeSelector: {},
      tolerations: [],
    },
  },
}