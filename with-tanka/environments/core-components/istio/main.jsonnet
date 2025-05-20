local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  local namespace = 'tanka-istio',
  namespace: k.core.v1.namespace.new(namespace),
  base: helm.template('base', './charts/base', {
    namespace: namespace,
    values: {
      global: {
        istioNamespace: namespace,
      },
    },
  }),

  istiod: helm.template('base', './charts/istiod', {
    namespace: namespace,
    values: {
      global: {
        istioNamespace: namespace,
      },
    },
  }),
}
