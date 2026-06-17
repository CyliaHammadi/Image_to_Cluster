.PHONY: install cluster build import deploy all clean





install:

	@echo " Installation de K3d, Packer et Ansible..."

	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $$(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

	sudo apt update && sudo apt install packer ansible -y





cluster:

	@echo " Création du cluster K3d..."

	k3d cluster create lab --api-port 127.0.0.1:6443 -p "30080:30080@agent:0" --agents 2





build:

	@echo " Build de l'image Nginx avec Packer..."

	packer init nginx.pkr.hcl

	packer build nginx.pkr.hcl





import:

	@echo " Import de l'image dans K3d..."

	k3d image import my-nginx-custom:v1 -c lab





deploy:

	@echo " Déploiement via Ansible..."

	ansible-playbook deploy.yml



all: install cluster build import deploy

	@echo " Pipeline complet terminé avec succès !"

clean:

	@echo "Suppression du cluster..."

	k3d cluster delete lab
