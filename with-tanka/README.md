# Tanka / Jsonnet

https://tanka.dev/

This variation uses Grafana's Tanka config utility.  

+ It uses Jsonnet to express Kubernetes resources, which is natively supported by Argo CD\
+ `tk diff` allows to quickly see what changes could be applied
+ supports Helm!
+ built-in support for environment logical group
+ Used to deploy Grafana Cloud so can be considered production ready