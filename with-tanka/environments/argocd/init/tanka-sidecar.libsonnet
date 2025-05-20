local k = import 'k.libsonnet';

local volume = k.core.v1.volume;
local volumeMount = k.core.v1.volumeMount;
local container = k.core.v1.container;


{
  new():: {

    extraContainers: [
      container.withName('tanka-cmp') +
      container.withImage('ybelval/argocd-tanka-plugin') +
      container.securityContext.withRunAsUser(999) +
      container.withVolumeMounts([
        volumeMount.withName('var-files') +
        volumeMount.withMountPath('/var/run/argocd'),
        volumeMount.withName('plugins') +
        volumeMount.withMountPath('/home/argocd/cmp-server/plugins'),
        volumeMount.withName('cmp-tmp') +
        volumeMount.withMountPath('/tmp'),
      ]),
    ],
    volumes: [
      volume.withName('cmp-tmp') +
      volume.emptyDir.withSizeLimit('500Mi'),
    ],
  },
}
