---
title: "Kubernetes"
date: 2022-08-06T00:49:56Z
tags: ["fast"]
categories: ["Automatitation","eng"]
draft: false
---

#### What is Kubernetes?
- is a technology that allows to orchestrate docker containers

![img.png](https://raw.githubusercontent.com/Ancordss/Ancordss.github.io/main/resources/k1.png)


- componenetes: 
  - control plane
  - Node
  - Scheduler
  - kube-proxy
  - kubelet
  - etcd
  - controller manager
  - Cloud controller manager
  - Api server

  ![im2.png](https://raw.githubusercontent.com/Ancordss/Ancordss.github.io/main/resources/k2.png)

### notes for using kubernets

requirements: docker

install kubectl and kubernetes
have docker installed

to use or practice using minikube
to start minikube running :

- sudo sysctl fs.protected_regular=0
- sudo minikube start


commands can now be executed [run as root]

### most used commands

```
  kubectl config get-contexts

  kubectl get ns
  [show pods]

  kubectl -n kube-system get pods 
  [you can pass more commands like -o wide]

  kubectl delete pod "pod name"
  
  kubectl delete -f "file name" 
  [delete the pods that the file creates]

  kubectl get pod "pod name" 
  [to see the state of the pod, you can pass -o yaml and it will show all the yaml of the pod ]

  kubectl describe pod "pod name"
  
  kubectl get pvc

  kubectl delete pvc "pvc name"

  kubectl get sts

  kubectl delete sts "statefulset name"

```
### manifests
[to understand review 01-pod.yaml]

the first part is the api version of the resource it is difficult to remember I recommend
look at the docs

metadata: we can add labels or names if or if you need a name

now we will declare the containers
place them the name and the image that we will call

to place the pod configuration we run 

```
kubectl apply -f 01-pod.yaml
```

### kubectl exec

with this command, as with docker, we execute commands inside the container

We can run these commands to do some tests:

```
kubectl exec -it nginx -- sh 
```

!note: the -it makes the shell interactive and after -- the command we want is placed
to run [to exit press ctrl+d]

### manifests 2
[02-pods.yaml file]

most common options within a pod:

-environment variable
   send:
   - name: my_variable
     value: "val"
     [video about more functions env https://www.youtube.com/watch?v=t7lrhha4yxe&t=0s]

   resources:
   [request resources that the pod will always have available]

   [limits limit that the pod can use memory and cpu]
   note! if it starts to use more the kernel kills the process

   [readlinessprobe way to explain to kubernet that the pod is ready to receive traffic]

   [livenessprobe way to explain to kubernetes that the pod is alive]

   [ports we tell it the port that we want to expose, we put it in 80 since nginx works with that.]


#### we already know what pods are!!!


### manifest deployments
[04-deployments.yaml file]

it is very similar to pods
we have a spec within a spec this is a template for our spots

the replicas are the number of pods we want in the deployments

deployments is a template to create pods

### daemonset

it is a way to deploy a pod but this pod will be deployed on all nodes
this type does not have replicate, it depends on the number of nodes you have


What is it for: monitor services, capture logs.

It is very similar to a deployment, except that it does not have a replica.

### statefulset

this is the way that apart from running like any other deployment it has a volume

is directory that will be tied to that pod.

used for database

storageclassname : kubernetes driver for a provider.


#### --think about what things we can use Kubernetes

infrastructure is no longer just code, now it is also data

### networking in kubernetes

pod networking

each pod has its own ip

ip-routing


### kubernetes services : kube proxies
They are a way to be able to contact applications, that is, a thirst for pods

mainly there are 3

- cluster ip [serves as load balancer]
- node port [creates a port in each node that receives the service and I send it to where it is indicated]
- load balancer [it is tied to the cloud, it creates a load balancer in the provider and redirects the traffic to the nodes]


### service node port
 [reference 08-hello-deploymen-svc-nodeport.yaml]
You can add an extra option that is nodeport:
in which we can specify which port we want to be created on each node

### service loadbalancer

loadbalancer is placed in type
ocean digital provider service

because it is better than a node port

because it is tied to the ip of each node

this ip does not change is always the same

### login
[reference 10-hello-v1-v2-deployment-svc.yaml]

allows us to create access to our past services in the path

operation: kubernetes will deploy an nginx controller
that is, it will run nginx inside our cluster and what this nginx will do is that it will have a controller
 special that is going to read this type of kubernetes resource called ingress. will read those settings and
 it will configure itself to send the traffic where it has to be sent

 this means that we have to install our ingress controller in our nginx class
 not all kubernetes clusters depending on the provider you are using come with ingress working generally
 must be installed separately

 how is it installed? vendor dependent but you can use helm

 login command

 ```
 kubectl get ing
 kubectl -n ingress-nginx get svc
 ```

 This form is the most used and most normal to create applications

## Additional features

### configmap

it is a file that is hosted in kubernetes
then you can access the file from the pods
example [reference 12-configmap.yaml]

suppose you want to configure some service that you need you have a configuration file where you want to save something
which is different for each cluster so you don't want to be hardcoding in the manifest this way you use the same manifest
in all the clusters and the only thing that is done is to change the config map for that they are used

### secrets

the difference between this and the other is that the content of these values ​​will be encoded in base64
this is not a form of encryption it is not secure but a person cannot read it

consult the doc to see the commands that can be entered to automatically generate the encrypted yaml

it is recommended to use kubesealed if you want to have some data encrypted


### kustomization
  [reference kustomization.yaml]
It is an easier way to handle manifest

allows us with a client to generate manifests

to execute use:

```
customize build .
```

- I recommend reading the book [Site Realiability engineering]
  You can read it in the following link:

  https://landing.google.com/sre/book.html

- Resources: https://github.com/pablokbs/peladonerd/tree/master/kubernetes/35

[^]: content taken from the following video: https://www.youtube.com/watch?v=DCoBcpOA7W4
