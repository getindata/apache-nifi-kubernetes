{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nifireg.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nifireg.fullname" -}}
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
In the event that we create both a headless service and a traditional one,
ensure that the latter gets a unique name.
*/}}
{{- define "nifireg.svcname" -}}
{{- printf "%s%s" .Release.Name (.Values.serviceSuffix |default "--svc") | trunc 63 | trimSuffix "-" -}}
{{- end -}}

# {{/*
# Create a random string if the supplied key does not exist
# */}}
# {{- define "nifireg.defaultsecret" -}}
# {{- if . -}}
# {{- . | b64enc | quote -}}
# {{- else -}}
# {{- randAlphaNum 20 | b64enc | quote -}}
# {{- end -}}
# {{- end -}}
