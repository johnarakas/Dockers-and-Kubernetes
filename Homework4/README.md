# Homework 4

## 1

### 1a.


fruits.yaml

```
apiVersion: hy548.csd.uoc.gr/v1
kind: Fruit
metadata:
  name: apple
spec:
  origin: Krousonas
  count: 3
  grams: 980 

```

fruits-crd.yaml

```
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: fruits.hy548.csd.uoc.gr
spec:
  group: hy548.csd.uoc.gr
  scope: Namespaced
  names:
    kind: Fruit
    listKind: FruitList
    plural: fruits
    singular: fruit
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                origin:
                  type: string
                count:
                  type: integer
                grams:
                  type: integer
  preserveUnknownFields: false



```

the commands are : 

`python3 -m venv venv`

`source venv/bin/activate`

`pip install -r requirements.txt`

`minikube start --kubernetes-version=1.22.4`

`kubectl apply -f fruit-crd.yaml`

`kubectl apply -f fruits.yaml`

`kubectl get fruits apple - o yaml `

`kubectl get fruits`


## 2

### 2.a

my docker file

```
FROM python:3.9-slim-bullseye

RUN python3 -m venv /opt/venv

COPY requirements.txt .
RUN . /opt/venv/bin/activate && pip install -r requirements.txt



COPY kubeclient.py .
COPY controller.py .    

RUN apt-get update -y
RUN apt-get install curl -y
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

CMD . /opt/venv/bin/activate && exec python controller.py

```

for building the image:

`docker build -t john .`

for pushing the image:

`docker  tag john johnarakas/john:latest`

`docker push johnarakas/john:latest`


### 2.b

fruit-controller.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-101
spec:
  replicas: 1
  selector: 
    matchLabels:
      app: k8s-101
  template:
    metadata:
      labels:
        app: k8s-101
    spec:
      serviceAccountName: k8s-101-role
      containers:
      - name: k8s-101
        imagePullPolicy: Always
        image: johnarakas/john:latest
        ports:
        - name: app
          containerPort: 3000
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: k8s-101-role
subjects:
- kind: ServiceAccount
  name: k8s-101-role
  namespace: default
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: k8s-101-role

```
to run my controller :

`kubectl apply -f fruit-controller.yaml `

to check my controller :

`docker get all`

`docker get pods`

`docker describe pod ...`


