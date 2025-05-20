# Kustomize

https://kubectl.docs.kubernetes.io/

+ natively supported with kubectl and ArgoCD
+ easy to understand since it's native k8s yaml
+ supports helm

- can become tricky for more complicated use cases. Best to copy/paste in some cases to avoid unnecessary complexity
- documentation kinda sucks

? helm templating is done on CI/CD agent so no OCI creds in ArgoCD