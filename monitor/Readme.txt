In this example, we're creating a ServiceMonitor resource with the name vote-monitor that selects pods with the app: vote label. We're also specifying an endpoints section that specifies the port and path for the Prometheus metrics endpoint.


STEPS)
1) ## addon to include for premoetheus in minikube ##
 minikube start --addons=metrics-server
2) ## apply CRD using kubectl apply -f  https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml
3) ## validate ## 
kubectl api-resources --api-group=monitoring.coreos.com
4) configure deployment and service file as it is i.e prometheus-deployment.yaml & prometheus-service.yaml 
5) in file monitor-service.yaml  configure the application endpoints and enable select label to all
6) configure job name application with required application ports 
7) Run kubectl apply -f . ## which will run all files 
8) view prometheus application using minikube service prometheus-service
9) access the ui from above cmd and query up{} to get all metrics configured for the application
