# Force delete namespace stuck terminating
kubectl get namespace hookie -o json | jq 'del(.spec.finalizers)' | kubectl replace --raw "/api/v1/namespaces/hookie/finalize" -f -
