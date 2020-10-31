#create kubeadm-config.yaml
cat > kubeadm-config.yaml<<EOF
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "k8s-worker1.localdomain.local:6443"
etcd:
    external:
        endpoints:
        - https://192.168.4.114:2379
        - https://192.168.4.114:2379
        - https://192.168.4.170:2379
        caFile: /etc/kubernetes/pki/etcd/ca.crt
        certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
        keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
EOF
kubeadm init --config kubeadm-config.yaml --upload-certs
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
