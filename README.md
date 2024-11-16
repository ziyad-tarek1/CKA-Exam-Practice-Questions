# CKA-Exam-Practice-Questions
Certified Kubernetes Administrator Mock Exam Real Questions 



### Q1: Weightage: 7%

Create a new pod called web-pod with image busybox Allow the pod to be able to set system_time The container should sleep for 3200 seconds.

### Answer :

1.1 create the pod using the dry run command
``` bash
controlplane $ kubectl run web-pod --image=busybox --command sleep 3000 --dry-run=client -o yaml > web-pod.yaml

 ```

1.2 edit the yaml file 
``` bash
vi web-pod.yaml
 ```

1.3 edit the pod using the instruction this documentation link :
https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

``` bash
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
    securityContext:                             # add this line 
      capabilities:                              # add this line 
        add: ["SYS_TIME"]           # add this line 

    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

 ```

1.4 run the below create command

``` bash
controlplane $ kubectl create -f web-pod.yaml 
pod/web-pod created
controlplane $ 
```

### Q2: Weightage: 11%

Create a new deployment called myproject, with image nginx:1.16 and 1 replica. Next upgrade the deployment 
to version 1.17 using rolling update Make sure that the version upgrade is recorded in the resource annotation.

### Answer :

2.1 create the deployment and a backup dry run for it

``` bash
controlplane $ kubectl create deployment myproject --image=nginx:1.16 --replicas=1 --dry-run=client -o yaml > myproject.yaml
 ```
``` bash 
kubectl create deployment myproject --image=nginx:1.16 --replicas=1
```
2.1 using the documemtation to upgrade the image version 
https://kubernetes.io/docs/reference/kubectl/quick-reference/

``` bash
kubectl set image deployment/myproject nginx=nginx:1.17 --record

# the --record flag for recorded in the resource annotation
```


### Q3  Weightage: 7%

Create a new deployment called my-deployment. Scale the deployment to 3 replicas.
Make sure desired number of pod always running.

### Answer :

3.1 : create the dry run for the deployment check it and run it 

``` bash
kubectl create deployment my-deployment --image=nginx --replicas=3 --dry-run=client -o yaml > my-deployment.yaml

kubectl create -f my-deployment.yaml
  ```

### Q4 Weightage: 4%

Deploy a web-nginx pod using the nginx:1.17 image with the labels set to tier=web-app.

Answer :
4.1 run the dry run command and double check the yaml file for the lables then run the create command

``` bash
kubectl run web-nginx --image=nginx:1.17 --labels tier=web-app --dry-run=client -o yaml > web-nginx.yaml

kubectl create -f web-nginx.yaml 
```

``` bash
kubectl get pod --show-labels
```


### Q5 Weightage: 4%

Create a static pod on node01 called static-pod with image nginx and you have to make sure that it is recreated/restarted automatically in case of any failure happens

### Answer :
 5.1  create a dry run for the static-pod 

 ``` bash 
controlplane $ kubectl run static-pod --image=nginx --dry-run=client -o yaml > static-pod.yaml
 ```

 5.2 ssh to the node and check the configuration file that refers to the static pods location


 ``` bash 
 ssh node01
```
``` bash 
 5.3 check the kubelet location 

 ps aux | grep kubelet
# the output

node01 $ ps aux | grep kubelet
root        1093  0.8  4.3 1904760 88076 ?       Ssl  21:22   0:39 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.10 --container-runtime-endpoint unix:///run/containerd/containerd.sock --cgroup-driver=systemd --eviction-hard imagefs.available<5%,memory.available<100Mi,nodefs.available<5% --fail-swap-on=false
root       22258  0.0  0.0   3436   720 pts/0    S+   22:42   0:00 grep --color=auto kubelet
node01 $ 
```
``` bash 
## as shown the configuration of the kubelet proocess is at /var/lib/kubelet/config.yaml look for staticPodPath: /etc/kubernetes/manifests 
# move to it node01 $ cd /etc/kubernetes/manifests 
cd /etc/kubernetes/manifests 

 vi static-pod.yaml
```
``` bash
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
5.4 on the master node check it has been created 

``` bash 
controlplane $ kubectl get pod
NAME                READY   STATUS    RESTARTS   AGE
static-pod-node01   1/1     Running   0          45s
controlplane $ 
```

### Q6 Weightage: 7 % 

Create a pod called pod-multi with two containers, as given below:

Container 1 - name: container1, image: nginx

Container2 - name: container2, image: busybox, command: sleep 4800

### Answer :

6.1 create a dry run fo a single containr the edit it 
`` bash 
kubectl run pod-multi --image=nginx --dry-run=client -o yaml > pod-multi.yaml
```

```bash
vi pod-multi.yaml
```

``` bash 
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
6.2 create the pod 

``` bash 
kubectl create -f pod-multi.yaml
```

### Q7 Weightage: 5 %