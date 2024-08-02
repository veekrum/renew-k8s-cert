# renew-k8s-cert
This script renews certs for kubernetes that expires anually. This script will work for all the cluster that is hosted in the HA, multi-master cluster, single master cluster.

# requirement
  - script is assuming containerd as CRI so circtl cmd is used to stop the services, find what CRI is used [container runtime interfaces] in your cluster,
    to export for containerd. eg: -> `export CONTAINER_RUNTIME_ENDPOINT=unix:///var/run/containerd/containerd.sock`

# Steps
  - clone the script to respective servers.
  - run the script 
    - cd renew-k8s-cert
    - chmod +x renew.sh
    - bash renew.sh
