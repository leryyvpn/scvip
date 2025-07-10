#!/bin/bash
# COLOR VALIDATION
clear
RED='\033[0;31m'
NC='\033[0m'
gray="\e[1;30m"
Blue="\033[0;34m"
green='\033[0;32m'
grenbo="\e[92;1m"
YELL='\033[0;33m'
red() { echo -e "\\033[32;1m${*}\\033[0m"; }
# Getting
MYIP=$(curl -sS ipv4.icanhazip.com)
echo -e "\e[32mloading...\e[0m"
clear
IP=$(wget -qO- icanhazip.com)
dateToday=$(date +"%Y-%m-%d")
USRSC=$(curl -sS https://https://raw.githubusercontent.com/lerryvpn/izin/main/ip | grep $MYIP | awk '{print $2}')

setup_bot() {
    switch=$(grep -i "switch" /root/.bckupbot | awk '{print $2}')
    echo "Pergi ke @BotFather dan type /newbot untuk membuat bot baru"
    echo "Pergi ke @MissRose_bot dan type /id untuk mendapatkan ID telegram"
    echo ""
    read -p "Bot Token : " getToken
    read -p "Admin ID  : " adminID
    echo "$getToken" >/root/.bckupbot
    echo "$adminID" >>/root/.bckupbot
    echo "switch $switch" >>/root/.bckupbot
    read -n 1 -s -r -p "Press any key to back on Bot menu"
    botbckpBot_menu
}

botBackup() {
    bottoken=$(sed -n '1p' /root/.bckupbot | awk '{print $1}')
    adminid=$(sed -n '2p' /root/.bckupbot | awk '{print $1}')
    echo -e "[ ${green}INFO${NC} ] Create password for database"
	read -t 10 -p "Enter password : "  InputPass
	if [[ -z $InputPass ]]; then
	InputPass="TIKTOKVPN"
	fi
	sleep 1
    echo -e "[ ${green}INFO${NC} ] • VPS Data Backup... "
    sleep 1
    echo -e "[ ${green}INFO${NC} ] • Directory Created... "
    mkdir /root/backup &>/dev/null
    sleep 1
    echo -e "[ ${green}INFO${NC} ] • VPS Data Backup Start Now... "
    echo -e "[ ${green}INFO${NC} ] • Please Wait , Backup In Process Now... "
    sleep 1
	cp /etc/passwd backup/ &>/dev/null
	echo -e "[ ${green}INFO${NC} ] • Backup passwd data..."
	sleep 1
	cp /etc/group backup/ &>/dev/null
	echo -e "[ ${green}INFO${NC} ] • Backup group data..."
	sleep 1
	cp /etc/shadow backup/ &>/dev/null
	echo -e "[ ${green}INFO${NC} ] • Backup shadow data..."
	sleep 1
	cp /etc/gshadow backup/ &>/dev/null
	echo -e "[ ${green}INFO${NC} ] • Backup gshadow data..."
	sleep 1
    cp -r /var/lib/kyt/ backup/kyt &>/dev/null
    cp -r /etc/xray backup/xray &>/dev/null
    cp -r /var/www/html backup/html &>/dev/null
    cd /root &>/dev/null
    zip -rP "$InputPass" "$IP-$USRSC-$dateToday.zip" backup >/dev/null 2>&1

    echo -e "[ ${green}INFO${NC} ] • Sending Via Bot... "
    curl -Ss --request POST \
        --url "https://api.telegram.org/bot${bottoken}/sendDocument?chat_id=${adminid}&caption=Here Your Backup Today : ${dateToday}" \
        --header 'content-type: multipart/form-data' \
        --form document=@"/root/$IP-$USRSC-$dateToday.zip" >/root/t1

    fileId=$(grep -o '"file_id":"[^"]*' /root/t1 | grep -o '[^"]*$')

    curl -Ss --request GET \
        --url "https://api.telegram.org/bot${bottoken}/getfile?file_id=${fileId}" >/root/t1

    filePath=$(grep -o '"file_path":"[^"]'* /root/t1 | grep -o '[^"]*$')

    curl -Ss --request GET \
        --url "https://api.telegram.org/bot${bottoken}/sendMessage?chat_id=${adminid}&text=File ID   : <code>${fileId}</code>&parse_mode=html" &>/dev/null
    curl -Ss --request GET \
        --url "https://api.telegram.org/bot${bottoken}/sendMessage?chat_id=${adminid}&text=File Path : <code>${filePath}</code>&parse_mode=html" &>/dev/null

    echo -e "[ ${green}INFO${NC} ] • Completed... "

    rm -rf /root/backup
    rm -r /root/$IP-$USRSC-$dateToday.zip
    rm -f /root/t1
    read -n 1 -s -r -p "Press any key to back on menu"
    botbckpBot_menu
}

