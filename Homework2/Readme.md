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

To chande index.html: ` nano /usr/share/nginx/html/index.html`


![My Nginx Homepage](Assets/1_d_MyNginx.html.png)


### 1e.

To download the default page: `curl localhost:80 > index`

To place hello.html as default page: `kubectl cp hello.html demo:/usr/share/nginx/html/index.html`


![My new Homepage](Assets/1_e_newIndex.png)

### 1f.

To stop and delete `kubectl delete -f  demo `


## 2

To do this assgnment I use two files my yaml and one bash script file. My yaml file create one job and while using using a config map that contains my script.

My yaml

```

apiVersion: v1
kind: ConfigMap
metadata:
  name: script-volume
data:
  script.sh: |
    #!/bin/bash
    apt-get update
    apt-get install git -y
    apt-get install curl -y
    cd ../
    git clone --recurse-submodules https://github.com/chazapis/hy548.git
    curl -L https://github.com/gohugoio/hugo/releases/download/v0.96.0/hugo_extended_0.96.0_Linux-64bit.deb -o hugo.deb
    apt install ./hugo.deb
    hugo version 
    cd  hy548
    cd html
    hugo -D
    ls -l
    # sleep infinity

---

apiVersion: batch/v1
kind: Job
metadata:
  name: ask2
spec:
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: ubuntu
        image: ubuntu:20.04
        
        ports:
        - containerPort: 80
          name: http
          protocol: TCP

        args:
        - "./scripts/script.sh"


        volumeMounts:
        - name: script-volume
          mountPath: /scripts

      volumes:
      - name: script-volume
        configMap:
          name: script-volume
          defaultMode: 0777
```


To run my yaml I run

`kubectl apply -f ask2.yaml`

To check that everything was ok I first run `kubectl get pods` to see if my pod crashed then I check the logs for the expected ouputs by runing :

`kubectl logs my_pods_name `

To check if the job finshed I run :

`kubectl get jobs`

## 3

  I create a persistent volume on path /ush/share/nginx/html so my pods can comunicate. 
  
  Then I create an nginx pod that serves the content of /ush/share/nginx/html/

  Finaly my ubuntu pod created by cronjob clones the github repo the compile the conntent of /hy548/html/public and check if is the same as /ush/share/nginx/html/ if so it does nothing if the files are difrent overites the existing files with the content of /hy548/html/public.



