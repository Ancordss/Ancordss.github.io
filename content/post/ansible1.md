---
title: "Iniciando con Ansible"
date: 2022-05-04T16:57:32Z
tags: ["fast", "Development","Blogging"]
categories: ["Automatitation","esp"]
draft: false
---
## para instalar ansible

agrega el repositoria a ubuntu
y luego correo sudo apt install ansible

para que funcione bien tienes que tener un servidor al cual conectarte con ssh
en mi caso estoy usando uno que cree con una maquin virtual

##### comando para probar un ping 
```bash
ssh usuario@ip -p puerto
```

en mi caso es

```
ssh anco@192.168.1.8 -p 22
```

si todo sale bien ahora podras controlar el servidor desde tu maquina.

ahora probaremos con ansible

para probar ahora si en comando ping seria

```bash
ansible ip --ask-pass -m ping
```

lo que hace el comando --ask-pass es pedirte que ingreses la contrasenia
el -m indica que usaras un modulo y ping es el modulo



en mi caso el comando ya final seria

```bash
ansible 192.168.1.8 --ask-pass -m ping
```

##### ejecutar comandos desde ansible

lo siguiente que podemos hacer es probar mandar comando con ansible
probaremos haciendo que se ejecute un hola mundo en el servidor controlado

```bash
ansible ip --ask-pass -m shell -a 'echo hola mundo'
```

en este comando no es necesario pasar el modulo shell ya que ansible ya lo reconoce en todo caso quedaria asi:

```bash
ansible ip --ask-pass -a 'echo hola mundo'
```

##### instalando paquetes desde ansible

para isntalar paquetes usaremos este comando

```bash
ansible ip --ask-pass -m apt -a 'name=vim state=present' -b -k
```

en este comando hacemos usod el modulo apt al pasarle el valor -a le indicamos que es un comando  

y le mandamos en nombre del paquete asignandole el nombre a la variable name igualmente con state 

los parametros -b -k son para pedir la contrasenia root ya que para ejecutar apt install se necesita pasar sudo antes de 

apt install



en mi caso el comando quedaria asi:



```bash
ansible 192.168.1.8 --ask-pass -m apt -a 'name=vim state=present' -b -k
```
