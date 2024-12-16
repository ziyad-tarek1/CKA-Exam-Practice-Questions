#!/bin/bash

# Define the YAML files
cat <<EOF > pod_definitions.yaml
apiVersion: v1
kind: Pod
metadata:
  name: high-cpu-app-1
  labels:
    name: app
spec:
  containers:
  - name: high-cpu-container
    image: busybox:latest
    resources:
      limits:
        cpu: "1"
      requests:
        cpu: "0.1"
    command:
    - /bin/sh
    - -c
    - |
      while true; do 
        yes > /dev/null; 
      done
---
apiVersion: v1
kind: Pod
metadata:
  name: high-cpu-app-2
  labels:
    name: app
spec:
  containers:
  - name: high-cpu-container
    image: busybox:latest
    resources:
      limits:
        cpu: "1"
      requests:
        cpu: "0.1"
    command:
    - /bin/sh
    - -c
    - |
      while true; do 
        yes > /dev/null; 
      done
---
apiVersion: v1
kind: Pod
metadata:
  name: high-cpu-app-3
  labels:
    name: app
spec:
  containers:
  - name: high-cpu-container
    image: busybox:latest
    resources:
      limits:
        cpu: "1"
      requests:
        cpu: "0.1"
    command:
    - /bin/sh
    - -c
    - |
      while true; do 
        yes > /dev/null; 
      done
---
apiVersion: v1
kind: Pod
metadata:
  name: loadbalancer
  labels:
    app: loadbalancer
spec:
  containers:
  - name: log-generator
    image: busybox:latest
    command:
    - /bin/sh
    - -c
    - |
      echo "Error unable-to-access-website"; 
      echo "INFO test in progress"; 
      echo "WARNING get you"; 
      echo "NOTE I am certified Kubernetes administration"; 
      echo "Error unable-to-access-website"; 
      echo "INFO test in progress"; 
      echo "WARNING get you"; 
      echo "NOTE I am certified Kubernetes administration"; 
      echo "Error unable-to-access-website"; 
      echo "INFO test in progress"; 
      echo "WARNING get you"; 
      echo "NOTE I am certified Kubernetes administration"; 
      sleep 15000;
---
apiVersion: v1
kind: Pod
metadata:
  name: legacy-app
spec:
  containers:
  - name: legacy-app
    image: busybox:latest
    imagePullPolicy: Always
    env:
    - name: LOG_PATH
      value: "/var/log/webapp"
    command: ["/bin/sh"]
    args:
    - "-c"
    - |
      mkdir -p \$LOG_PATH && \
      while true; do \
        echo "\$(date) - Simulated log entry" >> \$LOG_PATH/legacy-app.log; \
        sleep 5; \
      done
EOF

# Apply the YAML to Kubernetes
echo "Applying the Kubernetes pods..."
kubectl apply -f pod_definitions.yaml

# Clean up by removing the temporary YAML file
rm pod_definitions.yaml

echo "Pods have been deployed successfully!"


# Create namespaces
kubectl create namespace app-team1
kubectl create namespace ing-internal

# Label node01 with specified labels
kubectl label nodes node01 name=ek8s-node-1 disk=spinning

# Verify the creation of namespaces
echo "Created namespaces:"
kubectl get namespaces

# Verify the labels on node01
echo "Labels on node01:"
kubectl get node node01 --show-labels

