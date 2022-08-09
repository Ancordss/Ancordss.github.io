---
title: "DevOps CI/CD Project 02"
date: 2022-08-09T22:18:56Z
tags: ["fast","Blogging"]
categories: ["Automatitation","Development","eng"]
draft: false
---

# Simple DevOps Project -02

![1.png](https://github.com/Ancordss/Ancordss.github.io/blob/main/static/project2/Screenshot%202022-08-08%20104248.png?raw=true)

### Prerequisites:

1. Ansible server 
2. Jenkins Server 
3. Tocmat Server 

### Part-01 Integration Setps

Install "publish Over SSH"
 - `Manage Jenkins` > `Manage Plugins` > `Available` > `Publish over SSH` 

Enable connection between Ansible and Jenkins

- `Manage Jenkins` > `Configure System` > `Publish Over SSH` > `SSH Servers` 

	- SSH Servers:
		- Hostname:`<ServerIP>`
		- username: `ansadmin`
		- password: `*******`
		
Test the connection "Test Connection"

### Part-02 - Execute job to connect 

create a copywarfile.yml on Ansible under /opt/playbooks

```sh 
# copywarfile.yml
---
- hosts: all 
  become: true
  tasks: 
    - name: copy jar/war onto tomcat servers
        copy:
          src: /op/playbooks/wabapp/target/webapp.war
          dest: /opt/apache-tomcat-8.5.32/webapps
```
Add tomcat server details  to /etc/ansible/hosts (if you are using other hosts file update server info there)
```sh
echo "<server_IP>" >> /etc/ansible/hosts
```
Create *Jenkins job*, Fill the following details,

   - *Source Code Management:*
      - Repository: `https://github.com/Ancordss/java-maven.git`
      - Branches to build : `*/master`  
   - *Build:*
     - Root POM:`pom.xml`
     - Goals and options : `clean install package`
	 
- *Add post-build steps*
    - Send files or execute commands over SSH
      - SSH Server : `ansible_server`
      - Source fiels: `webapp/target/*.war`
      - Remote directory:  `//opt//playbooks`
- *Add post-build steps*
    - Send files or execute commands over ssH
      - SSH Server : `ansible_server`
      - Exec command ansible-playbook /opt/playbooks/copywarfile.yml
		
Execute job and you should be able to seen build has been deployed on Tomcat server.

### Some images

![1.png](https://github.com/Ancordss/Ancordss.github.io/blob/main/static/project2/Screenshot%202022-08-08%20145231.png?raw=true)
![2.png](https://github.com/Ancordss/Ancordss.github.io/blob/main/static/project2/Screenshot%202022-08-08%20145313.png?raw=true)

Based on **[YouTube](https://www.youtube.com/watch?v=nE4b9mW2ym0)**

