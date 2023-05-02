In this example, we're creating a ServiceMonitor resource with the name vote-monitor that selects pods with the app: vote label. We're also specifying an endpoints section that specifies the port and path for the Prometheus metrics endpoint.


STEPS)
1) ## addon to include for premoetheus in minikube ##
 minikube start --addons=metrics-server
2) ## apply CRD using kubectl apply -f  https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml
3) ## validate ## 
kubectl api-resources --api-group=monitoring.coreos.com
4) configure deployment and service file as it is i.e prometheus-deployment.yaml & prometheus-service.yaml 
5) in file monitor-service-gt.yaml  configure the application endpoints and enable select label to all
6) configure job name application with required application ports 
7) Run kubectl apply -f . ## which will run all files 
8) view prometheus application using minikube service prometheus-service
9) access the ui from above cmd and query up{} to get all metrics configured for the application


Output fro prometheous:

up{app="mysql", instance="mysql:3306", job="mysql"}
0
up{app="nginx", instance="nginx:80", job="nginx"}


#### for prometheous and grafana installatoion #######
1) Installed in default namespace
2) brew install helm
3) minikube addons enable ingress
4) helm repo add grafana https://grafana.github.io/helm-charts
5) helm repo update
6) elm install grafana grafana/grafana --set persistence.enabled=false --set service.type=NodePort
7) 
 kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
 export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services grafana)
 export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
 echo http://$NODE_IP:$NODE_PORT

This gives url for login :

 ### grafana ui setup ##  

Open the Grafana UI by running minikube service grafana in your terminal.

Log in to Grafana using the default username and password (admin/admin).

Click on "Configuration" in the left sidebar, then select "Data Sources".

Click on "Add data source".

Select "Prometheus" as the type of data source.

In the "HTTP" section, set the URL to http://prometheus:9090, where prometheus is the name of the Prometheus service in Kubernetes.

Click on "Save & Test".

If the connection is successful, you should see a green message saying "Data source is working" at the top of the page. You can now use Grafana to create dashboards and visualizations based on your Prometheus metrics.
