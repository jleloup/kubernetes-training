init:
	vagrant up

list-snapshots:
	vagrant snapshot list

save:
	vagrant halt
	vagrant snapshot save $(snapshot)
	vagrant up

restore:
	vagrant halt
	vagrant snapshot restore $(snapshot)
	vagrant up

tear-down:
	vagrant destroy

