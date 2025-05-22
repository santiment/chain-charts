{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "simple-node.name" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "simple-node.app" -}}
{{ if .Values.appNameOverride }}{{ .Values.appNameOverride }}{{ else }}{{ .Release.Name }}{{ end }}
{{- end -}}

{{- define "simple-node.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "simple-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "simple-node.labels" -}}
helm.sh/chart: {{ include "simple-node.chart" . }}
app.kubernetes.io/name: {{ include "simple-node.app" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "simple-node.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "simple-node.statefulset.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "apps/v1" -}}
apps/v1
{{- else if .Capabilities.APIVersions.Has "apps/v1beta2" -}}
apps/v1beta2
{{- else -}}
apps/v1
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "simple-node.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Determine service account name for statefulset.
*/}}
{{- define "simple-node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "simple-node.fullname" .) .Values.serviceAccount.name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Determine config name for statefulset.
*/}}
{{- define "simple-node.confname" -}}
{{- if .Values.config.enabled -}}
{{- printf "%s-%s" (include "simple-node.fullname" .) "config" | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
