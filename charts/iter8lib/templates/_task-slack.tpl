{{- define "task.slack" -}}
{{- /* Validate values */ -}}
{{- if not . }}
{{- fail "slack notify values object is nil" }}
{{- end }}
{{- if not .url }}
{{- fail "please set a value for the url parameter" }}
{{- end }}
# task: send a Slack notification
- task: notify
  with:
    url: {{ .url }}
    method: POST
    payloadTemplateURL: {{ default "https://github.com/alan-cha1/iter8/master/blob/slack-template.tpl" .payloadTemplateURL }}
    softFailure: {{ default true .softFailure }}
{{ end }} 