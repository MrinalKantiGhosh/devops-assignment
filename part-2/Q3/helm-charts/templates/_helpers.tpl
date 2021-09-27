{{- define "nginx.labels" -}}
app: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{- define "selector" -}}
app: {{ .Release.Name }}
{{- end -}}