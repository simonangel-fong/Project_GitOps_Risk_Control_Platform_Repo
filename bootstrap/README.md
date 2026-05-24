
```sh
aws eks update-kubeconfig --region ca-central-1 --name gitops-demo-dev

kubectl port-forward svc/argocd-server 8000:80 -n argocd

kubectl port-forward svc/argo-rollouts-dashboard 3100:3100 -n argo-rollouts

k get secret argocd-initial-admin-secret -n argocd -o yaml

echo "" | base64 -d

argocd app sync argocd/00-app-of-apps

```

- envoy

```sh
argocd repo add docker.io/envoyproxy --type helm --name envoyproxy --enable-oci


helm install eg oci://docker.io/envoyproxy/gateway-helm --version v1.8.0 -n envoy-gateway-system --create-namespace

kubectl wait --timeout=5m -n envoy-gateway-system deployment/envoy-gateway --for=condition=Available


kubectl patch gatewayclass eg \
  --type=json \
  -p='[{"op":"remove","path":"/metadata/finalizers"}]'

kubectl patch gatewayclass eg \
  --type=json \
  -p='[{"op":"remove","path":"/metadata/finalizers"}]'
```

```sh
curl -v -H "Host: gitops-dev.arguswatcher.net" http://gitops-demo-dev-420f0504fde951d4.elb.ca-central-1.amazonaws.com
curl -v -H "Host: gitops-stage.arguswatcher.net" http://gitops-stage-bfb16a510327f164.elb.ca-central-1.amazonaws.com




kubectl delete application <root-app-name> -n argocd


```


ESO (-6)
  └──► Karpenter (-5)
         └──► ALBC (-4)
                ├──► Envoy Gateway (-3)
                │      ├──► External DNS (-2)
                │      └──► Argo Rollouts (-1)
                │                 └──► App (0)
                └──► External DNS (-2)