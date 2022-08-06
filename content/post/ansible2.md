---
title: "Ansible | creando Playbooks"
date: 2022-05-05T15:45:55Z
tags: ["fast", "Development","Blogging"]
categories: ["Automatitation","esp"]
draft: false
---

#### Un playbook es un archivo donde se escribiran todas las tareas que quieres que se hagan con ansible es escrito en yml y es mas facil porque solo tendremos que ejecutarlo no tendremos que escribir cada comando y recordarlo.

#### Primer paso

- crearemos una archivo llamado tareas.yml



#### segundo paso

escribiremos el siguiente codigo:

```yaml
---

- hosts: all
  name: creando un playbook
  become: true
  task:
  - name: instala vim
  	apt: name=vim state=present
  - name: comando shell
  	shell: echo hola
  - name: detiene servicio
  	service: name=nginx state=stoppeda
  - name: start servicio
  	service: name=nginx state=started
```

-- [En la variable hosts podemos especificar ip/dominio igual podemos colocar el nombre de los grupos a los que queremos que se les apliquen estos cambios]

-- [en task podemos llamar a los modulos que usaremos en este ejemplo usamos 3 modulos el apt, shell y service para saber mas sobre modulos puedes visitar la documentacion de ansible en el apartado modulos]

-- [la variable become indica si se ejecutara en modo super-usuario el codigo en el caso del ejemplo se necesita ya que es requerido para instalar vim y cambiar el estado de los servicios]

#### tercer paso

corremos el playbook con el siguiente comando:

```bash
ansible-playbook --ask-pass tareas.yml -K
```
