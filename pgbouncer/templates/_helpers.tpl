{{/*
Expand the name of the chart.
*/}}
{{- define "pgbouncer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pgbouncer.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pgbouncer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pgbouncer.labels" -}}
helm.sh/chart: {{ include "pgbouncer.chart" . }}
{{ include "pgbouncer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pgbouncer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pgbouncer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "pgbouncer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pgbouncer.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Return the proper PgBouncer image
*/}}
{{- define "pgbouncer.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the proper PgBouncer Exporter image
*/}}
{{- define "pgbouncer.exporter_image" -}}
{{- $registryName := .Values.pgbouncer.metrics.image.registry -}}
{{- $repositoryName := .Values.pgbouncer.metrics.image.repository -}}
{{- $tag := .Values.pgbouncer.metrics.image.tag | toString -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the proper PgBouncer create user job image
*/}}
{{- define "pgbouncer.create_user_job_image" -}}
{{- $registryName := .Values.jobs.createAuthUser.image.registry -}}
{{- $repositoryName := .Values.jobs.createAuthUser.image.repository -}}
{{- $tag := .Values.jobs.createAuthUser.image.tag | toString -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}


{{/*
Renders userlist.txt file
*/}}
{{- define "pgbouncer.userlist.txt" -}}
{{- $authUser := printf "\"%s\" \"%s\"" .Values.authUser.name .Values.authUser.password -}}
{{- $pgbouncerUser := printf "\"%s\" \"%s\"" .Values.username .Values.password -}}
    {{- printf "%s\n%s\n%s" $authUser $pgbouncerUser .Values.pgbouncer.userlisttxt -}}
{{- end -}}