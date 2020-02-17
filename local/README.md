# Using your workstation

These instructions are meant to provide a local infrastructure using Virtualbox and your workstation.

## Prerequisites

* Vagrant
* Virtualbox
* Bridge networking: we use public networking to expose Kubernetes API Server

This setup was used on a Macos based workstation.
I believe the Vagrant part of this repository will work fine on any machine that support Virtualbox & Vagrant.

## Configuration

As of now there is few configuration options available except:
* configure the number of Kubernetes worker you want to have. Default: 1
* configure the network interface that will be used as a bridge.
    * The default value suits my personal rig: *there are good chances that you need to update this configuration.*

Those options are set in the Vagrantfile directly.

## Usage

### Spin up a local infrastructure for the training

You can use the following make target to start the whole infrastructure.

```bash
# Spin up the nodes
make init

# Snapshot Kubernetes master in case of
make save snapshot=before-kubeadm
```

### Connect to the instances

You can connect to the instances through the following commands:

* Kubernetes master node: `vagrant ssh kube-master`
* Kubernetes worker node: `vagrant ssh kube-worker-1`
* If you asked for more workers they will be available using the same pattern as for the previous worker
    * e.g.: `kube-worker-2`, ...

### Creating the cluster

The Kubernetes fundamentals training will guide through the usage of `kubeadm` so I won't tell that much about it.

Note that sometimes `kubeadm init` will pick the wrong network interface & bind Kubernetes API server to the NAT
interface `10.0.2.15`.

If this happens:
* Reset the master node by either:
  * `sudo kubeadm reset`
  * or use the make target `make restore snapshot=before-kubeadm`
* Fetch your public IP out of `ip addr`. This one should be set on the *eth1* interface
* Use the `--apiserver-advertise-address` option during `kubeadm init`

After establishing the cluster:
* make sure that you follow `kubeadm` instructions to move the Kubernetes config
  file to your user inside the Kubernetes master node
* create a snapshot for Kubernetes master: it could help you later if you screw up
  * `make save snapshot=after-kubeadm`

### Fetch the Kubernetes config file for local usage

You can use the following commands in order to use your own terminal/shell to work with this cluster

Note: you must have followed `kubeadm` instructions about moving the Kubernetes configuration file to the user home.

```
vagrant ssh-config > /tmp/vagrant.ssh
scp -F /tmp/vagrant.ssh kube-master:~/.kube/config /tmp/vagrant.kube.config
rm /tmp/vagrant.ssh

export KUBECONFIG=/tmp/vagrant.kube.config
```

### Restore Kubernetes master

If by any chance you wreck your Kubernetes cluster you can restore the Kubernetes nodes back to a previous snapshot: `make restore snapshot=after-kubeadm-init`.

 This example restores back to the moment you have just established the cluster though you can create more snapshots whenever you want to.
 
As for the workers: you can simply kill them &

### Tear down the infrastructure

When you don't need it anymore:`make tear-down`
