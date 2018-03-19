
all: setup apps mon

setup: 
	rm -rf ~/.kube/config
	cp provision/files/config ~/.kube/config

apps: setup
	kubectl create secret generic kubernetes-dashboard-certs --from-file=./yaml/dashboard/cert -n kube-system 
	#kubectl create -f yaml/dashboard/dashboard-admin.yaml
	kubectl create -f yaml/dashboard/dashboard.yaml -n kube-system
	open https://172.168.0.10:30000

mon: setup
	kubectl create -f yaml/influxdb/ -n kube-system
	kubectl create -f yaml/rbac/heapster-rbac.yaml -n kube-system
	open http://172.168.0.10:30001

	
clean:
	kubectl delete secret kubernetes-dashboard-certs -n kube-system
	kubectl delete -f yaml/dashboard/dashboard.yaml -n kube-system
	#kubectl delete -f yaml/dashboard/dashboard-admin.yaml
	kubectl delete -f yaml/influxdb/ -n kube-system
	kubectl delete -f yaml/rbac/heapster-rbac.yaml -n kube-system

addUser:
	kubectl create namespace nogada
	#kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')


