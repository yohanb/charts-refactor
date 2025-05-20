local argocd = import 'argocd.libsonnet';

local appSet = argocd.argoproj.v1alpha1.applicationSet;

{
  coreComponents:
    appSet.new('tanka-core-components') +
    appSet.metadata.withNamespace('argocd') +
    appSet.spec.withGoTemplate(true) +
    appSet.spec.withGoTemplateOptions(['missingkey=error']) +
    appSet.spec.withGenerators([
      appSet.spec.generators.git.withRepoURL('https://github.com/yohanb/charts-refactor') +
      appSet.spec.generators.git.withRevision('HEAD') +
      appSet.spec.generators.git.withFiles([
        appSet.spec.generators.git.files.withPath('with-tanka/environments/core-components/**/spec.json'),
      ]),
    ]) +
    appSet.spec.template.metadata.withName('tanka-{{.path.basename}}') +
    appSet.spec.template.spec.withProject('{{.data.argocd.app.project}}') +
    appSet.spec.template.spec.source.withRepoURL('https://github.com/yohanb/charts-refactor') +
    appSet.spec.template.spec.source.withPath('with-tanka') +
    appSet.spec.template.spec.source.withTargetRevision('{{.data.argocd.app.source.targetRevision}}') +
    appSet.spec.template.spec.source.plugin.withEnv([
      { name: 'TK_ENV', value: '{{.path.path | replace "with-tanka/environments/" ""}}' },
      { name: 'EXTRA_ARGS', value: '--log-level debug' },
    ]) +
    appSet.spec.template.spec.destination.withServer('{{.data.argocd.app.destination.server}}') +
    appSet.spec.template.spec.destination.withNamespace('{{.spec.namespace}}') +
    appSet.spec.template.spec.withIgnoreDifferences(
      appSet.spec.template.spec.ignoreDifferences.withGroup('admissionregistration.k8s.io') +
      appSet.spec.template.spec.ignoreDifferences.withKind('ValidatingWebhookConfiguration') +
      appSet.spec.template.spec.ignoreDifferences.withJqPathExpressions('.webhooks[].failurePolicy'),
    ) +
    {
      spec+: {
        template+: {
          spec+: {
            syncPolicy+: {
              syncOptions: ['ServerSideApply=true'],
            },
          },
        },
      },
    },
}
