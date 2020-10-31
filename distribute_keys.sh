export CONTROL_PLANE="ubuntu@${1}"
tar cvf ~ubuntu/pki.tar /etc/kubernetes/pki
scp -p ~ubuntu/pki.tar "${CONTROL_PLANE}":

ssh "${CONTROL_PLANE}" sudo (cd /etc/kubernetes; tar xvf ~ubuntu/pki.tar) 
