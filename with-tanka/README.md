# Tanka / Jsonnet

https://tanka.dev/

This variation uses Grafana's Tanka config utility.  

+ `tk diff` allows to quickly see what changes could be applied
+ supports Helm
+ built-in support for environment logical group
+ Used to deploy Grafana Cloud so can be considered production ready
+ pretty much a fully fledged programming language
+ can be used to generate JSON for other platforms (ex Terraform)

- needs a CMP to wort in Argo CD
- learning curve
- can become messy

? helm templating is done on CI/CD agent so no OCI creds in ArgoCD