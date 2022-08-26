---
title: "DevOps Ci/Cd python,docker,jenkins"
date: 2022-08-26T19:32:23Z
tags: ["Develpment","Blogging","fast"]
categories: ["Automatitation","eng"]
draft: false
---
### Steps

#### Continuos integration
- merge all code work into a master branch
- code reviews, copile,build, unit tests,integration tests

#### Continuos delivery 
- deploy to test Server (in this case azure vm)
    - UAT,QA
- build are delivered throughout the life cycle

#### Continuis Deployment 
- deploy to prod sercer or release

#### Work Job
![](https://raw.githubusercontent.com/Ancordss/SimpleFlask_app/master/static/Screenshot%202022-08-26%20102511.png)

in this case where deploy the image in the same machine where jenkins is running and if it is successful then it is going to publish it to the docker hub and then the next stage jenkins will actually deploy the image to the server

im trying to mimic o replicate the whole  flow of ci/cd here starting from checking out code and then deploying to one of these servers 

##### in a usual ci/cd enverinmoment basically this is how the things work. in this case im trying mimic in a local systems.

#### Requeriments:
- python3x. text editor or IDE
- docker, dockerhub account
- git, git bash or github Desktop
- github account
- jenkins server on linux 
- linux server with docker installed (this will the deployment server).


#### Firs go an clone this repository
 - > https://github.com/Ancordss/SimpleFlask_app.git

 now we can check we have a simple flask app a Dockerfile and a jenkinsfile

 now we go to jenkins and install those plugins

- [CloudBees Docker Build and Publish](https://plugins.jenkins.io/docker-build-publish/)
- [Docker Commons](https://plugins.jenkins.io/docker-commons/)
- [Docker Pipeline](https://plugins.jenkins.io/docker-workflow/)
- [SSH server](https://plugins.jenkins.io/sshd/)

### Configure your vm
for the jenkins vm we need have configurated and installed docker, jenkins and git
you can go to this repository and run the scripts to automate the installation and configuration

- > https://github.com/Ancordss/node_webapp

after that continue with the next step

### Creating a vm in azure to deploy the project

here need to have a azure account.

firs go to new recurse and search docker, python virtual machine now create the machine

in this machine we need configurate docker user to run commands without sudo
so we need to run this commands: 

```
- sudo groupadd docker

- sudo usermod -aG docker $USER

- newgrp docker 

- docker run hello-world
```

#### Create a new job pipeline

go to pipeline script 
and copy and paste the code of jenkinsfile on it 

at this point you need change the code to your own repository of github, dockerhub and put your ip servers 
click on save and now run if all was good you have finished.

### Some preview of this proyect 

#### jenkins 
![](https://raw.githubusercontent.com/Ancordss/SimpleFlask_app/master/static/image2.png)

#### dockerhub
![](https://raw.githubusercontent.com/Ancordss/SimpleFlask_app/master/static/image_docker.png)

#### docker ps
![](https://raw.githubusercontent.com/Ancordss/SimpleFlask_app/master/static/image3.png)

#### app running
![](https://raw.githubusercontent.com/Ancordss/SimpleFlask_app/master/static/deploy.png)

## BASED ON A PROJECT OF = [Kumar'S](https://www.youtube.com/c/KumarS1)



