local k = import 'k.libsonnet';

local volume = k.core.v1.volume;
local volumeMount = k.core.v1.volumeMount;
local container = k.core.v1.container;

{
  new():: {

    extraContainers: [
      container.withName('helmfile-cmp') +
      container.withImage('ghcr.io/helmfile/helmfile') +
      container.withCommand('/var/run/argocd/argocd-cmp-server') +
      container.securityContext.withRunAsUser(999) +
      container.withEnv([
        { name: 'HELM_CACHE_HOME', value: '/tmp/helm/cache' },
        { name: 'HELM_CONFIG_HOME', value: '/tmp/helm/config' },
        { name: 'HELMFILE_CACHE_HOME', value: '/tmp/helmfile/cache' },
        { name: 'HELMFILE_TEMPDIR', value: '/tmp/helmfile/tmp' },
      ]) +
      container.withVolumeMounts([
        volumeMount.withName('var-files') +
        volumeMount.withMountPath('/var/run/argocd'),
        volumeMount.withName('plugins') +
        volumeMount.withMountPath('/home/argocd/cmp-server/plugins'),
        volumeMount.withName('plugin-config') +
        volumeMount.withMountPath('/home/argocd/cmp-server/config/plugin.yaml') +
        volumeMount.withSubPath('plugin.yaml'),
        volumeMount.withName('cmp-tmp') +
        volumeMount.withMountPath('/tmp'),
      ]),
    ],
    volumes: [
      volume.withName('plugin-config') +
      volume.configMap.withName('helmfile-plugin-config'),
      volume.withName('cmp-tmp') +
      volume.emptyDir.withSizeLimit('500Mi'),
    ],
  },
}
