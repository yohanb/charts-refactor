local k = import "k.libsonnet";
local tanka = import "tanka.libsonnet";

local helm = tanka.helm.new(std.thisFile);
{
    local namespace = "tanka-keda",
    namespace: k.core.v1.namespace.new(namespace),
    keda: helm.template("keda", "./charts/keda", { 
        namespace: namespace,
    }),
}
