# minikube-replicas
This project aims to show how to demonstrate the use of replicas to deploy services in kubernetes using minikube.

## Requirements
The minikube and kubect must be installed previously.

## Specification
- Custom namespace: a2
- Apache: 3 replicas services, running on port 8080. Document root index.html with "hello world" message.
- Tomcat v8: 1 replica service, running on port 8090. Sample application deployed in /sample context from https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/

## How to execute
Clone the git repository:
`
git clone https://github.com/xjulio/minikube-replicas.git
`

Enter the repository directory and execute the run.sh script

`
cd minikube-replicas && sh build-and-deploy.sh
`

If the minikube is not running, then the script will start.

This proccess will build the tomcat and apache Docker images using Dockerfile manifest in docker directory and create deployment/services into k8s using kubectl command.

## Testing
Check if the replicas was deployed correctly using the command:
`
kubectl get deployment --namespace=a2
`
<pre>
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
apache    3         3         3            3           14h
tomcat    1         1         1            1           14h
</pre>

The tomcat and nginx was deployed on k8s using the NodePort, for this we must find the IP address/port of services executing the following command:
`
minikube service list
`

<pre>
|-------------|----------------------|-----------------------------|
|  NAMESPACE  |         NAME         |             URL             |
|-------------|----------------------|-----------------------------|
| a2          | apache-service       | http://192.168.99.103:30946 |
| a2          | tomcat-service       | http://192.168.99.103:30745 |
| default     | kubernetes           | No node port                |
| kube-system | default-http-backend | http://192.168.99.103:30001 |
| kube-system | kube-dns             | No node port                |
| kube-system | kubernetes-dashboard | No node port                |
|-------------|----------------------|-----------------------------|
</pre>

The ports presented on URL column are random and probably will be different from those shown in the table.

To test service, use the following command to open the service url ar browser:

`
minikube service apache-service --namespace=a2
`

`
minikube service tomcat-service --namespace=a2
`
