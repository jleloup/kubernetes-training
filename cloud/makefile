init:
	terraform init tf/.

plan: init
	terraform plan \
	-var-file="tf/vars/terraform.tfvars" \
	-out=tf.plan \
	tf/.

apply: init plan
	terraform apply tf.plan

delete:
	terraform delete

