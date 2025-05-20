local k = import 'k.libsonnet';

{
  new():: {
    configMap: k.core.v1.configMap.new(
      'helmfile-plugin-config',
      {
        'plugin.yaml': std.manifestYamlDoc({
          apiVersion: 'argoproj.io/v1alpha1',
          kind: 'ConfigManagementPlugin',
          metadata: {
            name: 'helmfile-plugin',
          },
          spec: {
            version: 'v1.0',
            discover: {
              fileName: 'helmfile.yaml',
            },
            generate: {
              command: ['sh', '-c'],
              args: [
                |||
                  if [[ -v ENV_NAME ]]; then
                    helmfile -n "$ARGOCD_APP_NAMESPACE" -e $ENV_NAME template --include-crds -q
                  elif [[ -v ARGOCD_ENV_ENV_NAME ]]; then
                    helmfile -n "$ARGOCD_APP_NAMESPACE" -e "$ARGOCD_ENV_ENV_NAME" template --include-crds -q
                  else
                    helmfile -n "$ARGOCD_APP_NAMESPACE" template --include-crds -q
                  fi
              |||,
              ],
            },
          },
        }),
      }
    ),
  },
}
