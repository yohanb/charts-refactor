local argocd = import 'argocd.libsonnet';
local plugin = import 'tanka-plugin.libsonnet';
local sidecar = import 'tanka-sidecar.libsonnet';

{
  local app = argocd.argoproj.v1alpha1.application,
  local appProject = argocd.argoproj.v1alpha1.appProject,

  local namespace = 'argocd',
  local pluginDir = '/home/argocd/cmp-server/plugins',
  local tankaVersion = 'v0.32.0',
  local bundlerVersion = 'v0.5.1',

  helmApp: app.new('argocd')
           + app.metadata.withNamespace(namespace)
           + app.spec.withProject(self.project.metadata.name)
           + app.spec.destination.withNamespace(namespace)
           + app.spec.destination.withServer('https://kubernetes.default.svc')
           + app.spec.source.withRepoURL('https://argoproj.github.io/argo-helm')
           + app.spec.source.withChart('argo-cd')
           + app.spec.source.withTargetRevision('8.0.6')
           + app.spec.source.helm.withReleaseName('argocd')
           + app.spec.source.helm.withValues(
             std.manifestYamlDoc({
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
               } + sidecar.new(pluginDir, bundlerVersion, tankaVersion, 'v3.14.3'),
             }),
           ),

  rootApp: app.new('root')
           + app.metadata.withNamespace(namespace)
           + app.spec.withProject(self.project.metadata.name)
           + app.spec.source.withRepoURL('https://github.com/yohanb/charts-refactor')
           + app.spec.source.withPath('with-tanka')
           + app.spec.source.withTargetRevision('HEAD')
           + app.spec.source.plugin.withEnv([
             { name: 'TK_ENV', value: 'root' },
           ])
           + app.spec.destination.withNamespace(namespace)
           + app.spec.destination.withServer('https://kubernetes.default.svc'),

  project: appProject.new('argocd')
           + appProject.metadata.withNamespace('argocd')
           + appProject.metadata.withFinalizers(['resources-finalizer.argocd.argoproj.io'])
           + appProject.spec.withSourceRepos(['*'])
           + appProject.spec.withClusterResourceWhitelist([{ group: '*', kind: '*' }])
           + appProject.spec.withDestinations([{ namespace: '*', server: '*' }]),
}
