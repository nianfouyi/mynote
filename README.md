# mynote

拉取镜像的进修需要使用全名，不然即使科学上网后也会拉不下来镜像
```shell
docker pull --platform arm64 k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.3.0
docker pull --platform arm64 prom/alertmanager:v0.24.0
docker pull --platform arm64 prom/alertmanager:v0.24.0
```
使用docker save 保存时，不要使用id，应该使用镜像：tag的形式，使用id保存镜像，重新load会有问题