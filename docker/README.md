# 如何使用Docker

- 首先确保你的电脑安装了docker

- 创建镜像

```shell
# 修改Dockerfile，line4
ARG user=intern #这里***需要修改为你当前电脑的用户名，即/home/intern的intern
# 运行build脚本创建offlinerl镜像
./docker/build.sh
```

- start容器

```shell
./docker/dev_start.sh
```

- 进入容器

```shell
./docker/dev_into.sh
```

- 安装一些必要的库

```shell
cd docker/dev/requirements
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

- 测试是否安装完全

```shell
cd algorithm/offline
python3 cql.py #这里下载对应环境的hdf5文件比较耗时
```

