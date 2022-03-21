{{- define "k.result.role" -}}
{{- include "k.common" -}}
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ $name }}-result-role
rules:
- apiGroups: [""]
  resources: ["secrets"]
  resourceNames: ["{{ $name }}-result"]
  verbs: ["create", "get", "update"]
{{- end -}}
