{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "varnish.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "varnish.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "varnish.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create full hostname for autogenerated hosts
*/}}
{{- define "varnish.autogeneratedHost" -}}
{{- printf "%s-%s" .Release.Name .Values.routesAutogenerateSuffix | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "varnish.labels" -}}
helm.sh/chart: {{ include "varnish.chart" . }}
{{ include "varnish.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "varnish.lagoonLabels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "varnish.selectorLabels" -}}
app.kubernetes.io/name: {{ include "varnish.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create a PriorityClassName.
(this is based on the Lagoon Environment Type)).
*/}}
{{- define "varnish.lagoonPriority" -}}
{{- printf "lagoon-priority-%s" .Values.environmentType }}
{{- end -}}

{{/*
Lagoon Labels
*/}}
{{- define "varnish.lagoonLabels" -}}
lagoon/service: {{ .Release.Name }}
lagoon/service-type: {{ .Chart.Name }}
lagoon/project: {{ .Values.project }}
lagoon/environment: {{ .Values.environment }}
lagoon/environmentType: {{ .Values.environmentType }}
lagoon/buildType: {{ .Values.buildType }}
{{- if .Values.branch }}
lagoon/branch: {{ .Values.branch }}
{{- end }}
{{- if .Values.prNumber }}
lagoon/prNumber: {{ .Values.prNumber | quote }}
lagoon/prHeadBranch: {{ .Values.prHeadBranch | quote }}
lagoon/prBaseBranch: {{ .Values.prBaseBranch | quote }}
{{- end }}
{{- end -}}
