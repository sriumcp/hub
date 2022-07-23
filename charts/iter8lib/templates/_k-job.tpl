{{- define "k.job" -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: iter8-{{ required "app.name is required" .app.name }}
  namespace: {{ required "app.namespace is required" .app.namespace }}
spec:
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ .app.name }}
        app.kubernetes.io/part-of: iter8
      annotations:
        sidecar.istio.io/inject: "false"
    spec:
      serviceAccountName: iter8-{{ .app.name }}
      containers:
      - name: iter8
        image: {{ .iter8lib.iter8Image }}
        imagePullPolicy: Always
        command:
        - "/bin/sh"
        - "-c"
        - |
          iter8 k run --namespace {{ .app.namespace }} --group {{ .app.name }} -l {{ .iter8lib.logLevel }}
      restartPolicy: Never
  backoffLimit: 0
{{- end }}
