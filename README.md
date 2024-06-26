# Alist-EX-container

## [English Version](README-en.md)


[概述](#概述)

[部署方式](#部署方式)

[初次使用](#初次使用)  

[更多用法和注意事项](#更多用法和注意事项)  


## 概述

本项目集成了 Alist 、Aria2、qBittorrent 以及 Caddy 反向代理，可以访问 AriaNg 和 qBittorrent Web面板，方便更改设置和管理下载任务。支持自动开启 https，支持 AMD64/Arm64/Armv7 架构。


## 部署方式

 1. 下载 [docker-compose文件](https://github.com/wy580477/Alist-EX-container/blob/main/docker-compose.yml). 

 2. 按说明设置好变量，用如下命令运行容器。

        docker-compose up -d


## 初次使用

1. 执行 "docker logs alist-ex"，可获取 alist 初始密码。
2. 访问 < ip地址或域名 >:< CADDY_WEB_PORT > 即可打开 AList。
3. 访问 < ip地址或域名 >:< CADDY_WEB_PORT >/portalpage ，可以打开导航页。
4. 访问 < ip地址或域名 >:< CADDY_WEB_PORT >/ariang ，可以打开 AriaNg 面板，点击 常规设置 > RPC 填入RPC密钥，并检查协议和端口是否与浏览器地址栏显示的相符。
5. 访问 < ip地址或域名 >:< CADDY_WEB_PORT >/qbitweb ，可以打开 qBittorrent WebUI。查看数据存放目录下 log/qBittorrent/current 文件，获得临时密码，输入默认用户名 admin 和临时密码登陆。点击 tools > options，可以更改界面语言。然后点击 Web UI 更改用户名和密码，务必设置为强密码。
6. 访问 < ip地址或域名 >:< CADDY_WEB_PORT >/qbitvue ，可以打开 VueTorrent qBittorrent WebUI。
7. 设置离线下载：

   打开 Alist 管理面板，设置 > 其它。
   
   填入 Aria2 地址：http://localhost:61601/jsonrpc ，和之前设置的 Aria2 密钥。
   
   填入 qBittorrent 链接： http://< qbit 用户名>:< qbit 密码 >@localhost:61602/


## 更多用法和注意事项

 1. 如果从之前的 alist 安装迁移，可以直接把数据目录指定到之前的 alist 数据目录。

 2. AriaNg 面板更改的 Aria2 设置，在 Aria2 重启后会失效。修改数据目录下 aria2/aria2.conf 文件，可以持久更改 Aria2 设置。

 3. 设置管理员密码: 

```
     # 随机生成管理员密码
     docker exec alist-ex alist admin random

     # 手动设置管理员密码,`NEW_PASSWORD`是指你需要设置的密码
     docker exec alist-ex alist admin set NEW_PASSWORD
```

 4. 在数据目录下 log 目录中，可以查看 aria2/qBittorrent/caddy 的日志。
