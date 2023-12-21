sudo apt-get install git -y
curl -fsSL https://get.docker.com | bash
git clone https://github.com/thebigstevo/frappe_docker
cd frappe_docker
git checkout nonprofit

export APPS_JSON_BASE64=$(base64 -w 0 apps.json)

sudo docker build \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-14 \
  --build-arg=PYTHON_VERSION=3.10.12 \
  --build-arg=NODE_VERSION=16.20.1 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=devksom/erpnext-custom:latest \
  --file=images/custom/Containerfile .
sudo docker login -u devksom -p $DOCKER_PASSWORD
sudo docker push  devksom/erpnext-custom:1.0.1

sudo python3 easy-install.py --prod -s app.theinfoseclab.com --email dev@theinfoseclab.com --project erp_non_profit --image docker.io/devksom/erpnext-custom --version 1.0.1
