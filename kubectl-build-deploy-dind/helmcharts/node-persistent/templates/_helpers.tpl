{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "node-persistent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "node-persistent.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "node-persistent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create full hostname for autogenerated hosts
*/}}
{{- define "node-persistent.autogeneratedHost" -}}
{{ if not .prefix }}
{{- printf "%s.%s" .root.Release.Name .root.Values.routesAutogenerateSuffix | trimSuffix "-" -}}
{{ else }}
{{- printf "%s.%s.%s" .prefix .root.Release.Name .root.Values.routesAutogenerateSuffix | trimSuffix "-" -}}
{{ end }}
{{- end -}}

{{/*
Generate name of Persistent Storage
Uses the Release Name (Lagoon Service Name) unless it's overwritten via .Values.persistentStorage.name
*/}}
{{- define "node-persistent.persistentStorageName" -}}
{{- default .Release.Name .Values.persistentStorage.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "node-persistent.labels" -}}
helm.sh/chart: {{ include "node-persistent.chart" . }}
{{ include "node-persistent.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "node-persistent.lagoonLabels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "node-persistent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "node-persistent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create a PriorityClassName.
(this is based on the Lagoon Environment Type)).
*/}}
{{- define "node-persistent.lagoonPriority" -}}
{{- printf "lagoon-priority-%s" .Values.environmentType }}
{{- end -}}

{{/*
Lagoon Labels
*/}}
{{- define "node-persistent.lagoonLabels" -}}
lagoon.sh/service: {{ .Release.Name }}
lagoon.sh/service-type: {{ .Chart.Name }}
lagoon.sh/project: {{ .Values.project }}
lagoon.sh/environment: {{ .Values.environment }}
lagoon.sh/environmentType: {{ .Values.environmentType }}
lagoon.sh/buildType: {{ .Values.buildType }}
{{- end -}}

{{/*
Datadog Admission Controller label
*/}}
{{- define "node-persistent.datadogLabels" -}}
{{- if eq .Values.environmentType "production" -}}
admission.datadoghq.com/enabled: "true"
{{- end -}}
{{- end -}}

{{/*
Annotations
*/}}
{{- define "node-persistent.annotations" -}}
lagoon.sh/version: {{ .Values.lagoonVersion | quote }}
{{- if .Values.branch }}
lagoon.sh/branch: {{ .Values.branch | quote }}
{{- end }}
{{- if .Values.prNumber }}
lagoon.sh/prNumber: {{ .Values.prNumber | quote }}
lagoon.sh/prHeadBranch: {{ .Values.prHeadBranch | quote }}
lagoon.sh/prBaseBranch: {{ .Values.prBaseBranch | quote }}
{{- end }}
{{- end -}}
