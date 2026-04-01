resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.19.2"
  namespace  = "kube-system"

  set = [
    {
      name  = "kubeProxyReplacement"
      value = "true"
    },
    {
      name  = "hubble.relay.enabled"
      value = "true"
    },
    {
      name  = "hubble.ui.enabled"
      value = "true"
    }
  ]
}