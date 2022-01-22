Scripts(操作指令):
1. 登入: docker login
2. 登出: docker logout
3. docker hub拿image: docker pull ${account/imageName}
4. 推image至docker hub: docker push ${accout/imageName}
5. 本地建立image: docker build -t ${account/createImageName} .
ex: 最後一個點是抓該folder底下的Dockerfile檔案

6. 列出所有image: docker images
7. 將image加入container: docker container run ${account/imageName}
8. 刪除image: docker rmi ${imageName}
9. 強制刪除image: docker rmi -f ${imageName}
10. 刪除container: docker rm ${containerName}
11. 列出所有container: docker container ls
12. 背景執行container: docker run -d --name ${containerName} ${imageName} ${common}
13. 背景執行container並對應到port: docker run -d -p ${linuxVMPort:containerMappingPort} --name ${containerName} ${imageName}
14. 停止container: docker container stop ${containerID}
15. 列出所有container(不論有啟動或沒啟動): docker container ls -a => 可再使用10指令去刪除container紀錄
16. 進入到container中: docker exec -it ${containerID} /bin/sh
17. 更改build image變數: docker build --build-arg ${argName}=${content} -t ${imageName}
18. 指定container的Network模式: docker run -d --network ${networkMode} --name ${containerName} ${imageName} tail -f /dev/null
19. 建立新的Network: docker network create --driver ${networkDriver} ${name}
20. 查詢該物件細部內容(network、volume)空間內容: docker ${type} inspect ${name} => ex: docker network inspect my-bridge、docker volume inspect mainpage-vol
21. 將容器加到其他network空間: docker network connect ${networkName} ${containerName}
22. 建立一個mapping現有container的container: docker run -d --network container:${mappingContainer} --name ${newContainerName} ${imageName} tail -f /dev/null
23. 建立一個host模式的container: docker run -d --network host --name ${containerName} ${imageName}
24. 映射Linux VM Volume到container中: docker run -d -p ${linuxVMPort:containerMappingPort} -v ${volumeName}:${containerPath} => ex: docker run -d -p 8080:80 -v myVolume:/val/www/localhost/ ben1004/apache001

Steps(運作流程):
MacOS(HOST)之下有DockerClient和DockerEngine，
在下了docker build之後會copy一份context給linux OS(VM)的DockerEngine，
DockerEngine會run Dockerfile，
而DockerFile第一件事會是找Base image(from: ${imageName:version})，
接下來create一個臨時容器(temp container)，接下來會line by line執行script和產生image在放在temp container中
  1. Dockerfile Command(FROM: alpine:latest) => BaseImage => temp Container01
     Dockerfile Command(RUN: touch file001.txt) => tempImage01 => temp Container02
     Dockerfile Command(COPY: /src/dst) => imported files => temp Container03
     Dockerfile Command(ENTRYPOINT: ["httpd"]) => finalImage

Dockerfile(腳本撰寫):
1. FROM: 取得基底image
2. ENTRYPOINT: 預設執行動作(告訴背景執行時(deamon: -d)的預設語法)
3. RUN: 使用baseImage所提供的指令(每個RUN都是獨立的(臨時性的container))
4. ENV: 宣告共用變數
5. WORKDIR: 預設目錄路徑
6. ARG: 預設值變數(可更改)
7. COPY: 複製其他檔案放入container中
8. VOLUME: 存放資料的空間
     
Docker Network Mode:
1. None: 內不能向外連，外也不能向內連，封閉空間。
2. Bridge: 對應到Bridge所提供的Network，彼此如果是在同一個Bridge Network的話就能共通，反之亦然
ex: 如果bridge1有container1、container2，bridge2有container3，container3是沒辦法跟bridge1的container共通的，
    但如果將container3加到bridge1之中，此時bridge1就會有container1、2、3，而bridge2有container3，
    這時候bridge2的container3就能跟bridge1的所有container共通。

3. Container: 將自己的container對應到現有的container
4. Host: 會跟Linux VM Network拿一個空間，能夠對應到Linux VM 主機的網路

Docker Volume:
分為三層
1. 作業系統Network
2. Linux VN Network
3. Bridge Network
1與2都是永久儲存空間，3則是暫時儲存空間，在3裡只要容器消失Volume也會消失，1、2則是不會

hint: MountPoint是VM Linux路徑

Docker Compose:
1. Service(Container: 包括Image、Dockerfile)
2. Network(None、Container、Bridge、Host network)
3. Volume(Container、VM Linux、Host space)

ex: Service => Network => Volume
    container01配一個Host network再配一個Container空間
    container02配一個Bridge01 network再配一個VM Linux Volume01空間
    container03配一個Bridge02 network再配一個VM Linux Volume02空間
    container04配一個Bridge02 network再配一個Host空間

script:
1. build docker-compose: docker-compose build --no-cache(--no-cache會每次重新bulid防止沒有更新到)
2. run container: docker-compose up -d