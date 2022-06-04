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
                  type: string
  preserveUnknownFields: false


```

the commands are : 

`minikube start --kubernetes-version=1.22.4`

`kubectl apply -f fruit-crd.yaml`

`python3 -m venv venv`

`source venv/bin/activate`

`pip install -r requirements.txt`

`kubectl apply -f fruits.yaml`

`kubectl get fruits`


## 2

### 2.a

greeting-controller.yaml

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: k8s-101
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: k8s-101
    spec:
      serviceAccountName: k8s-101-role
      containers:
      - name: k8s-101
        imagePullPolicy: Always
        image: salathielgenese/k8s-101
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