### 4

  When the building of the project has finished I copy to it to /usr/share/nginx/html. My init container periodically check if index.html exist and if so terminates and the nginx start.

  
  And here is my final yaml 

  Without Cronjob:
  ```
  apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ubuntu-pvc
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi

---


apiVersion: v1
kind: Service
metadata:
  name: nginxapp
spec:
  type: ClusterIP
  ports:
  - port: 80
  selector:
    app: nginxapp


---

apiVersion: v1
kind: ConfigMap
metadata:
  name: script-volume
data:
  check.sh:  |
    #!/bin/bash   

    cd /usr/share/nginx/html

    while true
    do
      sleep 10
      
      if [[ -f index.html ]]
      then
        echo "index is exist!"
        break;
      else
        echo "index is not exist!"
      fi

        
    done
    # sleep infinity
  script.sh: |
    #!/bin/bash

    rm -rfv /usr/share/nginx/html/*

    apt-get update
    apt-get install git -y
    apt-get install curl -y
    cd ../
    git clone --recurse-submodules https://github.com/chazapis/hy548
    curl -L https://github.com/gohugoio/hugo/releases/download/v0.96.0/hugo_extended_0.96.0_Linux-64bit.deb -o hugo.deb
    apt install ./hugo.deb
    hugo version


  
    cd  hy548
    cd html
    hugo -D
    diff -q public/  /usr/share/nginx/html/ 1>/dev/null


    if [[ $? == "0" ]]
    then
      echo "The same"
    else
      echo "Not the same"
      cp -r public/. /usr/share/nginx/html/
    fi





    # sleep infinity


---


apiVersion: batch/v1
kind: Job
metadata:
  name: ask4
spec:
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: ubuntu
        image: ubuntu:20.04     
        args:
        - "./scripts/script.sh"

        volumeMounts:
        - name: ubuntu-volume
          mountPath: /usr/share/nginx/html


        - name: script-volume
          mountPath: /scripts

      volumes:
      - name: ubuntu-volume
        persistentVolumeClaim:
          claimName: ubuntu-pvc
      - name: script-volume
        configMap:
          name: script-volume
          defaultMode: 0777
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginxapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginxapp
  template:
    metadata:
      labels:
        app: nginxapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.6
  
        volumeMounts:
        - name: ubuntu-volume
          mountPath: /usr/share/nginx/html
          

      initContainers:
      - name: ubuntu
        image: ubuntu:20.04     
        args:
        - "./scripts/check.sh"

        volumeMounts:
        - name: ubuntu-volume
          mountPath: /usr/share/nginx/html

        
        - name: script-volume
          mountPath: /scripts
          


      volumes:
      - name: ubuntu-volume
        persistentVolumeClaim:
          claimName: ubuntu-pvc

      - name: script-volume
        configMap:
          name: script-volume
          defaultMode: 0777




  ```



  with cronjob:

  ```
  apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ubuntu-pvc
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi

---


apiVersion: v1
kind: Service
metadata:
  name: nginxapp
spec:
  type: ClusterIP
  ports:
  - port: 80
  selector:
    app: nginxapp


---

apiVersion: v1
kind: ConfigMap
metadata:
  name: script-volume
data:
  check.sh:  |
    #!/bin/bash   

    cd /usr/share/nginx/html

    while true
    do
      sleep 10
      
      if [[ -f index.html ]]
      then
        echo "index is exist!"
        break;
      else
        echo "index is not exist!"
      fi

        
    done
    # sleep infinity
  script.sh: |
    #!/bin/bash

    rm -rfv /usr/share/nginx/html/*

    apt-get update
    apt-get install git -y
    apt-get install curl -y
    cd ../
    git clone --recurse-submodules https://github.com/chazapis/hy548
    curl -L https://github.com/gohugoio/hugo/releases/download/v0.96.0/hugo_extended_0.96.0_Linux-64bit.deb -o hugo.deb
    apt install ./hugo.deb
    hugo version


  
    cd  hy548
    cd html
    hugo -D
    diff -q public/  /usr/share/nginx/html/ 1>/dev/null


    if [[ $? == "0" ]]
    then
      echo "The same"
    else
      echo "Not the same"
      cp -r public/. /usr/share/nginx/html/
    fi





    # sleep infinity


---



apiVersion: batch/v1
kind: CronJob
metadata:
  name: job-repeating
spec:
  schedule: "15 2 * * *" 
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure              
          containers:
          - name: ubuntu
            image: ubuntu:20.04     
            args:
            - "./scripts/script.sh"

            volumeMounts:
            - name: ubuntu-volume
              mountPath: /usr/share/nginx/html


            - name: script-volume
              mountPath: /scripts

          volumes:
          - name: ubuntu-volume
            persistentVolumeClaim:
              claimName: ubuntu-pvc
          - name: script-volume
            configMap:
              name: script-volume
              defaultMode: 0777
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginxapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginxapp
  template:
    metadata:
      labels:
        app: nginxapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.6
  
        volumeMounts:
        - name: ubuntu-volume
          mountPath: /usr/share/nginx/html
          

      initContainers:
      - name: ubuntu
        image: ubuntu:20.04     
        args:
        - "./scripts/check.sh"

        volumeMounts:
        - name: ubuntu-volume
          mountPath: /usr/share/nginx/html

        
        - name: script-volume
          mountPath: /scripts
          


      volumes:
      - name: ubuntu-volume
        persistentVolumeClaim:
          claimName: ubuntu-pvc

      - name: script-volume
        configMap:
          name: script-volume
          defaultMode: 0777


  ```
