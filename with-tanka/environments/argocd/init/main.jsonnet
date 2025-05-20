local argocd = import 'argocd.libsonnet';
local k = import 'k.libsonnet';
local tankaSidecar = import 'tanka-sidecar.libsonnet';
local helmfileSidecar = import 'helmfile-sidecar.libsonnet';
local helmfilePlugin = import 'helmfile-plugin.libsonnet';
local tanka = import 'tanka.libsonnet';

local helm = tanka.helm.new(std.thisFile);
{
  local app = argocd.argoproj.v1alpha1.application,

  local namespace = 'argocd',
  namespace: k.core.v1.namespace.new(namespace),
  argocd: helm.template('argocd', './charts/argo-cd', {
    namespace: namespace,
    values: {
      configs: {
        params: {
          'server.insecure': true,
          'server.disable.auth': true,
        },
      },
      dex: {
        image: {
          repository: 'ghcr.io/dexidp/dex',
          tag: 'v2.41.1',
        },
      },
      redis: {
        image: {
          repository: 'redis',
          tag: '7.4.3',
        },
      },
      repoServer: {
        clusterAdminAccess: {
          enabled: true,
        },
        extraContainers: tankaSidecar.new().extraContainers + helmfileSidecar.new().extraContainers,
        volumes: tankaSidecar.new().volumes + helmfileSidecar.new().volumes,
      },
    },
  }) + {
      config_map_argocd_cm+: {
        data+:{
          'kustomize.buildOptions': '--enable-helm --load-restrictor LoadRestrictionsNone',
        },
      },
  },
  helmfilePluginConfigMap: helmfilePlugin.new(),
  rootApp: app.new('root')
           + app.metadata.withNamespace(namespace)
           + app.spec.withProject('default')
           + app.spec.source.withRepoURL('https://github.com/yohanb/charts-refactor')
           + app.spec.source.withPath('with-tanka')
           + app.spec.source.withTargetRevision('HEAD')
           + app.spec.source.plugin.withEnv([
             { name: 'TK_ENV', value: 'root-tanka' },
             { name: 'EXTRA_ARGS', value: '--log-level debug' },
           ])
           + app.spec.destination.withNamespace(namespace)
           + app.spec.destination.withServer('https://kubernetes.default.svc'),
}
