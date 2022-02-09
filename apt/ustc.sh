#!/bin/bash

sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "deb https://mirrors.ustc.edu.cn/ubuntu/ xenial main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "# deb-src https://mirrors.ustc.edu.cn/ubuntu/ xenial main main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb https://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "# deb-src https://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb https://mirrors.ustc.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "# deb-src https://mirrors.ustc.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb https://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "# deb-src https://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "" | sudo tee -a /etc/apt/sources.list
echo "# deb https://mirrors.ustc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "# deb-src https://mirrors.ustc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
