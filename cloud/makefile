init:
	terraform init tf/.

plan: init
	terraform plan \
	-var-file="tf/vars/terraform.tfvars" \
	-out=tf.plan \
	tf/.

apply: init plan
	terraform apply tf.plan

destroy: init
	terraform destroy \
	-var-file="tf/vars/terraform.tfvars" \
	tf/.

run:
	ansible-playbook ansible/playbooks/$(playbook) \
	-i ansible/inventory \
	$(extra_args)

inventory:
	ansible-inventory \
	-i ansible/inventory \
	--list
