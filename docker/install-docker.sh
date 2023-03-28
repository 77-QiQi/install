#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: Debian 6+/Ubuntu 14.04+
#	Description: Install Docker & Docker Compose
#	Version: 1.0.0.0
#	Author: 77-QiQi
#	GitHub: https://github.com/77-QiQi/
#=================================================

sh_ver="1.0.0.0"
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && return 1
}
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
}
Installation_Docker(){
	echo -e "${Info} 开始下载/安装 docker..."
	curl -fsSL https://get.docker.com -o get-docker.sh
	sh get-docker.sh && rm -f get-docker.sh
	return 0
}
Installation_Compose(){
	echo -e "${Info} 开始下载/安装 docker-compose..."
	curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	docker-compose -v
	return 0
}
Uninstall(){
	if ! [ -x "$(command -v docker-compose)" ]; then
	  echo -e "${Error}: docker-compose is not installed." >&2
	  return 1
	fi
	echo "确定要 卸载 Docker & Compose ？[y/N]" && echo
	read -e -p "(默认: n):" uninstall
	[[ -z ${uninstall} ]] && uninstall="n"
	if [[ ${uninstall} == [Yy] ]]; then
		echo -e "${Info} 移除容器..."
		docker-compose down
		echo -e "${Info} done..."
		rm -rf ${folder}
		echo -e "${Info} 开始移除 compose..."
		rm -rf /usr/local/bin/docker-compose
		echo -e "${Info} 开始移除 docker..."
		apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
		rm -rf /var/lib/docker
		rm -rf /var/lib/containerd
		echo && echo -e "${Info} 卸载已完成 !" && echo
		echo -e "${Tip} 将于10秒后重启"
		sleep 10s && reboot
	else
		echo && echo -e "${Info} 卸载已取消..." && echo
	fi
}
Update_Compose(){
	if ! [ -x "$(command -v docker-compose)" ]; then
	  echo -e "${Error}: docker-compose is not installed." >&2
	  return 1
	fi
	echo -e "${Info} 移除容器......"
	docker-compose down
	echo -e "${Info} 开始移除 docker-compose..."
	rm -rf /usr/local/bin/docker-compose
	echo -e "${Info} 开始下载/安装 docker-compose..."
	curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	docker-compose -v
	echo -e "${Info}docker-compose 已更新 ..."
	docker-compose up --force-recreate -d
	echo -e "${Info} done..."
	return 0
}
Update_Shell(){
	curl https://raw.githubusercontent.com/77-QiQi/install/main/docker/install-docker.sh -o install-docker.sh && echo -e "${Info} 更新完成 ..."
	source install-docker.sh
}
Ban_Iptables(){
	bash <(curl -s -L https://raw.githubusercontent.com/77-QiQi/ban-iptables/main/ban_iptables.sh)
}

check_sys
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} !" && return 1
check_root
echo -e "  Docker & Compose 一键安装脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- 77-QiQi | github.com/77-QiQi ----

  ${Green_font_prefix}0.${Font_color_suffix} 安装 Docker
  ${Green_font_prefix}1.${Font_color_suffix} 安装 Compose
  ${Green_font_prefix}2.${Font_color_suffix} 更新 Compose
  ${Green_font_prefix}3.${Font_color_suffix} 卸载 Docker & Compose
————————————
  ${Green_font_prefix}4.${Font_color_suffix} 升级脚本 ...
  ${Green_font_prefix}5.${Font_color_suffix} 封禁/解封 ...
 "
echo -e "${Red_font_prefix} [注意：若需更新或卸载 Docker & Compose 插件，请于 docker-compose.yml 同级目录内执行！] ${Font_color_suffix}"
echo -e "${Red_font_prefix} [注意：若存在使用多个 docker-compose.yml 文件创建容器，请手动停止/移除容器后，再行操作！] ${Font_color_suffix}"
echo && read -e -p "请输入数字 [0-5]：" num
case "$num" in
	0)
	Installation_Docker
	;;
	1)
	Installation_Compose
	;;
	2)
	Update_Compose
	;;
	3)
	Uninstall
	;;
	4)
	Update_Shell
	;;
	5)
	Ban_Iptables
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [0-5]"
	;;
esac
