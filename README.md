# CKA-Exam-Practice-Questions
Certified Kubernetes Administrator Mock Exam Real Questions 



### Q1: Weightage: 7%

Create a new pod called web-pod with image busybox Allow the pod to be able to set system_time The container should sleep for 3200 seconds.

Answer:

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

Answer :

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

Answer :

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

Answer :
