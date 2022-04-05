# Homework 2

## 1

### 1 a.

The yaml file I will need is :

``` yaml

apiVersion: v1
kind: Pod
metadata:
  name: demo
spec:
  containers:
  - name: nginx
    image: nginx:1.21.6-alpine
    ports:
    - containerPort: 80
      name: http
      protocol: TCP

```

The commands are :

To start minikube:  ` minikube start `

To start the pod: `kubectl apply -f Homework2_1.yaml`



### 1 b.
To forward the pod to port 80: `kubectl port-forward demo 80:80`

To copy the nginx default page: `curl localhost:80 > index.html`

### 1 c.

To print the logs: `kubectl logs demo`

### 1 d.

To open a session: `kubectl exec -it demo -- /bin/sh `

To install nano so you can edit index.html:

`apk update`

`apk add nano`

To chande index.html: ` nano /usr/share/nginx/htmlindex.html`


![My Nginx Homepage](Assets/1_d_MyNginx.html.png)


### 1e.

To download the default page: `curl localhost:80 > index`

To place hello.html as default page: `kubectl cp hello.html demo:/usr/share/nginx/html/index.html`


![My new Homepage](Assets/1_e_newIndex.png)

### 1f.

To stop and delete `kubectl delete -f  demo `


## 2

To do this assgnment I use two files my yaml and one bash script file. My yaml file create one job and while using using a config map that contains my script.

My Script :

```
#!/bin/bash
apt-get update

apt-get install git -y

apt-get install curl -y

cd ../

git clone --recurse-submodules https://github.com/chazapis/hy548.git


curl -L https://github.com/gohugoio/hugo/releases/download/v0.96.0/hugo_0.96.0_Linux-64bit.deb  -o hugo.deb


apt install ./hugo.deb

hugo version
 

cd  hy548

cd html

hugo -D

ls -l


```
My yaml

```
apiVersion: batch/v1
kind: Job
metadata:
  name: john1
spec:
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: ubuntu
        image: ubuntu:20.04
        
        
        
        args:
        - "./scripts/wrapper.sh"


        volumeMounts:
        - name: wrapper
          mountPath: /scripts

      volumes:
      - name: wrapper
        configMap:
          name: wrapper
          defaultMode: 0777
```

To create a configmap I run:

`kubectl create configmap wrapper --from-file=wrapper.sh`

To run my yaml I run

`kubectl apply -f Homework2_2.yaml`

To check that everything was ok I first run `kubectl get pods` to see if my pod crashed then I check the logs for the expected ouputs by runing :

`kubectl logs my_pods_name `

## 3
