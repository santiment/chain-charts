{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "optimism.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "optimism.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Determine volume name.
*/}}
{{- define "optimism.volumename" -}}
{{- if .Values.l2geth.persistence.VolumeName -}}
{{- printf "%s" .Values.l2geth.persistence.VolumeName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "optimism.fullname" .) "data" | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Determine dtl name.
*/}}
{{- define "optimism.dtlname" -}}
{{- printf "%s-%s" (include "optimism.name" .) "dtl" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Determine dtl full name.
*/}}
{{- define "optimism.dtlfullname" -}}
{{- printf "%s-%s" (include "optimism.fullname" .) "dtl" | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Determine dtl volume name.
*/}}
{{- define "optimism.dtlvolumename" -}}
{{- if .Values.l2geth.persistence.VolumeName -}}
{{- printf "%s" .Values.dtl.persistence.VolumeName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "optimism.dtlfullname" .) "db" | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Determine l2geth roolup address.
*/}}
{{- define "optimism.dtlservice" -}}
{{- printf "http://%s.%s:%s" (include "optimism.dtlfullname" .) .Release.Namespace .Values.dtl.service.dtl.port }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "optimism.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "optimism.statefulset.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "apps/v1beta2" -}}
{{- print "apps/v1beta2" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Determine service account name for statefulset.
*/}}
{{- define "optimism.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "optimism.fullname" .) .Values.serviceAccount.name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Determine proxy name for statefulset.
*/}}
{{- define "optimism.proxyname" -}}
{{- if .Values.proxy.enabled -}}
{{- printf "%s-%s" .Chart.Name "proxy" | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
