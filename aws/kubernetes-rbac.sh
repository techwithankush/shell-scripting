#!/bin/bash

# ClusterRole YAML definition
read -r -d '' CLUSTER_ROLE_YAML << EOM
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: developer-clusterrole-readonly
rules:
  - verbs:
      - get
      - list
    apiGroups:
      - ' '
    resources:
      - namespaces
      - pods
      - pods/log
  - verbs:
      - get
      - list
    apiGroups:
      - apps
    resources:
      - deployments
EOM

# ClusterRole YAML definition for developer-clusterrole-readonly-shell
read -r -d '' CLUSTER_ROLE_READONLY_SHELL_YAML << EOM
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: developer-clusterrole-readonly-shell
rules:
  - verbs:
      - get
      - list
      - watch
      - create
    apiGroups:
      - ''
    resources:
      - namespaces
      - pods
      - pods/log
      - pods/exec
  - verbs:
      - get
      - list
    apiGroups:
      - apps
    resources:
      - deployments
EOM

# ClusterRole YAML definition for developer-clusterrole-readonly-restart
read -r -d '' CLUSTER_ROLE_READONLY_RESTART_YAML << EOM
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: developer-clusterrole-readonly-restart
rules:
  - verbs:
      - get
      - list
      - delete
    apiGroups:
      - ''
    resources:
      - pods
      - pods/log
  - verbs:
      - get
      - list
    apiGroups:
      - ''
    resources:
      - namespaces
  - verbs:
      - get
      - list
    apiGroups:
      - apps
    resources:
      - deployments
EOM

# ClusterRoleBinding YAML definition for developer-readonly-clusterrole-rolebinding
read -r -d '' CLUSTER_ROLE_BINDING_YAML_1 << EOM
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: developer-readonly-clusterrole-rolebinding
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: abc
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: developer-clusterrole-readonly
EOM

# ClusterRoleBinding YAML definition for developer-readonly-shell-clusterrole-rolebinding
read -r -d '' CLUSTER_ROLE_BINDING_YAML_2 << EOM
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: developer-readonly-shell-clusterrole-rolebinding
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: abc
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: developer-clusterrole-readonly-shell
EOM

# ClusterRoleBinding YAML definition for developer-readonly-restart-clusterrole-rolebinding
read -r -d '' CLUSTER_ROLE_BINDING_YAML_3 << EOM
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: developer-readonly-restart-clusterrole-rolebinding
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: abc
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: developer-clusterrole-readonly-restart
EOM

# Apply ClusterRole and ClusterRoleBinding YAML definitions
echo "$CLUSTER_ROLE_YAML" | kubectl apply -f -
echo "$CLUSTER_ROLE_READONLY_SHELL_YAML" | kubectl apply -f -
echo "$CLUSTER_ROLE_READONLY_RESTART_YAML" | kubectl apply -f -
echo "$CLUSTER_ROLE_BINDING_YAML_1" | kubectl apply -f -
echo "$CLUSTER_ROLE_BINDING_YAML_2" | kubectl apply -f -
echo "$CLUSTER_ROLE_BINDING_YAML_3" | kubectl apply -f -

echo "Kubernetes RBAC resources created successfully."
