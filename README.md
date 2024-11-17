# CKA-Exam-Practice-Questions
Certified Kubernetes Administrator Mock Exam Real Questions 

## Hyperlink Section  
- [Q1: Create a Pod with Special Capabilities](#q1-weightage-7)  
- [Q2: Upgrade Deployment Image Version](#q2-weightage-11)  
- [Q3: Scale a Deployment](#q3-weightage-7)  
- [Q4: Deploy a Pod with Labels](#q4-weightage-4)  
- [Q5: Create a Static Pod](#q5-weightage-4)  
- [Q6: Create a Multi-Container Pod](#q6-weightage-7)  
- [Q7: Create a Pod in a Custom Namespace](#q7-weightage-5)  
- [Q8: Get Node Info in JSON Format](#q8-weightage-4) 
- [Q9: Get Nodes oslmages Query Info in JSON Format](#q9-weightage-5) 

---

## Q1: **Weightage: 7%**

**Task:**  
Create a new pod called `web-pod` with the image `busybox`. Allow the pod to set `system_time`. The container should sleep for 3200 seconds.

**Answer:**  
1. Create the pod using the dry-run command:
    ```bash
    kubectl run web-pod --image=busybox --command sleep 3000 --dry-run=client -o yaml > web-pod.yaml
    ```

2. Edit the `web-pod.yaml` file:
    ```bash
    vi web-pod.yaml
    ```

3. Update the YAML file with the following:
    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: web-pod
      name: web-pod
    spec:
      containers:
      - command:
        - sleep
        - "3000"
        image: busybox
        name: web-pod
        securityContext:  # Add this line
          capabilities:   # Add this line
            add: ["SYS_TIME"]  # Add this line
        resources: {}
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}
    ```

4. Run the create command:
    ```bash
    kubectl create -f web-pod.yaml
    ```

---

## Q2: **Weightage: 11%**

**Task:**  
Create a new deployment called `myproject` with the image `nginx:1.16` and 1 replica. Next, upgrade the deployment to version `1.17` using a rolling update. Ensure the version upgrade is recorded in the resource annotation.

**Answer:**  
1. Create the deployment and save it as a backup:
    ```bash
    kubectl create deployment myproject --image=nginx:1.16 --replicas=1 --dry-run=client -o yaml > myproject.yaml
    kubectl create deployment myproject --image=nginx:1.16 --replicas=1
    ```

2. Upgrade the image version:
    ```bash
    kubectl set image deployment/myproject nginx=nginx:1.17 --record
    ```

---

## Q3: **Weightage: 7%**

**Task:**  
Create a new deployment called `my-deployment`. Scale the deployment to 3 replicas and ensure the desired number of pods are always running.

**Answer:**  
1. Create the deployment with dry-run, verify it, and apply it:
    ```bash
    kubectl create deployment my-deployment --image=nginx --replicas=3 --dry-run=client -o yaml > my-deployment.yaml
    kubectl create -f my-deployment.yaml
    ```

---

## Q4: **Weightage: 4%**

**Task:**  
Deploy a `web-nginx` pod using the `nginx:1.17` image with the labels `tier=web-app`.

**Answer:**  
1. Create the YAML file using dry-run, verify the labels, and apply it:
    ```bash
    kubectl run web-nginx --image=nginx:1.17 --labels tier=web-app --dry-run=client -o yaml > web-nginx.yaml
    kubectl create -f web-nginx.yaml
    ```

2. Verify the labels:
    ```bash
    kubectl get pod --show-labels
    ```

---

## Q5: **Weightage: 4%**

**Task:**  
Create a static pod on `node01` called `static-pod` with the image `nginx`. Ensure it is recreated/restarted automatically in case of failure.

**Answer:**  
1. Create a dry-run file for the static pod:
    ```bash
    kubectl run static-pod --image=nginx --dry-run=client -o yaml > static-pod.yaml
    ```

2. SSH into `node01` and check the kubelet static pod path:
    ```bash
    ssh node01
    ps aux | grep kubelet
    # Output shows staticPodPath: /etc/kubernetes/manifests
    ```

3. Move to the static pod path and create the YAML file:
    ```bash
    cd /etc/kubernetes/manifests
    vi static-pod.yaml
    ```

4. Add the following configuration:
    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        run: static-pod
      name: static-pod
    spec:
      containers:
      - image: nginx
        name: static-pod
    ```

5. Verify the pod is created on the master node:
    ```bash
    kubectl get pod
    ```

---

## Q6: **Weightage: 7%**

**Task:**  
Create a pod called `pod-multi` with two containers:
- **Container 1**: name `container1`, image `nginx`
- **Container 2**: name `container2`, image `busybox`, command `sleep 4800`

**Answer:**  
1. Create a dry-run for a single container and edit it:
    ```bash
    kubectl run pod-multi --image=nginx --dry-run=client -o yaml > pod-multi.yaml
    vi pod-multi.yaml
    ```

2. Update the YAML file:
    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        run: pod-multi
      name: pod-multi
    spec:
      containers:
      - image: nginx
        name: container1
      - image: busybox
        name: container2
        command: ['sh', '-c', 'sleep 4800']
    ```

3. Create the pod:
    ```bash
    kubectl create -f pod-multi.yaml
    ```

---

## Q7: **Weightage: 5%**

**Task:**  
Create a pod called `test-pod` in the "custom" namespace, with labels `env=test` and `tier=backend`, using the image `nginx:1.17`.

**Answer:**  
1. Check if the `custom` namespace exists; if not, create it:
    ```bash
    kubectl get ns
    kubectl create ns custom
    ```

2. Create the pod YAML using dry-run:
    ```bash
    kubectl run test-pod --image=nginx:1.17 --labels env=test,tier=backend --namespace=custom --dry-run=client -o yaml > test-pod.yaml
    ```

3. Example YAML:
    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        env: test
        tier: backend
      name: test-pod
      namespace: custom
    spec:
      containers:
      - image: nginx:1.17
        name: test-pod
    ```

---

## Q8: **Weightage: 4%**

**Task:**  
Get the node `node01` in JSON format and store it in a file at `./node-info.json`.

**Answer:**  
1. Run the command:
    ```bash
    kubectl get node node01 -o json > ./node-info.json
    ```

--- 

## Q9: **Weightage: 7%**
**Task:** 
Use JSON PATH query to retrieve the oslmages of all the nodes and store it in a file "all-nodes-os-info.txt" at root location.

Note: The osImage are under the nodeInfo section under status of each node.

**Answer:**
1. using the documentation at  https://kubernetes.io/docs/reference/kubectl/quick-reference/ 

``` bash 
kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > all-nodes-os-info.txt

```

---



## Q10 : **Weightage: 4%**
**Task:** 
Create a Persistent Volume with the given specification.

Volume Name: pv-demo

Storage:100Мі

Access modes: ReadWriteMany

Host Path: /pv/host-data

**Answer:**
1. using the documentation at  https://kubernetes.io/docs/concepts/storage/persistent-volumes/

``` bash 
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-demo
spec:
  capacity:
    storage: 100Mi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /pv/host-data

```
2. run the create command
```bash
k create -f pv-demo.yaml
```

---

## Q11: **Weightage: 7%**
**Task:** 
Worker Node “node01” not responding, Debug the issue and fix it.



**Answer:**
1. check the network by doing ssh at the node in a new tap

``` bash 
ssh node01

```
2. check the kubelet state

```bash 
ps aux | grep kubelet

```
3. check the logs of kubelet

``` bash 
journalctl -x | grep kubelet | grep error

```
4. check the kubelet configuration file it maybe an issue with the certificate it should be at
 /var/lib/kubelet/pki/

```bash 
 vim /etc/kubernetes/kubelet.conf 
```

```bash

node01 $ ll /var/lib/kubelet/pki/
total 20
drwxr-xr-x 2 root root 4096 Nov  6 12:45 ./
drwxrwxr-x 9 root root 4096 Nov  6 12:45 ../
-rw------- 1 root root 1110 Nov  6 12:45 kubelet-client-2024-11-06-12-45-21.pem
lrwxrwxrwx 1 root root   59 Nov  6 12:45 kubelet-client-current.pem -> /var/lib/kubelet/pki/kubelet-client-2024-11-06-12-45-21.pem
-rw-r--r-- 1 root root 2254 Nov  6 12:45 kubelet.crt
-rw------- 1 root root 1675 Nov  6 12:45 kubelet.key

```
```bash 
systemctl restart kubelet 
```
---

## Q12: **Weightage: 11%**
**Task:** 
Upgrade the Cluster (Master and worker Node) from 1.18.0 to 1.19.0. Make sure to first drain both Node and make it available after upgrade.

**Answer:**
1. open new tap to ssh at node01

``` bash 
ssh node01 
```

2. drain the master node first

```bash 
k drain controlplane --ignore-daemonsets --force 
```

3. install the kubeadm needed packages

```bash 
sudo apt-mark unhold kubeadm && \ 
> sudo apt-get update && sudo apt-get install -y kubeadm=1.19.0-00 \
> sudo apt-mark hold kubeadm
```
4. run the upgrade aplly

```bash

kubeadm upgrade apply v1.19.0 -y 

```





---