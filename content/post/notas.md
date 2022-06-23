#### notas para usar kubernets

instalar kubectl y kubernetes 
tener instalado docker

para usar o practicar usar minikube 
para iniciar minikube correr : 

- sudo sysctl fs.protected_regular=0 
- sudo minikube start


ahora ya se pueden ejecutar comandos [ejecutar como root]

### comandos mas usados 

```
kubectl config get-contexts
kubectl get ns
[para ver pods]
kubectl -n kube-system get pods [se le puden pasar mas comandos como -o wide]
kubectl delete pod "nombre del pod"
kubectl delete -f "nombre del archivo" [elimina los pods que crea el archivo]
kubectl get pod "nombre del pod" [para ver el estado del pod, se le puede pasar -o yaml y mostrara todo el yaml del pod ]
kubectl describe pod "nombre del pod"
kubectl get pvc
kubectl delete pvc "nombre del pvc"
kubectl get sts
kubectl delete sts "nombre del StatefulSet"
```

### manifiestos---
[para entender revisar 01-pod.yaml]
la primera parte es la version de la api del recurso es dificil recordar recomiendo
fijarse en los docs

metadata: le podemos agregar etiquetas o nombres si o si necesita un nombre 

ahora declararemos los contenedores 
colocalos el nombre y la imagen que llamaremos 

para colocar la configuracion del pod corremmos

```
kubectl apply -f 01-pod.yaml
```

### kubectl exec

con este comando al igual que con docker ejecutamos comandos dentro del contenedor

podemos correr estos comandos para hacer unas pruebas:

```
kubectl exec -it nginx -- sh 
```

!nota: el -it hace que sea interactiva la shell y despues de -- se coloca el comando que queremos 
que se ejecute [para salir presiona ctrl+d]

### manifiestos 2
[archivo 02-pods.yaml]

opciones mas comunes dentro de un pod:

-varible de entorno
  env:
  - name: Mi_varible
    value: "val"
    [video sobre mas funciones env https://www.youtube.com/watch?v=T7lRHHa4YxE&t=0s]

  resources:
  [request recursos que siempre tendra disponible el pod]
  [limits limite que el pod puede llegar a usar de memoria y cpu] nota! si empieza a usar mas el kernel mata el proceso
  [readlinessProbe forma de explicar a kubernet que el pod esta listo listo para resivir trafico]
  [livenessProbe forma de explicar a kubernetes de que el pod esta vivo]

ports
le decimos el puerto que queremos exponer le ponemos en 80 ya que nginx trabajo con ese.


--- ya sabemos lo que son los pod .


### manifiesto deployments
[archivo 04-deployments.yaml]

es muy parecido a los pod 
tenemos un spec dentro de un spec esto es un templete para nustro spots

las replicas son la cantidad de pods que queremos en el deployments

deployments es un template para crear pods

### daemonset 

es una forma de deployar un pod pero este pod sera deployado en todos los nodos
este tipo no tiene replicar, depende de la cantidad de nodos que tengas 


para que sirve: servicios de monitore, capturar logs.

es muy parecido a un deployment solo que no tiene replica.

### StatefulSet

esta es forma que aparte de correr como cualquier otro deployment tiene un volumen 

es direcctorio que estara atado a ese pod. 

sirve para base de datos

storageclassname : driver de kubernetes para un proveedor. 


## pensar en que cosas podemos usar kubernetes


la infracstura ya no solo es codigo ahora tambien es datos  

### Networking en kubernetes

Pod Networking

cada pod tiene su propio ip

ip routing 


### kubernetes services : kube proxys 
son una forma de poder contactar aplicaciones osea un sed de pods 

principalemte hay 3 

- cluster ip [sirve como load balancer]
- node port [crea un puerto en cada nodo que recibe el servicio y lo mando a donde se indique]
- load balancer [esta atado a la nube, crea un balanceador de carga en el proveedor y redirecciona el trafico a los nodos]


### Service node port 
 [referencia 08-hello-deploymen-svc-nodeport.yaml]
se le puede agregar una opcion extra que es nodeport: 
en el que podemos especificar que puerto queremos que se cree en cada nodo 

## service loadBalancer 

en type se coloca LoadBalancer 
servicio del proveedor digital ocean 

porque es mejor que un node port 

porque esta atado a la ip de cada nodo

esta ip no cambia siempre es la misma 

### ingress
[referencia 10-hello-v1-v2-deployment-svc.yaml]

nos permite crear acceso a nuestros servicios pasados en el PATH

funcionamiento: kubernetes va a hacer un deploy de un controlador nginx
osea que correra nginx dentro de nuestro cluster y lo que va hacer este nginx es que tendra un controlador
 especial que va a leer este tipo de recurso de kubernetes que se llama ingress. va a leer esas configuraciones y 
 se va a autoconfigurar para mandar el trafico a donde tiene que mandarlo

 esto quiere decir que nosotros tenemos que instalar nuestro controlador ingress en nuestro claso nginx
 no todos los clusters de kubernetes dependiendo del proveedor que estes usando vienen con ingress funcionando generalmente
 se debe instalar a parte

 como se instala? depende del proveedor pero puedes usar helm

 comando de ingres 

 ```
 kubectl get ing 
 kubectl -n ingress-nginx get svc
 ```

 esta forma es la mas usada y mas normal para crear aplicaciones 

#### extras 

### configmap 

es un archivo que se hostea en kubernetes 
despues puedes acceder al archivo desde los pods 
ejemplo [referencia 12-configmap.yaml]

supongamos que quiere configurar algun servicio que necesite tenes un archivo de configuracion donde quere guardar algo 
que es diferente por cada cluster entonces no queres estar hardcodeando en el manifiesto de esta forma usas el mismo manifiesto 
en todos los cluster y lo unico que se hace es cambiar el config map para eso se usan 

### secrets

la diferencia entre este y el otro es que el contenido de estos valores estara codificado en base64
esto no es una forma de encriptar no es seguro pero una persona no lo puede leer 

consulta la doc para ver los comando que se pueden ingresar para generar automaticamente el yaml codificado

se recomienda usar kubeSealed si se quiere tener encriptado algun dato


### kustomization
  [referencia kustomization.yaml]
es una forma de manejar manifiesto mas facil

nos permite con un cliente generar manfiestos 

para ejecutar se usa :

```
Kustomize build .
```


