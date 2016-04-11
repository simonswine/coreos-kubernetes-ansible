prepare: prepare_virtualenv

# Virtualenv for Ansible
prepare_virtualenv: venv/bin/activate

venv/bin/activate: requirements.txt
	test -d venv || virtualenv venv
	venv/bin/pip install -Ur requirements.txt
	touch venv/bin/activate

prepare: prepare_virtualenv


# Adds subtree repos
subtree_coreos:
	git remote add subtree-defunctzombie-coreos-bootstrap https://github.com/defunctzombie/ansible-coreos-bootstrap.git || true
	git subtree add --prefix=ansible/roles/defunctzombie.coreos-bootstrap/ subtree-defunctzombie-coreos-bootstrap master || true

subtree_k8s:
	git remote add subtree-kubernetes-contrib-ansible https://github.com/kubernetes/contrib.git || true
	git fetch subtree-kubernetes-contrib-ansible
	git branch -D subtree-k8s || true
	git checkout -b subtree-k8s subtree-kubernetes-contrib-ansible/master
	rm -rf .git/refs/original
	git filter-branch --subdirectory-filter ansible/roles
	git checkout master
	git subtree add --prefix=ansible/roles-k8s/ subtree-k8s
