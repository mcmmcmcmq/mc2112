#!/bin/bash
installRclone() {
    mkdir -p ~/.config/dbxcli/
    echo "${dropboxcli}" >>~/.config/dbxcli/auth.json
}
frp(){
    cat > $HOME/frpc.ini <<EOF
${FRP}
EOF

            tmux new -s frp -d
            tmux send-key -t frp "cd ${HOME}" Enter
            tmux send-key -t frp "frpc -c $HOME/frpc.ini" Enter

}
ttyd(){

            tmux new -s ttyd -d
            tmux send-key -t ttyd "/bin/ttyd -c mc:$Pwd --port $PORT bash" Enter

}
# 检查服务端是否存在
checkIsInstall() {
    checkServerHas=$(dbxcli ls /mcserver )
    if [[ "${checkServerHas}" == *"mcserver/mc.tar.gz"* ]]; then
        echo "存在"
        dbxcli get /mcserver/mc.tar.gz  $HOME
    else
        echo "不存在"
        wget -O $HOME/mc.tar.gz  -U "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36" $ServerUrl 
    fi
    flag=1
    while [ $flag -eq 1 ]; do
        sleep 10s
        if [ -f "${HOME}/mc.tar.gz" ]; then
            flag=0
            echo "文件解压中"
            mkdir $HOME/mc
            tar -zxvf  $HOME/mc.tar.gz -C $HOME/mc
            echo "解压完毕"
            tmux new -s mc -d
            tmux send-key -t mc "cd ${HOME}/mc" Enter
            tmux send-key -t mc "java -Xmx400M -Xms64M -jar $HOME/mc/server.jar nogui" Enter
            echo '服务执行完毕'
        else
            echo "文件不存在"
        fi
    done

}

autoBak() {
    echo "备份已开启 首次运行将在180s后备份"
    sleep 45m
    echo "正在备份"
    cd $HOME/mc
    tar -zcvf  $HOME/mc.tar.gz ./
    dbxcli put $HOME/mc.tar.gz /mcserver/mc.tar.gz
    while [ 1==1 ]; do
        autoBak
    done
}

xray(){
    cd $HOME
    mkdir xray &&cd xray
    wget https://github.com/XTLS/Xray-core/releases/download/v1.5.5/Xray-linux-64.zip
    unzip Xray-linux-64.zip
    chmod +x ./xray 
       cat > $HOME/xray/config.json <<EOF
${Xray}
EOF
        tmux new -s xray -d
        tmux send-key -t xray "cd ${HOME}/xray" Enter
        tmux send-key -t xray "./xray --config ./config.json" Enter
        
    cd $HOME
    mkdir cf &&cd cf
    wget -O cf  https://github.com/cloudflare/cloudflared/releases/download/2022.5.3/cloudflared-linux-386
   
    chmod +x ./cf 
    mkdir $HOME/.cloudflared/
       cat > $HOME/.cloudflared/cert.pem <<EOF
${CF}
EOF
        tmux new -s cf -d
        tmux send-key -t cf "cd ${HOME}/cf" Enter
        tmux send-key -t cf "./cf --hostname $CFURL --url 127.0.0.1:1506 " Enter  
}

ttyd 
xray 
frp 
installRclone  
checkIsInstall 

autoBak 
