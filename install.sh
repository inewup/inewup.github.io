#!/bin/bash
#****************************************************************#
# ScriptName: YiTools
# Author: 
# Create Date: 2022-11-01 20:00
# Modify Author: 
# Last Modified: 2024-05-10 10:00
# 声明：本脚本仅用于学习交流，请勿用于非法途径，造成的任何后果与编制者无关，请在下载后24小时内删除!
# Disclaimer: This script is only for learning and communication, do not use illegal channels, any consequences have nothing to do with the compiler, please delete within 24 hours after download!
#***************************************************************#

###wzget
function wzget()
{
    echo_color "开始校验下载地址..." sky-blue
    local f_url=$1
    local f_name=$2
    local status_code=$(curl --head --location --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null ${f_url})
    if [ "$status_code" != "200" ] && [ "$status_code" != "403" ] && [ "$status_code" != "502" ]; then
        echo_color "下载文件服务器资源异常：$f_name，错误码：$status_code" red
        echo_color "请检查网络后再次重试或截图反馈!" red
        #echo_color "下载地址为：$f_url" red
        local status_code=$(curl --head --location --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null ${f_url})
        if [ "$status_code" != "200" ] ; then
            exit 0
        else
            wzget $f_url $f_name 
        fi
    else
        wget -q --show-progress -O $f_name $f_url
        if [ $? -eq 0 ]; then
            echo_color ""
        else
            echo_color "下载失败、请保持网络稳定重新执行脚本！！！！$status_code " red
            sleep 10
            main
        fi
        #echo_color "尝试下载：$f_name" yellow
        #wget -q --show-progress -O $f_name $f_url
        local filesize=`ls -l $f_name | awk '{ print $5 }'`
        if [ $filesize -eq 73 ] || [ $filesize -eq 113 ]; then
            echo_color "`cat $f_name`" red
            echo_color "下载文件大小异常:$f_name，请检查输入是否错误! \n并且请检查网络后再次重试或截图反馈!" red
            #echo_color "下载地址为：$f_url" red
	        echo ">>> 未找到您的版本号主题，请联系管理员添加后再试！"
	        echo ">>> 5秒后返回主菜单！"
	        echo " "
	        sleep 5
	        clear
	        fafa
			fafa_choice
			#main
            #exit 0
         else
            extension="${f_name##*.}"
            if [ "$extension" == "apk" ]; then
                if zipinfo "$f_name" > /dev/null 2>&1; then
                    echo_color "$f_name 下载成功" green
                else
                    if ! command -v zipinfo > /dev/null 2>&1; then
                        echo_color "环境异常自动修复中!!!!" red
                        apk add unzip > /dev/null 2>&1
                        apt install unzip -y > /dev/null 2>&1
                        echo_color ""
                        echo_color "请重新输入代码开始，或卸载软件重新安装!!!"
                        echo_color ""
                    else
                        command -v zipinfo wget
                        echo_color "#####################"
                        echo_color "$f_name下载文件校验失败，您在下载过程中未保持网络稳定!!!!" red
                        echo_color ""
                        echo_color "请确保网络稳定后再次重试即可!!!"
                        echo_color ""
                    fi
                    sleep 10
                    main
                fi
            else
                echo_color "Pass" green
            fi
        fi
    fi
}








###echo_color
function echo_color() {
        if [ $# -ne 2 ];then
                echo -e "\033[34m$1\033[0m"
        elif [ $2 == 'red' ];then
                echo -e "\033[31m$1\033[0m"
        elif [ $2 == 'green' ];then
                echo -e "\033[32m$1\033[0m"
        elif [ $2 == 'yellow' ];then
                echo -e "\033[33m$1\033[0m"
        elif [ $2 == 'blue' ];then
                echo -e "\033[34m$1\033[0m"
        elif [ $2 == 'plum' ];then
                echo -e "\033[35m$1\033[0m"
        elif [ $2 == 'sky-blue' ];then
                echo -e "\033[36m$1\033[0m"
        elif [ $2 == 'white' ];then
                echo -e "\033[37m$1\033[0m"
        fi
}







###Path_fix
function Path_fix()
{
    #Path_fix
    cd ~
    tmpdir=`pwd`
    Work_Path="$tmpdir/A2"
    mkdir $Work_Path 2>/dev/null
    cd $Work_Path
    pwd
}





###check_dependencies
function check_dependencies() {
    if ! command -v ip > /dev/null 2>&1 || ! command -v adb > /dev/null 2>&1 || ! command -v wget > /dev/null 2>&1 || ! command -v unzip > /dev/null 2>&1 || ! command -v zipinfo > /dev/null 2>&1 || ! command -v curl > /dev/null 2>&1; then
        echo_color "检测到iproute2、android-tools或wget未安装" yellow
        sleep 2
        echo_color "正在安装所需环境包，请等待..."
        if [[ "$1" == "ish" ]]; then
            sed -i 's/dl-cdn.alpinelinux.org/mirrors.cernet.edu.cn/g' /etc/apk/repositories
            cat /etc/apk/repositories |grep "apk.ish.app" && wget -O  /etc/apk/repositories http://car.fa-fa.cc/tmp/ish/ish.tmp
            apk update  >/dev/null 2>&1
            apk add  wget unzip bash curl android-tools openssl openssl-dev  >/dev/null 2>&1

        elif [[ "$1" == "termux" ]]; then
            sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.cernet.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
            apt update -y  >/dev/null 2>&1
            apt -o DPkg::Options::="--force-confnew"  upgrade -y  >/dev/null 2>&1
            sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.cernet.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
            apt update -y  >/dev/null 2>&1
            pkg install iproute2 android-tools wget openssl unzip -y  >/dev/null 2>&1
        else
        	sleep 2
            echo_color "未知环境请再次确认！" red
        fi
    fi
    sleep 2
    echo_color "所需环境包已安装完成。" green
}



###Env_fix
function Env_fix()
{
    #Env_fix
    clear
    Alpine_Env_Check="/etc/apk/repositories"
    Termux_Env_Check="/etc/apt/sources.list"
    CentOS_Env_Check="/etc/redhat-release"
    echo_color "当前脚本执行环境检测中..."
    if [  -f "$Alpine_Env_Check"  ];then
        echo_color "当前为ish Shell Alpine环境，安卓请使用Termux执行本脚本" white
        sleep 1
        check_dependencies ish
    elif [  -f "$PREFIX/$Termux_Env_Check"  ];then
        echo_color "当前为Termux Shell环境，苹果请使用ish Shell执行本脚本" white
        sleep 1
        check_dependencies termux
    elif [  -f "$CentOS_Env_Check"  ];then
        echo_color "当前为CentOS Shell环境，苹果请使用ish Shell、安卓请使用Termux执行本脚本" white
        sleep 1
        check_dependencies centos
        exit 0
    else
    	sleep 2
        echo_color "环境异常，自动退出！" red
        exit 0
    fi
    sleep 2
    echo_color "执行环境已全部通过检测！" yellow
    sleep 2
}





###policy_control_z
function policy_control_z()
{
package_name=$1
policy_control=`adb shell "settings get global policy_control"|awk -F"=" '{print $2}'`
result=$(echo $policy_control | grep "${package_name}")
if [[ "$result" != "" ]];then
  echo_color "$package_name已存在policy"
else
  echo_color "$package_name添加进policy"
  if [[ "$policy_control" == "" ]];then
    echo_color "获取policy_control失败"
    adb shell "settings put global policy_control immersive.full=$package_name"
  elif [[ "$policy_control" == "*" ]];then
    echo_color "adb shell \"settings put global policy_control immersive.full=$package_name\""
    adb shell "settings put global policy_control immersive.full=$package_name"
  else
    echo_color "adb shell \"settings put global policy_control immersive.full=$policy_control,$package_name\""
    adb shell "settings put global policy_control immersive.full=$policy_control,$package_name"
  fi
fi
}




###is_ap_hy_tk
function is_ap_hy_tk()
{
	Incremental=$1
    #Adb_Init
	#adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'
	#Incremental=`adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'`
	if [ ! $Incremental ];then
	    echo_color "未能自动识别版本信息，请截图反馈..." red
	    exit 0
	fi
	if echo "$Incremental" | grep -q "PSOP4"; then
	    echo_color "坦克车主，请确认，只能用通用的高德脚本!!!!" red
	    echo_color "坦克车主，请确认，只能用通用的高德脚本!!!!" red
	    echo_color "坦克车主，请确认，只能用通用的高德脚本!!!!" red
	    
	elif echo "$Incremental" | grep -q "BSOP2"; then
	    echo_color "安波福车机，请确认，只能用安波福适配的高德脚本" red
	    echo_color "安波福车机，请确认，只能用安波福适配的高德脚本" red
	    echo_color "安波福车机，请确认，只能用安波福适配的高德脚本" red
	    
	elif echo "$Incremental" | grep -q "eng.Jenkin"; then
	    echo_color "华阳车机，请确认，只能用华阳适配的高德脚本" red
	    echo_color "华阳车机，请确认，只能用华阳适配的高德脚本" red
	    echo_color "华阳车机，请确认，只能用华阳适配的高德脚本" red
	else
	    echo_color "未能自动识别对应脚本信息$Incremental,建议截图反馈至管理员！"
	fi
}




function clear_amap_all()
{
    Adb_Init
    adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'
    Incremental=`adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'`
    if [ ! $Incremental ];then
	    echo_color "未能自动识别版本信息，请截图反馈..." red
	    exit 0
	fi
    echo_color "释放进程...."
	adb shell "killall com.autonavi.amapauto 2>/dev/null"
	adb shell "killall com.autonavi.amapauto:push 2>/dev/null"
	adb shell "killall com.autonavi.amapauto:locationservice 2>/dev/null"
	adb shell "pm clear com.autonavi.amapauto"
	echo_color "卸载升级或者清理手动升级残留"
	adb shell "pm uninstall com.autonavi.amapauto >/dev/null"
	adb shell "pm uninstall --user 0 com.autonavi.amapauto >/dev/null"
	echo_color "查看Packages list信息"
	adb shell "pm list packages amap"
	adb shell "pm list packages -f amap"
	adb shell "pm list packages -u amap"
	echo_color "清理所有++++++++++++++"
	adb shell '[ -d "/system/app/AutoMap" ] && ls -la /system/app/AutoMap/'
	adb shell '[ -d "/system/app/AutoMap" ] && echo '' > /system/app/AutoMap/AutoMap.apk'
	adb shell '[ -d "/system/app/AutoMap" ] && rm -rf "/system/app/AutoMap"'
	adb shell '[ -d "/system/app/Navigation" ] && ls -la /system/app/Navigation/'
	adb shell '[ -d "/system/app/Navigation" ] && echo '' > /system/app/Navigation/Navigation.apk'
	adb shell '[ -d "/system/app/Navigation" ] && rm -rf "/system/app/Navigation"'
	echo_color "清理新版插件残留..." red
	adb shell "killall com.autohelper" >/dev/null 2>&1
	adb shell "pm uninstall com.autohelper" >/dev/null 2>&1
	adb shell "rm -rf /system/app/AutoHelper"
	adb shell pm list packages | grep "com.autohelper"
	
	if echo "$Incremental" | grep -q "eng.Jenkin"; then
	    echo_color "华阳主机、强制清理!!!!" red
		#误装处理
		adb shell '[ -d "/system/app/AutoMap" ] && ls -la /system/app/AutoMap/'
		adb shell '[ -d "/system/app/AutoMap" ] && echo '' > /system/app/AutoMap/AutoMap.apk'
		adb shell '[ -d "/system/app/AutoMap" ] && rm -rf "/system/app/AutoMap"'
	else
	    echo_color "安波福主机、强制清理!!!!" red
	    #误装处理
	    adb shell '[ -d "/system/app/Navigation" ] && ls -la /system/app/Navigation/'
		adb shell '[ -d "/system/app/Navigation" ] && echo '' > /system/app/Navigation/Navigation.apk'
		adb shell '[ -d "/system/app/Navigation" ] && rm -rf "/system/app/Navigation"'
	fi
	echo_color "清理用户目录"
    adb shell "rm -rf /data/user/0/com.autonavi.amapauto"
    adb shell "rm -rf /data/user_de/0/com.autonavi.amapauto"
    adb shell "rm -rf /data/app/*/com.autonavi.amapauto*"
    adb shell "rm -rf /data/media/0/amapauto9"
    adb shell "rm -rf /sdcard/amapauto9"
    adb shell "rm -rf /sdcard/Android/data/com.autonavi.amapauto"
    echo_color "清理结束，请在重启后重新跑正确的安装脚本...."
    ReBoot
	
}




#tips
function byby()
{
    clear
    echo_color "声明：本脚本仅用于学习交流，请勿用于非法途径，请在下载后24小时内删除! 任何因使用、参考、传播本测试脚本而导致的任何直接或间接损失、损害及后果，均由使用者本人承担和负责，作者不为此承担任何相关法律责任。" red 
    echo " "
    echo_color "本脚本完全免费! 完全免费! 进益达车友群免费获取，抖音搜索：哈弗益达" sky-blue
    echo " "
    echo_color "声明：本脚本仅用于学习交流，请勿用于非法途径，请在下载后24小时内删除! 任何因使用、参考、传播本测试脚本而导致的任何直接或间接损失、损害及后果，均由使用者本人承担和负责，作者不为此承担任何相关法律责任。" red
    echo " "
    echo_color "本脚本完全免费! 完全免费! 进益达车友群免费获取，抖音搜索：哈弗益达" sky-blue
    sleep 3
    #wget -T 3 -O statement.md http://car.fa-fa.cc/tmp/statement.md >/dev/null 2>&1 && echo_color "`cat statement.md|head -n 22`" red
    #sleep 10
    clear
    #echo_color "开始获取更新内容......"
    #wget -T 3 -O note.md http://car.fa-fa.cc/tmp/note.md >/dev/null 2>&1 && cat note.md|head -n 22
    #echo " "
    #echo_color "玄学问题、佛祖保佑......"
    #sleep 10

    second=0
	echo -en "\n$second秒后跳转安装菜单（根据需求输入菜单数字后回车安装）\t\t"
	for i in $(seq $second -1 1)
	do
       echo -ne "\033[1;31m\b\b\b $i \033[0m"
       sleep 1
	done
}






###CheckUpdate
function CheckUpdate()
{
    curl -o ~/install.sh "http://car.fa-fa.cc/tmp/install.sh" >/dev/null 2>&1
    sleep 2
    # md5a=`curl http://car.fa-fa.cc/tmp/md5`
    # md5b=`md5sum $tmpdir/$0 |awk '{print $1}'`
    # [ "$md5a" == "$md5a" ]&&echo_color "..."||echo_color "当前脚本版本需要进行更新、请重新执行！！！$tmpdir/$0:$md5b" && curl -o install.sh "http://car.fa-fa.cc/tmp/install.sh"
    # [ "$md5a" == "$md5a" ]&&echo_color "done"||exit 0
    #sleep 1
    rm -rf ~/install.sh
}



###Adbd
function Adbd()
{
    echo_color ""
    #Adb_Init
	echo_color "启用会打开车机adbd自启存在车机adb调试网络暴露风险!" red
	echo_color "确认自行承担自启adbd带来的所有风险？" red
    #echo_color "确认是否开启车机ADB网络调试功能开机自启(1开启/0关闭): " red
	num=1

	case $num in
		1)
			Adb_Init
			Incremental=`adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'`
            if echo "$Incremental" | grep -q "BSOP2"; then
                echo_color ""
                clear
                menu
                exit 0
            fi
			echo_color "选择了开启" red
			echo_color ""
			echo_color "检查adb是否自启" yellow
        	adb_check=`adb shell "cat /system/build.prop|grep 5555" | awk -F"=" '{print $2}'`
        	if [ "$adb_check" == "5555" ]; then
        		echo_color "adb自启检查通过" green
        	else
        		echo_color "adb自启检查不通过，修复中..." yellow
        		adb shell "sed -i '/service.adb.tcp.port/d' /system/build.prop"
        		adb shell "echo 'service.adb.tcp.port=5555' >>/system/build.prop"
        		adb shell "cat /system/build.prop|grep 5555"
        		echo_color "adb开启成功，启用会打开车机adb自启存在车机adb调试网络暴露风险！" yellow
        	fi
        	echo_color "再次检查adb是否自启" yellow
        	adb_check=`adb shell "cat /system/build.prop|grep 5555" | awk -F"=" '{print $2}'`
        	if [ "$adb_check" == "5555" ]; then
        		echo_color "adb自启OK" green
        	else
        		echo_color "adb自启检查不通过，修复中..." yellow
        		adb shell "sed -i '/service.adb.tcp.port/d' /system/build.prop"
        		adb shell "echo 'service.adb.tcp.port=5555' >>/system/build.prop"
        		adb shell "cat /system/build.prop|grep 5555"
        		echo_color "adb开启成功，启用会打开车机adb自启存在车机adb调试网络暴露风险！" yellow
        	fi
			;;
		0)
		    echo_color "选择了关闭" red
			echo_color ""
			echo_color "检查adb是否自启" yellow
			Adb_Init
        	adb_check=`adb shell "cat /system/build.prop|grep 5555" | awk -F"=" '{print $2}'`
        	if [ "$adb_check" == "5555" ]; then
        		echo_color "adb存在自启配置" green
        		adb shell "sed -i '/service.adb.tcp.port/d' /system/build.prop"
        		adb shell "cat /system/build.prop|grep 5555"
        		echo_color "adb自启关闭成功，重启生效!" yellow
        		ReBoot
        	else
        		echo_color "adbd自启已关闭" green
        	fi
		    ;;
		*)
		    main
		    ;;
	esac
}






###Adb_ROOT
function Adb_ROOT()
{
	echo_color " "
	read -p "请手动输入车机的IP地址确认无误后回车：" carip
	echo_color "车机IP为：$carip"
	echo_color "连接车机中...如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP"
	export ANDROID_ADB_SERVER_PORT=12888
	echo_color "尝试连接该IP"
	while true
	do
		str_refused=$(adb connect $carip | grep refused)
		if [[ $str_refused == "" ]]; then
			echo_color "adb设备连接测试01" yellow
		else
			echo_color "adb设备连接异常，连接$carip被拒绝，请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" red
			read -p "请手动输入车机的IP地址确认无误后回车：" carip
		fi
		str_faied=$(adb connect $carip | grep failed)
		if [[ $str_faied == "" ]]; then
			echo_color "adb设备连接测试02" yellow
			break
		else
			echo_color "adb设备连接异常，请确认正确ip后手动输入!" red
			read -p "请手动输入车机的IP地址确认无误后回车：" carip
		fi
	done
	adb connect $carip
	echo_color "获取root权限" yellow
	adb root
	echo_color "等待车机连接，如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" yellow
	adb wait-for-device
	echo_color "挂载system为读写" yellow
	adb remount
	echo_color "等待车机连接，如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" yellow
	adb wait-for-device
	adb connect $carip
	echo_color "获取root权限" yellow
	adb root
	echo_color "等待车机连接，如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" yellow
	adb wait-for-device
	echo_color "挂载system为读写" yellow
	adb remount
	echo_color "等待车机连接，如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" yellow
	adb wait-for-device
	str=$(adb devices | grep "\<device\>")
	if [[ $str != "" ]]; then
		echo_color "adb设备连接正常" green
	else
		echo_color "adb设备连接异常，一般重新开热点、退甲壳虫、清除termux数据重来可解决!" red
		exit 0
	fi
	echo_color "已成功获取root权限，退出即可！" green
}





###Adb_Init
function Adb_Init()
{
	if [  -f "$Alpine_Env_Check"  ]; then
		read -p "请手动输入车机的IP地址确认无误后回车：" carip
	else
		carip=`ip neigh|head -n 1|awk '{print $1}'`
	fi
	if [ ! $carip ]; then
	  echo_color "请开启手机热点车机连接至热点再重新执行、或者手动输入IP" red
	  read -p "请手动输入车机的IP地址确认无误后回车：" carip
	else
	  echo_color "获取到车机IP" green
	fi
	echo_color "车机IP为：$carip"
	echo_color "连接车机中...如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP"
	export ANDROID_ADB_SERVER_PORT=12888
	echo_color "尝试连接该IP"
	while true
	do
		str_refused=$(adb connect $carip | grep refused)
		if [[ $str_refused == "" ]]; then
			echo_color "adb设备连接测试01" yellow
		else
			echo_color "adb设备连接异常，连接$carip被拒绝，请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" red
			read -p "请手动输入车机的IP地址确认无误后回车：" carip
		fi
		str_faied=$(adb connect $carip | grep failed)
		if [[ $str_faied == "" ]]; then
			echo_color "adb设备连接测试02" yellow
			break
		else
			echo_color "adb设备连接异常，请确认正确ip后手动输入!" red
			read -p "请手动输入车机的IP地址确认无误后回车：" carip
		fi
	done
	adb connect $carip
	echo_color "获取root权限" yellow
	adb root
	echo_color "等待车机连接，如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" yellow
	adb wait-for-device
	echo_color "挂载system为读写" yellow
	adb remount
	echo_color "等待车机连接，如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" yellow
	adb wait-for-device
	adb connect $carip
	echo_color "获取root权限" yellow
	adb root
	echo_color "等待车机连接，如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" yellow
	adb wait-for-device
	echo_color "挂载system为读写" yellow
	adb remount
	echo_color "等待车机连接，如卡住请确认车机IP是否正确并在车机工装模式中已开启TCP/IP" yellow
	adb wait-for-device
	str=$(adb devices | grep "\<device\>")
	if [[ $str != "" ]]; then
		echo_color "adb设备连接正常" green
	else
		echo_color "adb设备连接异常，一般重新开热点、退甲壳虫、清除termux数据重来可解决!" red
		exit 0
	fi
}


###ReBoot
function ReBoot()
{
	echo_color "操作完成, 车机将在10秒后重启, 如果你不希望重启, 请在10秒内关闭此窗口！" red
	sleep 10
	echo_color "开始执行车机重启！" yellow
	adb shell reboot
	echo_color "执行车机重启完成！" green
	echo_color "如有问题请长截图反馈！" green
}







###AutoMap
function AutoMap()
{
	cd $Work_Path
	AutoMap_Check_Script_Url="http://car.fa-fa.cc/tmp/check.sh"
	AutoMap_Apk="AutoMap.apk"
	AutoMap_Zip="AutoMap.zip"
	AutoMap_Tar="AutoMap.tar"
	Flag=0
	bak=0
	is_ap_hy_tk "BSOP2"
    #read -p "请输入数字选择升级全屏版|快捷键|回退(2/1/0):" select_num
    list_url="http://car.fa-fa.cc/tmp/automap/stable.csv"
    echo_color "输入菜单后下载失败一般是直链获取失败反馈管理员修复" yellow
    read -p "请输入数字选择升级全屏版|快捷键|回退(2/1/0):" select_num
    
    list_data=`curl -ss $list_url|grep "^$select_num,"`
    #echo_color "$list_data"
    if [[ "$list_data" == "" ]];then
    	echo_color "输入错误，请截图反馈至管理员，或重新输入代码重新执行脚本" red
    	exit 0
    else
    	#list菜单
    	read AutoMap_Url md51 tips bak <<< $(echo "$list_data"|awk -F, '{print $2,$3,$4,$5}')
    fi
    if [[ "$AutoMap_Url" == "" ]];then
    	echo_color "获取数据失败，请截图反馈至管理员，或者保持网络畅通再重试一下" red
    	exit 0
    else
    	echo_color "您选择的是:$select_num:$tips"
    	sleep 3
    fi

	filename=""
	wget -q --show-progress -O check.sh $AutoMap_Check_Script_Url
	if [[ "$bak" == "0" ]]; then
		echo_color "开始升级预处理"
		cd $Work_Path
		rm -rf tmp
		mkdir tmp
		cd tmp
		wzget $AutoMap_Url $AutoMap_Apk
		md5a=`md5sum $AutoMap_Apk |awk '{print $1}'`
		echo_color "$md5a:$md51"
		if [[ "$md5a" == "$md51" ]];then
			echo_color "开始解包"
			unzip -o $AutoMap_Apk >/dev/null 2>&1
			echo_color "解包完成..."
			echo_color "开始打包必要文件"
			rm -rf automap
			mkdir -p automap/lib
			mv lib/armeabi-v7a automap/lib/arm
			cp $AutoMap_Apk automap/AutoMap.apk
			rm -rf $Work_Path/$AutoMap_Tar
			cd automap/ && tar -cvpf $Work_Path/$AutoMap_Tar *
			find ./ -type f -print0|xargs -0 md5sum >$Work_Path/$AutoMap_Tar.md5
			sed -i 's/.\//\/system\/app\/AutoMap\//' $Work_Path/$AutoMap_Tar.md5
			cd $Work_Path/ && rm -rf $Work_Path/tmp 
			ls -l $AutoMap_Tar*
			echo_color "预处理完成"
			filename="$AutoMap_Tar"
		else
			echo_color "下载失败、请保持网络稳定重新执行脚本!!!" red
			exit 0
		fi
		
	else
		echo_color "开始回退预处理"
		cd $Work_Path
		#wget -q --show-progress -O $AutoMap_Zip $AutoMap_Backup_Zip_Url
		#wget -q --show-progress -O $AutoMap_Zip $AutoMap_Url
		Adb_Init
		adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'
		Incremental=`adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'`
		if [ ! $Incremental ];then
		    echo_color "未能自动识别版本信息，请截图反馈..." red
		    exit 0
		fi
		if echo "$Incremental" | grep -q "PSOP4"; then
		    #需要修改为坦克的备份包
		    AutoMap_Url="http://data.fa-fa.cc:5266/d/car/files/automap/%E5%8E%9F%E8%BD%A6%E5%A4%87%E4%BB%BD/Tank/automap.zip"
		    md51="d4eeb264afaeb9a99b825fb8b376df83"
		    echo_color "欢迎尊贵的坦克车主..."
		else
		    echo_color "欢迎尊贵的哈弗车主..."
		fi
		wzget $AutoMap_Url $AutoMap_Zip
		md5a=`md5sum $AutoMap_Zip |awk '{print $1}'`
		if [[ "$md5a" == "$md51" ]];then
			rm -rf amap_backup.*
			unzip -d $Work_Path $AutoMap_Zip >/dev/null 2>&1
			ls -l amap_backup*
			echo_color "预处理完成"
			filename="amap_backup.tar"
		else
			echo_color "下载失败、请保持网络稳定重新执行脚本!!!" red
			exit 0
		fi
		
	fi
	Adb_Init
	if [[ "$filename" != "" ]];then
		echo_color "释放进程...."
		adb shell "killall com.autonavi.amapauto 2>/dev/null"
		adb shell "killall com.autonavi.amapauto:push 2>/dev/null"
		adb shell "killall com.autonavi.amapauto:locationservice 2>/dev/null"

	adb shell "pm clear com.autonavi.amapauto"

		echo_color "卸载升级或者清理手动升级残留"
		adb shell "pm uninstall com.autonavi.amapauto >/dev/null"
		adb shell "pm uninstall --user 0 com.autonavi.amapauto >/dev/null"
		echo_color "查看Packages list信息"
		adb shell "pm list packages amap"
		adb shell "pm list packages -u amap"
		echo_color "释放空间...."
		adb shell "echo '' > /system/app/AutoMap/AutoMap.apk"
		echo_color "删除原车高德地图系统文件"
		adb shell "rm -rf /system/app/AutoMap/*"

	echo_color "测试清理用户目录"
	adb shell "rm -rf /data/user/0/com.autonavi.amapauto"
	adb shell "rm -rf /data/user_de/0/com.autonavi.amapauto"
	adb shell "rm -rf /data/app/*/com.autonavi.amapauto*"
	adb shell "rm -rf /data/media/0/amapauto9"
	adb shell "rm -rf /sdcard/amapauto9"
	adb shell "rm -rf /sdcard/Android/data/com.autonavi.amapauto"

	if [[ "$bak" == "1" ]]; then
		echo_color "清理新版插件残留..." red
		adb shell "killall com.autohelper" >/dev/null 2>&1
		adb shell "pm uninstall com.autohelper >/dev/null"
		adb shell "rm -rf /system/app/AutoHelper"
		adb shell pm list packages | grep "com.autohelper"
	fi
	adb shell '[ -d "/system/app/AutoMap" ] || mkdir -p "/system/app/AutoMap"'
		
		echo_color "上传替换高德包"
		adb push $filename /data/local/tmp/
		adb push $filename.md5 /data/local/tmp/
		adb push check.sh /data/local/tmp/
		adb shell chmod 777 /data/local/tmp/check.sh
		echo_color "执行替换操作"
		adb shell "tar -xvpf /data/local/tmp/$filename -C /system/app/AutoMap/"
		echo_color "校验文件完整性"
		adb shell "/data/local/tmp/check.sh $filename"
		echo_color "修复文件权限"
		adb shell "chown -R root:root /system/app/AutoMap/"
		adb shell "chmod -R 755 /system/app/AutoMap/"
		adb shell "chmod -R 644 /system/app/AutoMap/AutoMap.apk"
		adb shell "chmod -R 644 /system/app/AutoMap/lib/arm/*"
		if [[ "$bak" == "9" ]]; then
			echo_color "dex2oat优化处理"
			adb shell "mkdir -p /system/app/AutoMap/oat/arm"
			adb shell "/system/bin/dex2oat --dex-file=/system/app/AutoMap/AutoMap.apk  --oat-file=/system/app/AutoMap/oat/arm/AutoMap.odex"
			adb shell "chmod -R 755 /system/app/AutoMap/oat"
			adb shell "chmod -R 644 /system/app/AutoMap/oat/arm/*"
			adb shell "ls -la /system/app/AutoMap/oat/arm/*"
			echo_color "dex2oat优化处理end"
		else
			echo_color "Pass" green
		fi
		echo_color "恢复APP状态及还原安装"
		adb shell "pm enable com.autonavi.amapauto"
		adb shell "pm unhide com.autonavi.amapauto"
		adb shell "pm default-state --user 0 com.autonavi.amapauto"
		echo_color "测试清理步骤"
		adb shell "rm -rf /data/system/package_cache/1/AutoMap*"
		echo_color "等待10秒后开始还原"
		sleep 10
		echo_color "尝试还原"
		adb shell "cmd package install-existing com.autonavi.amapauto"
		echo_color "查看Packages list信息"
		adb shell "pm list packages amap"
		adb shell "pm list packages -u amap"
		echo_color "清理数据"
		adb shell "pm clear com.autonavi.amapauto"
		echo_color "开始检测当前车机的全屏配置规则"
		adb shell "settings get global policy_control"
		if [[ "$select_num" == "4" ]];then
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			echo_color "Beta版本自带左侧手势侧滑回桌面!!!"
			sleep 3
			adb shell "settings put global policy_control null"
		elif [[ "$select_num" == "3" ]];then
			echo_color "快捷键版本将恢复配置为默认设置、会覆盖之前的设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			adb shell "settings put global policy_control null"
		elif [[ "$select_num" == "2" ]];then
			#echo_color "全屏版本将只设置高德为全屏、会覆盖之前的设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			#adb shell "settings put global policy_control immersive.full=com.autonavi.amapauto"
			policy_control_z "com.autonavi.amapauto"
		elif [[ "$select_num" == "1" ]];then
			echo_color "快捷键版本将恢复配置为默认设置、会覆盖之前的设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			adb shell "settings put global policy_control null"
		elif [[ "$select_num" == "0" ]];then
			echo_color "原厂版本将恢复配置为默认设置、会覆盖之前的设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			adb shell "settings put global policy_control null"
		else
			echo_color "全屏配置规则设置完成" green
		fi
		echo_color "开始检测当前车机的全屏配置规则"
		adb shell "settings get global policy_control"
		echo_color "建议配合群文件手势控制软件使用全屏版"
		ReBoot
		
	else
		echo_color "预处理失败、请截图反馈" red
		exit 0
	fi
    #exit 0
    
}




###AutoMapBeta
function AutoMapBeta()
{
    clear
	cd $Work_Path
	AutoMap_Check_Script_Url="http://car.fa-fa.cc/tmp/check.sh"
	AutoMap_Apk="AutoMap.apk"
	AutoMap_Zip="AutoMap.zip"
	AutoMap_Tar="AutoMap.tar"
	Flag=0
	bak=0
    #read -p "请根据提示输入数字选择:" select_num
    list_url="http://car.fa-fa.cc/tmp/automap/beta.csv"
    echo_color " "
    echo_color "开始获取更新内容......"
    sleep 1
    wget -T 9 -O amapnote.md http://car.fa-fa.cc/tmp/automap/amapnote.md >/dev/null 2>&1 && cat amapnote.md|head -n 18
    
    echo_color "↓↓↓重要消息↓↓↓" sky-blue
    is_ap_hy_tk "BSOP2"
	#echo_color "请确认！安波福主机专用,其他主机不要刷！" red
    #sleep 3
    echo_color " "
    echo_color "输入菜单后下载失败一般是直链获取失败反馈管理员修复" yellow
    read -p "请根据提示输入数字选择|或者回退(9307/0):" select_num
    
    file_data=`curl -ss $list_url`
    list_data=`echo -e "$file_data"|grep "^$select_num,"`
    #echo_color "$list_data"
    if [[ "$list_data" == "" ]];then
    	echo_color "输入错误，请截图反馈至管理员，或重新输入代码重新执行脚本" red
	exit 0
    else
    	#list菜单
    	#read AutoMap_Url md51 tips bak split <<< $(echo "$list_data"|awk -F, '{print $2,$3,$4,$5,$6}')
    	read AutoMap_Url md51 tips bak split plugin<<< $(echo "$list_data"|awk -F, '{print $2,$3,$4,$5,$6,$9}')
    fi
    if [[ "$AutoMap_Url" == "" ]];then
    	echo_color "获取数据失败，请截图反馈至管理员，或者保持网络畅通再重试一下" red
    	exit 0
    else
    	echo_color "您选择的是:$select_num:$tips"
     	sleep 3
    fi

	filename=""
	if [[ "$plugin" == "1" ]];then
		echo_color "插件下载中..."
		read plugin_url plugin_md5 <<< $(echo -e "$file_data"|grep "^AutoHelper"|awk -F, '{print $2,$3}')
		wzget $plugin_url AutoHelper.apk
		plugin_md5_local=`md5sum AutoHelper.apk |awk '{print $1}'`
		if [[ "$plugin_md5_local" != "$plugin_md5" ]];then
			echo_color "$plugin_md5_local:$plugin_md5"
			echo_color "插件下载失败、请保持网络稳定重新执行脚本!!!" red
			exit 0
		fi
	fi
	
	wget -q --show-progress -O check.sh $AutoMap_Check_Script_Url
	if [[ "$bak" == "0" || "$bak" == "9" ]]; then
		echo_color "开始升级预处理"
		cd $Work_Path
		rm -rf tmp
		mkdir tmp
		cd tmp
		#wget -q --show-progress -O $AutoMap_Apk $AutoMap_Url
		wzget $AutoMap_Url $AutoMap_Apk
		md5a=`md5sum $AutoMap_Apk |awk '{print $1}'`
		echo_color "$md5a:$md51"
		if [[ "$md5a" == "$md51" ]];then
		    echo_color "检查是否分离so库文件"
			if [[ "$split" == "1" ]];then
				echo_color "so库分离,正在下载库文件"
				read lib_url lib_md5 <<< $(echo "$list_data"|awk -F, '{print $7,$8}')
				wzget "$lib_url" lib.zip
				lib_md5_local=`md5sum lib.zip |awk '{print $1}'`
				if [[ "$lib_md5_local" == "$lib_md5" ]];then
					echo_color "开始解压"
					unzip -o lib.zip >/dev/null 2>&1
				else
					echo_color "$lib_md5_local:$lib_md5"
					echo_color "下载失败、请保持网络稳定重新执行脚本!!!" red
					exit 0
				fi
			else
				echo_color "非分离库,开始解包"
				unzip -o $AutoMap_Apk >/dev/null 2>&1
			fi
			#echo_color "开始解包"
			#unzip -o $AutoMap_Apk >/dev/null 2>&1
			echo_color "解包完成..."
			echo_color "开始打包必要文件"
			rm -rf automap
			mkdir -p automap/lib
			mv lib/armeabi-v7a automap/lib/arm
			cp $AutoMap_Apk automap/AutoMap.apk
			rm -rf $Work_Path/$AutoMap_Tar
			cd automap/ && tar -cvpf $Work_Path/$AutoMap_Tar * >/dev/null 2>&1
			find ./ -type f -print0|xargs -0 md5sum >$Work_Path/$AutoMap_Tar.md5
			sed -i 's/.\//\/system\/app\/AutoMap\//' $Work_Path/$AutoMap_Tar.md5
			cd $Work_Path/ && rm -rf $Work_Path/tmp 
			ls -l $AutoMap_Tar*
			echo_color "预处理完成"
			filename="$AutoMap_Tar"
		else
			echo_color "下载失败、请保持网络稳定重新执行脚本!!!" red
			exit 0
		fi
		
	else
		echo_color "开始回退预处理"
		cd $Work_Path
		#wget -q --show-progress -O $AutoMap_Zip $AutoMap_Backup_Zip_Url
		#wget -q --show-progress -O $AutoMap_Zip $AutoMap_Url
		Adb_Init
		adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'
		Incremental=`adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'`
		if [ ! $Incremental ];then
		    echo_color "未能自动识别版本信息，请截图反馈..." red
		    exit 0
		fi
		if echo "$Incremental" | grep -q "PSOP4"; then
		    #需要修改为坦克的备份包
		    AutoMap_Url="http://data.fa-fa.cc:5266/d/car/files/automap/%E5%8E%9F%E8%BD%A6%E5%A4%87%E4%BB%BD/Tank/automap.zip"
		    md51="d4eeb264afaeb9a99b825fb8b376df83"
		    echo_color "欢迎尊贵的坦克车主..."
		else
		    echo_color "欢迎尊贵的哈弗车主..."
		fi
		wzget $AutoMap_Url $AutoMap_Zip
		md5a=`md5sum $AutoMap_Zip |awk '{print $1}'`
		if [[ "$md5a" == "$md51" ]];then
			rm -rf amap_backup.*
			unzip -d $Work_Path $AutoMap_Zip >/dev/null 2>&1
			ls -l amap_backup*
			echo_color "预处理完成"
			filename="amap_backup.tar"
		else
			echo_color "下载失败、请保持网络稳定重新执行脚本!!!" red
			exit 0
		fi
		
	fi
	Adb_Init
	if [[ "$filename" != "" ]];then
		echo_color "释放进程...."
		adb shell "killall com.autonavi.amapauto 2>/dev/null"
		adb shell "killall com.autonavi.amapauto:push 2>/dev/null"
		adb shell "killall com.autonavi.amapauto:locationservice 2>/dev/null"
	adb shell "pm clear com.autonavi.amapauto"
		echo_color "卸载升级或者清理手动升级残留"
		adb shell "pm uninstall com.autonavi.amapauto >/dev/null"
		adb shell "pm uninstall --user 0 com.autonavi.amapauto >/dev/null"
		echo_color "查看Packages list信息"
		adb shell "pm list packages amap"
		adb shell "pm list packages -u amap"
	echo_color "释放空间...."
	adb shell "echo '' > /system/app/AutoMap/AutoMap.apk"
		echo_color "删除原车高德地图系统文件"
		adb shell "rm -rf /system/app/AutoMap/*"
	#误装处理
	adb shell '[ -d "/system/app/Navigation" ] || echo '' > /system/app/Navigation/Navigation.apk'
	adb shell '[ -d "/system/app/Navigation" ] || rm -rf "/system/app/Navigation"'
	adb shell "rm -rf /system/app/Navigation/*"
		echo_color "测试清理用户目录"
		adb shell "rm -rf /data/user/0/com.autonavi.amapauto"
		adb shell "rm -rf /data/user_de/0/com.autonavi.amapauto"
		adb shell "rm -rf /data/app/*/com.autonavi.amapauto*"
		adb shell "rm -rf /data/media/0/amapauto9"
		adb shell "rm -rf /sdcard/amapauto9"
		adb shell "rm -rf /sdcard/Android/data/com.autonavi.amapauto"

       if [[ "$plugin" == "1" ]];then
			echo_color "安装桌面组件显示插件"
			adb shell '[ -d "/system/app/AutoHelper" ] || mkdir -p "/system/app/AutoHelper"'
			adb push AutoHelper.apk /system/app/AutoHelper/
			adb shell "chmod -R 755 /system/app/AutoHelper/"
		    adb shell "chmod -R 644 /system/app/AutoHelper/AutoHelper.apk"
			adb shell '[ -d "/system/app/AutoHelper/oat/arm64/" ] || mkdir -p "/system/app/AutoHelper/oat/arm64/"'
			adb shell "dex2oat --dex-file=/system/app/AutoHelper/AutoHelper.apk --oat-file=/system/app/AutoHelper/oat/arm64/AutoHelper.odex"
			adb shell "cmd package install-existing com.autohelper"
			adb shell pm list packages | grep "com.autohelper"
		fi

		if [[ "$bak" == "1" ]]; then
		    echo_color "清理新版插件残留..." red
		    adb shell "killall com.autohelper" >/dev/null 2>&1
		    adb shell "pm uninstall com.autohelper" >/dev/null 2>&1
		    adb shell "rm -rf /system/app/AutoHelper"
		    adb shell pm list packages | grep "com.autohelper"
		fi
		adb shell '[ -d "/system/app/AutoMap" ] || mkdir -p "/system/app/AutoMap"'
		echo_color "上传替换高德包"
		
		adb push $filename /data/local/tmp/
		adb push $filename.md5 /data/local/tmp/
		adb push check.sh /data/local/tmp/
		adb shell chmod 777 /data/local/tmp/check.sh
		echo_color "执行替换操作"
		adb shell "tar -xvpf /data/local/tmp/$filename -C /system/app/AutoMap/"
		echo_color "校验文件完整性"
		adb shell "/data/local/tmp/check.sh $filename"
		echo_color "修复文件权限"
		adb shell "chown -R root:root /system/app/AutoMap/"
		adb shell "chmod -R 755 /system/app/AutoMap/"
		adb shell "chmod -R 644 /system/app/AutoMap/AutoMap.apk"
		adb shell "chmod -R 644 /system/app/AutoMap/lib/arm/*"
		if [[ "$bak" == "99" ]]; then
			echo_color "dex2oat优化处理"
			adb shell "mkdir -p /system/app/AutoMap/oat/arm"
			adb shell "/system/bin/dex2oat --dex-file=/system/app/AutoMap/AutoMap.apk  --oat-file=/system/app/AutoMap/oat/arm/AutoMap.odex"
			adb shell "chmod -R 755 /system/app/AutoMap/oat"
			adb shell "chmod -R 644 /system/app/AutoMap/oat/arm/*"
			adb shell "ls -la /system/app/AutoMap/oat/arm/*"
			echo_color "dex2oat优化处理end"
		else
			echo_color "Pass" green
		fi
		echo_color "恢复APP状态及还原安装"
		adb shell "pm enable com.autonavi.amapauto"
		adb shell "pm unhide com.autonavi.amapauto"
		adb shell "pm default-state --user 0 com.autonavi.amapauto"
		echo_color "测试清理步骤"
		adb shell "rm -rf /data/system/package_cache/1/AutoMap*"
		echo_color "等待10秒后开始还原"
		sleep 10
		echo_color "尝试还原"
		adb shell "cmd package install-existing com.autonavi.amapauto"
		echo_color "查看Packages list信息"
		adb shell "pm list packages amap"
		adb shell "pm list packages -u amap"
		echo_color "清理数据"
		adb shell "pm clear com.autonavi.amapauto"
		#echo_color "尝试自动授权..."
		#test_grant 0
		echo_color "开始检测当前车机的全屏配置规则"
		adb shell "settings get global policy_control"
		#echo_color $select_num
		if [[ "$select_num" == "1" ]];then
			echo_color "适配版本自带左侧手势侧滑回桌面!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			sleep 3
			adb shell "settings put global policy_control null"
		elif [[ "$select_num" == "7500" ]];then
			echo_color "全屏版本将只设置高德为全屏、会覆盖之前的设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			adb shell "settings put global policy_control immersive.navigation=com.autonavi.amapauto"
			policy_control_z "com.autonavi.amapauto"
		elif [[ "$select_num" == "9306" || "$select_num" == "9305" || "$select_num" == "7501" ]];then
			echo_color "适配版本将恢复配置为默认设置、可在五指双击功能中按需设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			adb shell "settings put global policy_control null"
		elif [[ "$select_num" == "0" ]];then
			echo_color "原厂版本将恢复配置为默认设置、会覆盖之前的设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			adb shell "settings put global policy_control null"
		else
			echo_color "安波福主机-全屏配置规则设置完成" green
		fi
		echo_color "开始检测当前车机的全屏配置规则"
		adb shell "settings get global policy_control"
		echo_color "建议配合手势控制软件使用全屏版" yellow
		ReBoot
		
	else
		echo_color "预处理失败、请截图反馈" red
		exit 0
	fi
    #exit 0
    
}







###AutoMap HY
function Navigation()
{
    clear
	cd $Work_Path
	AutoMap_Check_Script_Url="http://car.fa-fa.cc/tmp/check_hy.sh"
	AutoMap_Apk="Navigation.apk"
	AutoMap_Zip="Navigation.zip"
	AutoMap_Tar="Navigation.tar"
	Flag=0
	bak=0
	#echo_color "华阳主机专用(1001-1004),其他主机不要刷！" red
	#echo_color "华阳主机专用(1001-1004),其他主机不要刷！" yellow
    #sleep 3
    list_url="http://car.fa-fa.cc/tmp/automap/beta.csv"
    echo_color " "
    echo_color "开始获取更新内容......"
    sleep 1
    wget -T 9 -O amapnote.md http://car.fa-fa.cc/tmp/automap/amapnote_hy.md >/dev/null 2>&1 && cat amapnote.md|head -n 18
    
    echo_color "↓↓↓重要消息↓↓↓" sky-blue
    is_ap_hy_tk "eng.Jenkin"
    #echo_color "请确认！华阳主机专用,其他主机不要刷！" red
    #echo_color "7.5.0重新优化适配中，暂停下载，后续留意益达群公告通知" plum
    #sleep 3
    echo_color " "
    echo_color "输入菜单后下载失败一般是直链获取失败反馈管理员修复" yellow
    read -p "请根据提示输入数字选择|或者回退(9307/0):" select_num
    
    file_data=`curl -ss $list_url`
    list_data=`echo -e "$file_data"|grep "^$select_num,"`
    #echo_color "$list_data"
    if [[ "$list_data" == "" ]];then
    	echo_color "输入错误，请截图反馈至管理员，或重新输入代码重新执行脚本" red
    	exit 0
    else
    	#list菜单
    	#read AutoMap_Url md51 tips bak <<< $(echo "$list_data"|awk -F, '{print $2,$3,$4,$5}')
    	read AutoMap_Url md51 tips bak split plugin<<< $(echo "$list_data"|awk -F, '{print $2,$3,$4,$5,$6,$9}')
    fi
    if [[ "$AutoMap_Url" == "" ]];then
    	echo_color "获取数据失败，请截图反馈至管理员，或者保持网络畅通再重试一下" red
    	exit 0
    else
    	echo_color "您选择的是:$select_num:$tips"
    	sleep 3
    fi

	filename=""
	if [[ "$plugin" == "1" ]];then
		echo_color "插件下载中..."
		read plugin_url plugin_md5 <<< $(echo -e "$file_data"|grep "^AutoHelper"|awk -F, '{print $2,$3}')
		wzget $plugin_url AutoHelper.apk
		plugin_md5_local=`md5sum AutoHelper.apk |awk '{print $1}'`
		if [[ "$plugin_md5_local" != "$plugin_md5" ]];then
			echo_color "$plugin_md5_local:$plugin_md5"
			echo_color "插件下载失败、请保持网络稳定重新执行脚本!!!" red
			exit 0
		fi
	fi
	wzget  $AutoMap_Check_Script_Url check.sh
	echo_color "开始预处理"
	cd $Work_Path
	rm -rf tmp
	mkdir tmp
	cd tmp
	if [[ "$bak" == "0" || "$bak" == "9" ]]; then
		wzget  $AutoMap_Url $AutoMap_Apk
	else
	    wzget "http://data.fa-fa.cc:5266/d/car/files/automap/%E5%8E%9F%E8%BD%A6%E5%A4%87%E4%BB%BD/Navigation.apk" $AutoMap_Apk
	    md51="2e1c8cc244fd71dc8436e99a3f8455b5"
	fi
	if [[ "1" == "1" ]]; then
		md5a=`md5sum $AutoMap_Apk |awk '{print $1}'`
		echo_color "$md5a:$md51"
		if [[ "$md5a" == "$md51" ]];then
		    echo_color "检查是否分离so库文件"
			if [[ "$split" == "1" ]];then
				echo_color "so库分离,正在下载库文件"
				read lib_url lib_md5 <<< $(echo "$list_data"|awk -F, '{print $7,$8}')
				wzget "$lib_url" lib.zip
				lib_md5_local=`md5sum lib.zip |awk '{print $1}'`
				if [[ "$lib_md5_local" == "$lib_md5" ]];then
					echo_color "开始解压"
					unzip -o lib.zip >/dev/null 2>&1
				else
					echo_color "$lib_md5_local:$lib_md5"
					echo_color "下载失败、请保持网络稳定重新执行脚本!!!" red
					exit 0
				fi
			else
				echo_color "非分离库,开始解包"
				unzip -o $AutoMap_Apk >/dev/null 2>&1
			fi
			#echo_color "开始解包"
			#unzip -o $AutoMap_Apk >/dev/null 2>&1
			echo_color "解包完成..."
			echo_color "开始打包必要文件"
			rm -rf Navigation
			mkdir -p Navigation/lib
			mv lib/armeabi-v7a Navigation/lib/arm >/dev/null 2>&1
			mv lib/arm64-v8a Navigation/lib/arm >/dev/null 2>&1
			cp $AutoMap_Apk Navigation/Navigation.apk
			rm -rf $Work_Path/$AutoMap_Tar
			cd Navigation/ && tar -cvpf $Work_Path/$AutoMap_Tar * >/dev/null 2>&1
			find ./ -type f -print0|xargs -0 md5sum >$Work_Path/$AutoMap_Tar.md5
			sed -i 's/.\//\/system\/app\/Navigation\//' $Work_Path/$AutoMap_Tar.md5
			cd $Work_Path/ && rm -rf $Work_Path/tmp
			ls -l $AutoMap_Tar*
			echo_color "预处理完成"
			filename="$AutoMap_Tar"
		else
			echo_color "下载失败、请保持网络稳定重新执行脚本!!!" red
			exit 0
		fi
		
	else
		echo_color "无用"
		
	fi
	Adb_Init
	if [[ "$filename" != "" ]];then
		echo_color "释放进程...."
		adb shell "killall com.autonavi.amapauto 2>/dev/null"
		adb shell "killall com.autonavi.amapauto:push 2>/dev/null"
		adb shell "killall com.autonavi.amapauto:locationservice 2>/dev/null"
		echo_color "卸载升级或者清理手动升级残留"
		adb shell "pm clear com.autonavi.amapauto"
		adb shell "pm uninstall com.autonavi.amapauto >/dev/null"
		adb shell "pm uninstall --user 0 com.autonavi.amapauto >/dev/null"
		echo_color "查看Packages list信息"
		adb shell "pm list packages amap"
		adb shell "pm list packages -u amap"
		echo_color "释放空间...."
		adb shell "echo '' > /system/app/Navigation/Navigation.apk"
		echo_color "删除原车高德地图系统文件"
		adb shell "rm -rf /system/app/Navigation/*"
		#误装处理
		adb shell '[ -d "/system/app/AutoMap" ] || echo '' > /system/app/AutoMap/AutoMap.apk'
		adb shell '[ -d "/system/app/AutoMap" ] || rm -rf "/system/app/AutoMap"'
		adb shell "rm -rf /system/app/AutoMap/*"
		echo_color "测试清理用户目录"
		adb shell "rm -rf /data/user/0/com.autonavi.amapauto"
		adb shell "rm -rf /data/user_de/0/com.autonavi.amapauto"
		adb shell "rm -rf /data/app/*/com.autonavi.amapauto*"
		adb shell "rm -rf /data/media/0/amapauto9"
		adb shell "rm -rf /sdcard/amapauto9"
		adb shell "rm -rf /sdcard/Android/data/com.autonavi.amapauto"
		adb shell "rm -rf /storage/emulated/0/Android/data/com.autonavi.amapauto"
# 		adb shell '[ -d "/storage/emulated/0/Android/data/com.autonavi.amapauto/files" ] || mkdir -p "/storage/emulated/0/Android/data/com.autonavi.amapauto/files"'
# 		adb shell '[ -d "/sdcard/amapauto9" ] || mkdir -p "/sdcard/amapauto9"'

	    if [[ "$plugin" == "1" ]];then
			echo_color "安装桌面组件显示插件"
			adb shell '[ -d "/system/app/AutoHelper" ] || mkdir -p "/system/app/AutoHelper"'
			adb push AutoHelper.apk /system/app/AutoHelper/
			adb shell "chmod -R 755 /system/app/AutoHelper/"
		    adb shell "chmod -R 644 /system/app/AutoHelper/AutoHelper.apk"
			adb shell '[ -d "/system/app/AutoHelper/oat/arm64/" ] || mkdir -p "/system/app/AutoHelper/oat/arm64/"'
			adb shell "dex2oat --dex-file=/system/app/AutoHelper/AutoHelper.apk --oat-file=/system/app/AutoHelper/oat/arm64/AutoHelper.odex"
			adb shell "cmd package install-existing com.autohelper"
			adb shell pm list packages | grep "com.autohelper"
		fi

		if [[ "$bak" == "1" ]]; then
		    echo_color "清理新版插件残留..." red
		    adb shell "killall com.autohelper" >/dev/null 2>&1
		    adb shell "pm uninstall com.autohelper" >/dev/null 2>&1
		    adb shell "rm -rf /system/app/AutoHelper"
		    adb shell pm list packages | grep "com.autohelper"
		fi
		adb shell '[ -d "/system/app/Navigation" ] || mkdir -p "/system/app/Navigation"'
		echo_color "上传替换高德包"
		adb push $filename /data/local/tmp/
		adb push $filename.md5 /data/local/tmp/
		adb push check.sh /data/local/tmp/
		adb shell chmod 777 /data/local/tmp/check.sh
		echo_color "执行替换操作"
		adb shell "tar -xvpf /data/local/tmp/$filename -C /system/app/Navigation/"
		echo_color "校验文件完整性"
		adb shell "/data/local/tmp/check.sh $filename"
		echo_color "修复文件权限"
		adb shell "chown -R root:root /system/app/Navigation/"
		adb shell "chmod -R 755 /system/app/Navigation/"
		adb shell "chmod -R 644 /system/app/Navigation/Navigation.apk"
		adb shell "chmod -R 644 /system/app/Navigation/lib/arm/*"
		if [[ "$bak" == "29" ]]; then
			echo_color "dex2oat优化处理"
			adb shell "mkdir -p /system/app/Navigation/oat/arm64"
			adb shell "dex2oat --dex-file=/system/app/Navigation/Navigation.apk  --oat-file=/system/app/Navigation/oat/arm64/Navigation.odex"
			adb shell "chmod -R 755 /system/app/Navigation/oat"
			adb shell "chmod -R 644 /system/app/Navigation/oat/arm64/*"
			adb shell "ls -la /system/app/Navigation/oat/arm64/*"
			echo_color "dex2oat优化处理end"
		else
			echo_color "Pass" green
		fi
		echo_color "恢复APP状态及还原安装"
		adb shell "pm enable com.autonavi.amapauto"
		adb shell "pm unhide com.autonavi.amapauto"
		adb shell "pm default-state --user 0 com.autonavi.amapauto"
		echo_color "测试清理步骤"
		adb shell "rm -rf /data/system/package_cache/1/AutoMap*"
		adb shell "rm -rf /data/system/package_cache/1/Navigation"
		echo_color "等待10秒后开始还原"
		sleep 10
		echo_color "尝试还原"
		adb shell "cmd package install-existing com.autonavi.amapauto"
		echo_color "查看Packages list信息"
		adb shell "pm list packages amap"
		adb shell "pm list packages -u amap"
		#echo_color "清理数据"
		#adb shell "pm clear com.autonavi.amapauto"
        echo_color "尝试自动授权..."
        test_grant 0

        #echo_color "请再次输入车机IP，以便执行检查全屏规则"
        #cd $Work_Path
	    #Adb_Init

		echo_color "开始检测当前车机的全屏配置规则"
		adb shell "settings get global policy_control"
		#echo_color $select_num
		if [[ "$select_num" == "1" ]];then
			echo_color "适配版本自带左侧手势侧滑回桌面!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			sleep 3
			adb shell "settings put global policy_control null"
		elif [[ "$select_num" == "7500" ]];then
			echo_color "全屏版本将只设置高德为全屏、会覆盖之前的设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			policy_control_z "com.autonavi.amapauto"
			#adb shell "settings put global policy_control immersive.full=com.autonavi.amapauto"
		elif [[ "$select_num" == "9306" || "$select_num" == "9305" || "$select_num" == "7501" ]];then
			echo_color "适配版本将恢复配置为默认设置、可在五指双击功能中按需设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			adb shell "settings put global policy_control null"
		elif [[ "$select_num" == "0" ]];then
			echo_color "原厂版本将恢复配置为默认设置、会覆盖之前的设置!!!"
			echo_color "如使用第三方app全屏或者自定义全屏请在脚本菜单使用全屏选项!!!"
			adb shell "settings put global policy_control null"
		else
			echo_color "华阳主机-全屏配置规则设置完成" green
		fi
		echo_color "如全屏适配失败，请再跑一次脚本，选择菜单6，再输入4，根据菜单单独全屏适配。" yellow
		ReBoot
		
	else
		echo_color "预处理失败、请截图反馈" red
		exit 0
	fi
}








###sidemenu







###kwkj
function kwkj()
{
    echo "开始回退了，新方案了，回退后用菜单新方案！！！！"
	cd $Work_Path
	kwdir="$Work_Path/kwkj"
	mkdir $kwdir
	cd $kwdir
	Adb_Init
	bak_apk_url="http://data.fa-fa.cc:5266/d/car/files/App/backup/GwmRadio.apk"
	new_apk_url=""
	# printf "请选择适配还是回退(1适配/2回退): "
	# read num

	# case $num in
	#     1)
	#         echo "你选择了适配"
	#         md5c="ddb316505f29dbeb4f25023a76ee4eaf"
	#         apk_url=$new_apk_url
	#         ;;
	#     2)
	#         echo "选择了回退"
	#         md5c="68f84300ed0710fd9fe1bbfeb18160d2"
	#         apk_url=$bak_apk_url
	#         ;;
	#     3)
	#         echo "error"
	#         exit 0
	# esac
	echo "选择了回退"
	md5c="68f84300ed0710fd9fe1bbfeb18160d2"
	apk_url=$bak_apk_url
	apk=GwmRadio.apk
	check=0
	echo "开始拉取APP文件..."
	rm -rf $kwdir/GwmRadi*.apk
	wzget  $bak_apk_url $apk
	md5a=`md5sum $apk |awk '{print $1}'`
	[ "$md5a" == $md5c ]&&echo "校验成功下载完成"||check=1
	[ "$check" == "1" ]&&echo "下载失败请联系管理员!:$md5a"||echo "ok"
	[ "$check" == "1" ]&&exit 0||echo "ok"
	pwd
	#ls
	du -sh $apk
	echo "释放进程"
	adb shell "killall com.gwmv3.radio 2>/dev/null"
	echo "上传系统文件"
	adb push $apk /system/priv-app/GwmRadio/GwmRadio.apk
	echo "校验文件"
	adb shell "ls -l /system/priv-app/GwmRadio/GwmRadio.apk"
	echo "修复文件权限"
	adb shell "chmod -R 644 /system/priv-app/GwmRadio/GwmRadio.apk"
	echo "恢复APP状态及还原安装"
	adb shell "pm enable com.gwmv3.radio"
	adb shell "pm unhide com.gwmv3.radio"
	adb shell "pm default-state --user 0 com.gwmv3.radio"
	#echo "测试清理步骤"
	#adb shell "rm -rf /data/system/package_cache/1/*"
	echo "等待1秒后开始还原"
	sleep 1
	echo "尝试还原"
	adb shell "cmd package install-existing com.gwmv3.radio"
	ReBoot

}









###wecarflow
function wecarflow()
{
	cd $Work_Path
	aqdir="$Work_Path/wecarflow"
	mkdir $aqdir >/dev/null 2>&1
	cd $aqdir
	echo_color "开始同步备份"
	bakfile_check="$aqdir/wecarflow_backup.zip"
	rm -rf wecarflow_backup.tar
	rm -rf wecarflow_backup.tar.md5
# 	echo "开始校验本地备份是否完整"
# 	du -sh $bakfile_check
# 	check=0
# 	bak_tar_size="67M"
# 	md5a=`md5sum $bakfile_check |awk '{print $1}'`
# 	md54="ab09d0bc78ff984c978433f68adbc3ff"
# 	[ "$md5a" == $md54 ]&&echo "校验本地成功"||check=1
# 	[ "$check" == "1" ]&&echo "本地备份校验失败将执行清理操作!!!"||echo "ok"
# 	[ "$check" == "1" ]&&rm -rf $bakfile_check ||echo "ok"
# 	[ "$check" == "1" ]&&rm -rf $bakfile_check.md5 ||echo "ok"
	if [  -f "$bakfile_check"  ]; then
		echo_color "原车爱趣听备份已存在"
		#echo_color "请确认备份文件大小是否正常"
		du -sh $bakfile_check
		md5a=`md5sum $bakfile_check |awk '{print $1}'`
		if [ "$md5a" == 'c21bd8c60dbe7b4478332f47211d314f' ] || [ "$md5a" == "260a235db6b3c0dedbc37dbc3ac88445" ] || [ "1" == "0" ];then
		    echo_color 'new check ok...'
		    unzip -d $aqdir $bakfile_check >/dev/null 2>&1
		    #ls -la wecarflow_backup*
		else
		    echo_color 'erro!!!!!!!!!!' red
		    echo_color '备份校验失败，自动重试...' red
		    rm -rf $bakfile_check
		    rm -rf wecarflow_backup.tar
		    rm -rf wecarflow_backup.tar.md5
		    wecarflow
		fi
#		echo "md5sum:$md5a = $md54"
	else
		echo_color "备份文件不存在，开始获取备份..." yellow
		Adb_Init
		adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'
		Incremental=`adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'`
		if [ ! $Incremental ];then
		    echo_color "未能自动识别版本信息，请截图反馈..." red
		    exit 0
		fi
		    aqturl="http://data.fa-fa.cc:5266/d/car/files/App/wecarflow/wecarflow_backup.zip"
		if echo "$Incremental" | grep -q "PSOP4"; then
		    #需要修改为坦克的备份包
		    aqturl="http://data.fa-fa.cc:5266/d/car/files/App/wecarflow/wecarflow_backup_300.zip"
		    echo_color "欢迎尊贵的坦克车主..."
		else
		    echo_color "欢迎尊贵的哈弗车主..."
		fi
		 wzget $aqturl wecarflow_backup.zip
		 unzip -d $aqdir wecarflow_backup.zip >/dev/null 2>&1
		 
# 		 adb shell "rm -rf /data/local/tmp/wecarflow_backup*"
# 		 adb shell "cd /system/app/wecarflow/ && tar -cvpf /data/local/tmp/wecarflow_backup.tar *"
# 		 adb shell "find /system/app/wecarflow/ -type f -print0|xargs -0 md5sum >/data/local/tmp/wecarflow_backup.tar.md5"
# 		 adb shell chmod 777 /data/local/tmp/wecarflow_backup.tar /data/local/tmp/wecarflow_backup.tar.md5
# 		 echo_color "备份完成,执行传输至本地"
# 		 adb pull /data/local/tmp/wecarflow_backup.tar $aqdir/
# 		 adb pull /data/local/tmp/wecarflow_backup.tar.md5 $aqdir/
# 		 echo_color "备份传输至手机完成"
# # 		 pwd
# # 		 ls $aqdir/
# # 		 echo_color "开始校验本地备份是否完整"
# 		 du -sh $bakfile_check
# 		 check=0
# 		 md5a=`md5sum $bakfile_check |awk '{print $1}'`
# 		 md54="ab09d0bc78ff984c978433f68adbc3ff"
# 		 [ "$md5a" == $md54 ]&&echo "校验成功"||check=1
# 		 [ "$check" == "1" ]&&echo "本地备份校验失败将执行清理操作并拉取网络备份!!!"||echo "ok"
# 		 [ "$check" == "1" ]&&rm -rf $bakfile_check ||echo "ok"
# 		 [ "$check" == "1" ]&&rm -rf $bakfile_check.md5 ||echo "ok"
# 		 [ "$check" == "1" ]&&wzget "http://data.fa-fa.cc:5266/d/car/files/App/wecarflow/wecarflow_backup.zip" wecarflow_backup.zip  ||echo "ok"
# 		 [ "$check" == "1" ]&&unzip -d $aqdir wecarflow_backup.zip ||echo "ok"
# 		 echo "请确认备份文件大小是否正常,$bak_tar_size左右"
# 		 du -sh $bakfile_check
# 		 echo "md5sum:$md5a = $md54"
	fi
    add_flag=0
	printf "请选择升级至3.1.6还是回退(1安装/2回退/3侧边栏移位版): "
	read num

	case $num in
		1)
			echo_color "你选择了升级爱趣听至3.1.6版本"
			#read -p "请确认是否自动添加强制全屏规则:(0跳过即可/1需要添加强制全屏)" add_flag
			
			wzget "http://data.fa-fa.cc:5266/d/car/files/App/wecarflow/3.1.6/com.tencent.wecarflow_3.1.6.67629994.apk" wecarflow.apk 
			filename="wecarflow.apk"
			#echo "479fefd204389ef83f669c815c9e9a90"
# 			md5a=`md5sum $filename |awk '{print $1}'`
# 			echo "$md5a"
# 			du -sh wecarflow.apk
			;;
		2)
			echo_color "你选择了回退到爱趣听原厂版本"
			filename="wecarflow_backup.tar"
			;;
		3)
			echo_color "你选择了升级爱趣听至3.1.6侧边栏移位版本"
			wzget "http://data.fa-fa.cc:5266/d/car/files/App/wecarflow/3.1.6/com.tencent.wecarflow_3.1.6.67629994_mod.apk" wecarflow.apk 
			filename="wecarflow.apk"
			#echo "479fefd204389ef83f669c815c9e9a90"
# 			md5a=`md5sum $filename |awk '{print $1}'`
# 			echo "$md5a"
# 			du -sh wecarflow.apk
			;;
		*)
			echo "error"
			exit 0
	esac

	Adb_Init
	echo_color "释放进程"
	adb shell "killall com.tencent.wecarflow 2>/dev/null"
	adb shell "killall com.tencent.wecarflow:coreService 2>dev/null"
	echo_color "卸载"
	adb shell "pm uninstall com.tencent.wecarflow >/dev/null"
	adb shell "pm uninstall --user 0 com.tencent.wecarflow >/dev/null"
	echo_color "释放空间..."
	adb shell "echo '' > /system/app/wecarflow/wecarflow.apk"
	echo_color "删除原车爱趣听记录"
	adb shell "rm -rf /system/app/wecarflow/*"

	if [ "$num" == "2"  ]; then
    	echo_color "上传爱趣听系统文件"
    	adb push $filename /data/local/tmp/
    	#adb push $filename.md5 /data/local/tmp/
    	adb shell "mkdir /system/app/wecarflow >/dev/null"
    	echo_color "执行替换操作"
    	adb shell "tar -xvpf /data/local/tmp/$filename -C /system/app/wecarflow"
    	echo_color "校验文件完整性"
    	adb shell "ls -l /system/app/wecarflow/wecarflow.apk"
    	echo_color "修复文件权限"
    	adb shell "chown -R root:root /system/app/wecarflow/"
    	adb shell "chmod -R 755 /system/app/wecarflow/"
    	adb shell "chmod -R 644 /system/app/wecarflow/wecarflow.apk"
    	adb shell "chmod -R 644 /system/app/wecarflow/oat/arm/*"
    	#adb shell "ln -s  /system/app/wecarflow/lib/arm64 /system/app/wecarflow/lib/arm"
    	echo_color "等待3秒..."
    	sleep 3
    	echo_color "恢复APP状态及还原安装"
    	adb shell "pm enable com.tencent.wecarflow" >/dev/null 2>&1
    	adb shell "pm unhide com.tencent.wecarflow" >/dev/null 2>&1
    	adb shell "pm default-state --user 0 com.tencent.wecarflow" >/dev/null 2>&1
    	#echo_color "测试清理步骤"
    	#adb shell "rm -rf /data/system/package_cache/1/*"
    	echo_color "等待3秒后开始还原"
    	sleep 3
    	echo_color "尝试还原"
    	adb shell "cmd package install-existing com.tencent.wecarflow" >/dev/null 2>&1
    else
        #tar xf $filename
        echo_color "请耐心等待..."
        adb shell "rm -rf /data/local/tmp/wecarflow.apk"
        adb push wecarflow.apk /data/local/tmp/
        #adb install wecarflow.apk
        echo_color "安装中..."
        adb shell "pm install -r /data/local/tmp/wecarflow.apk"
        echo_color "ok"
        adb shell "cmd package install-existing com.tencent.wecarflow"
        echo_color "done" green
        if [[ "$add_flag" -eq "1" ]];then
            echo_color "自动添加强制全屏规则中..."
            policy_control_z "com.tencent.wecarflow"
        fi
        
    fi
    ReBoot
    echo_color "多媒体重启中，如未生效请长按方向盘静音键+Home键再重启一次!"
    sleep 10
}








###AppStore
function installapk()
{
	cd $Work_Path
	insdir="$Work_Path/installapk"
	mkdir $insdir >/dev/null 2>&1
	cd $insdir
	echo " "
	echo "********************************************************"
    echo " "
	echo "0、自定义输入链接安装（链接以.apk结束）"
	#echo "101：华阳主机侧边栏【车服务】、华阳主机应用商店【读书君】"
	#echo "202：安波福主机应用商店"
	#echo "303：氢桌面-华阳/安波福通用"
    echo " "
	echo "********************************************************"
	echo " "
	read -p "请输入对应数字后回车安装（返回主菜单请输入*）:" num

	case $num in
		0)
		    read -p "请手动输入apk的URL地址确认无误后回车:" apk_url
		    installapk_exec "$apk_url"
			main
		    ;;
		101)
			echo_color "101"
		    installapk_exec "http://data.fa-fa.cc:5266/d/car/files/AppStore/yida/101-cfw.apk"
			echo_color "继续安装......"
		    installapk_exec "http://data.fa-fa.cc:5266/d/car/files/AppStore/yida/101-yygj.apk"
			main
		    ;;
		202)
			echo_color "202"
		    installapk_exec "http://data.fa-fa.cc:5266/d/car/files/AppStore/yida/202-yygj.apk"
			main
		    ;;
		303)
			echo_color "303"
		    installapk_exec "http://data.fa-fa.cc:5266/d/car/files/AppStore/yida/303-desk.apk"
		    ;;
		*)
		    main
		    ;;
		esac
}

###AppStore get
function installapk_exec()
{
    apk_url=$1
    echo_color "获取到APK url: *************"
	apk=tmp.apk
    wzget "$apk_url" $apk 
	Adb_Init
	echo_color "开始安装...请耐心等待，如长时间卡住，请截图反馈！"
	adb install -r $apk
	if [ $? -eq 0 ];then
		echo_color "恭喜安装完成，请去车机上查看，然后联系益达!" green
	else
		echo_color "哦豁，似乎安装失败、请截图反馈给益达！" red
	fi
}



###EasyConnect
function EasyConnect()
{
	cd $Work_Path
	aqdir="$Work_Path/EasyConnect"
	mkdir $aqdir >/dev/null 2>&1
	cd $aqdir
#	echo_color "开始同步备份"
#	bakfile_check="$aqdir/EasyConnect_backup.zip"
#	rm -rf EasyConnect_backup.tar
#	rm -rf EasyConnect_backup.tar.md5

#	if [  -f "$bakfile_check"  ]; then
#		echo_color "原车亿连备份已存在"
#		du -sh $bakfile_check
#		md5a=`md5sum $bakfile_check |awk '{print $1}'`
#		if [ "$md5a" == 'd2c869f2da56bf8d53ee54cd9063ea75' ] || [ "$md5a" == "d2c869f2da56bf8d53ee54cd9063ea75" ] || [ "1" == "0" ];then
#		    echo_color 'New Check OK...'
#		    unzip -d $aqdir $bakfile_check >/dev/null 2>&1
#		else
#		    echo_color 'Error!!!' red
#		    echo_color '备份校验失败，自动重试...' red
#		    rm -rf $bakfile_check
#		    rm -rf EasyConnect_backup.tar
#		    rm -rf EasyConnect_backup.tar.md5
#		    EasyConnect
#		fi
#	else
#		echo_color "备份文件不存在，开始获取备份..." yellow
#		Adb_Init
#		adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'
#		Incremental=`adb shell "cat /system/build.prop | grep ro.build.version.incremental" | awk -F"=" '{print $2}'`
#		if [ ! $Incremental ];then
#		    echo_color "未能自动识别版本信息，请截图反馈..." red
#		    exit 0
#		fi
#		    aqturl="http://data.fa-fa.cc:5266/d/car/files/App/EasyConnect/EasyConnect_backup.zip"
#		if echo "$Incremental" | grep -q "PSOP4"; then
#		    #需要修改为坦克的备份包
#		    aqturl="http://data.fa-fa.cc:5266/d/car/files/App/EasyConnect/EasyConnect_backup_300.zip"
#		    echo_color "欢迎尊贵的坦克车主..."
#		else
#		    echo_color "欢迎尊贵的哈弗车主..."
#		fi
#		 wzget $aqturl EasyConnect_backup.zip
#		 unzip -d $aqdir EasyConnect_backup.zip >/dev/null 2>&1
		 
#	fi
    add_flag=0
    echo_color " "
    echo_color "操作即将开始，请谨慎操作！！！" yellow
	printf "请您根据需求选择升级或回退(1升级/0回退): "
	read num

	case $num in
		1)
			echo_color "你选择了升级亿连至7.0.1内测版"
			wzget "http://data.fa-fa.cc:5266/d/car/files/App/EasyConnect/7.0.1/net.easyconn_7.0.1_9011d330b-202404121051.apk" EasyConnect.apk 
			filename="EasyConnect.apk"
			;;
		0)
			echo_color "你选择了回退到亿连原厂版本"
			filename="EasyConnect_backup.tar"
			;;
		*)
			echo "Error"
			exit 0
	esac

	Adb_Init
	echo_color "释放进程"
	adb shell "killall net.easyconn 2>/dev/null"
	adb shell "killall net.easyconn:coreService 2>dev/null"
	echo_color "卸载"
	adb shell "pm uninstall net.easyconn >/dev/null"
	adb shell "pm uninstall --user 0 net.easyconn >/dev/null"
	echo_color "释放空间...."
	adb shell "echo '' > /system/app/EasyConnect/EasyConnect.apk"
	echo_color "删除原车亿连版本"
	adb shell "rm -rf /system/app/EasyConnect/*"

	if [ "$num" == "0"  ]; then
    	echo_color "上传亿连系统文件"
    	adb push $filename /data/local/tmp/
    	adb shell "mkdir /system/app/EasyConnect >/dev/null"
    	echo_color "执行替换操作"
    	adb shell "tar -xvpf /data/local/tmp/$filename -C /system/app/EasyConnect"
    	echo_color "校验文件完整性"
    	adb shell "ls -l /system/app/EasyConnect/EasyConnect.apk"
    	echo_color "修复文件权限"
    	adb shell "chown -R root:root /system/app/EasyConnect/"
    	adb shell "chmod -R 755 /system/app/EasyConnect/"
    	adb shell "chmod -R 644 /system/app/EasyConnect/EasyConnect.apk"
    	adb shell "chmod -R 644 /system/app/EasyConnect/oat/arm/*"
    	echo_color "等待3秒..."
    	sleep 3
    	echo_color "恢复APP状态及还原安装"
    	adb shell "pm enable net.easyconn" >/dev/null 2>&1
    	adb shell "pm unhide net.easyconn" >/dev/null 2>&1
    	adb shell "pm default-state --user 0 net.easyconn" >/dev/null 2>&1
    	echo_color "等待3秒后开始还原"
    	sleep 3
    	echo_color "尝试还原"
    	adb shell "cmd package install-existing net.easyconn" >/dev/null 2>&1
    else
        echo_color "请耐心等待..."
        adb shell "rm -rf /data/local/tmp/EasyConnect.apk"
        adb push EasyConnect.apk /data/local/tmp/
        echo_color "安装中..."
        adb shell "pm install -r /data/local/tmp/EasyConnect.apk"
        echo_color "OK" green
        adb shell "cmd package install-existing net.easyconn"
        echo_color "Done" green
        if [[ "$add_flag" -eq "1" ]];then
            echo_color "自动添加强制全屏规则中..."
            policy_control_z "net.easyconn"
        fi
        
    fi
    ReBoot
    echo_color "多媒体重启中，如未生效请长按方向盘静音键+Home键再重启一次!"
    sleep 10
}







###quanping
function quanping()
{
    cd $Work_Path
	Adb_Init
	sleep 3
	clear
	echo "开始检测当前车机的全屏配置规则"
	adb shell "settings get global policy_control"
	echo "1、设置所有第三方APP全屏"
	echo "2、恢复系统默认设置"
	echo "3、可自定义全屏包名"
	echo "4、在现有的基础上配置高德为全屏(修复侧边栏重叠问题)"
	echo ""
	read -p "请输入数字选择:" num

	case $num in
		1)
			echo "设置所有第三方APP全屏"
			adb shell settings put global policy_control immersive.navigation=apps,-com.tencent.wecarflow,-com.android.cts.priv.ctsshim,-com.aptiv.thememanager,-com.tencent.tai.pal.platform.app,-com.edog.car,-com.gwm.app.bookshelf,-com.gwm.app.smartmanual,-com.gwmv3.vehicle,-com.aptiv.mediator,-com.gwm.app.onlinevideo,-com.redbend.client,-com.iflytek.cutefly.speechclient.hmi,-com.android.certinstaller,-com.aptiv.dlna,-com.gwmv3.launcher,-com.gwm.app.weather,-com.aptiv.camera,-com.gwmv3.media,-com.android.se,-com.gwmv3.photo,-com.gwmv3.radio,-com.gwmv3.dlna,-com.gwm.app.themestore,-com.hanvon.inputmethod.callaime,-com.gwmv3.setting,-com.gwm.app.iotapp,-com.ss.android.ugc.aweme,-com.android.packageinstaller,-com.gwmv3.dvr,-com.aptiv.thirdmediaparty,-com.gwmv3.personalcenter,-com.aptiv.car,-net.easyconn,-com.gwmv3.engineermode,-com.gwm.app.appstore,-com.aptiv.carplay,-com.android.systemui,-com.aptiv.media,-com.aptiv.radio,-com.aptiv.multidisplay,-com.gwm.app.etcp,-com.gwmv3.theme0201,-com.gwmv3.theme0301,-com.gwmv3.theme0302,-com.gwmv3.theme0401,-com.tencent.sotainstaller,-com.tencent.enger
			;;
		2)
			echo "恢复系统默认设置"
			adb shell settings put global policy_control null
			;;
		3)
			echo "可自定义全屏包名，多个app请用,号隔开,例如输入 com.autonavi.amapauto,cn.kuwo.kwmusiccar"
			read -p "请输入自定义全屏包名确认无误后回车:" pkg_name
			adb shell settings put global policy_control immersive.navigation=$pkg_name
			;;
		4)
			echo "开始设置"
			policy_control_z "com.autonavi.amapauto"
			;;

		5)
			echo "华阳主机高德去除状态栏-测试"
			adb shell settings put global policy_control immersive.status=com.autonavi.amapauto
			;;

		*)
			echo "error"
	esac
	echo "开始检测当前车机的全屏配置规则"
	adb shell "settings get global policy_control"
	echo "操作完成！"
}


###rootinstallenger
function rootinstallenger()
{
    echo "安卓已Root手机的安装工装模式...有空弄一下。"
	#判断是否su
	#判断完整root还是magisk
	#判断系统分区是否可读写
	#如果是可写hosts，覆写hosts记录
	#如果magisk install hosts module
	#修改模块host链接文件 重启手机
	#验证hosts是否生效等等
    #sleep 5
    #exit 0
}



###LogSubmit
function LogSubmit()
{
    clear
    echo "临时信息收集...."
    Adb_Init
    adb shell "cat /system/build.prop | grep ro.build.version.incremental"
    echo "请复制上面的结果给益达，并说明你的版本...."
    #exit 0
    echo "将自动抓取30S的log至手机download目录"
    echo "请务必提前执行：termux-setup-storage,否则没有权限访问存储空间!!!"
    sleep 2
    current=`date "+%Y-%m-%d %H:%M:%S"`
    timeStamp=`date -d "$current" +%s`
    currentTimeStamp=$((timeStamp*1000+10#`date "+%N"`/1000000))
    Log_file="AAAA_test_log_$currentTimeStamp.log"
    Log_Path="/sdcard/Download"
    echo "当前脚本执行环境检测中....."
    flag=`echo "check log Permission ???">$Log_Path/$Log_file|grep Permission`
    if [[ $flag=="" ]];then
        echo "权限检测通过"
        echo "pass!!!"
    else
        echo "请务必提前执行：termux-setup-storage,否则没有权限访问存储空间!!!"
        sleep 5
        exit 0
    fi
    echo "开始...."
    echo "请提前连接好车机,建议复现bug后再执行!!!"
    sleep 3
    #Adb_Init
    echo "log默认将抓取20秒，请耐心等待!!!"
    adb shell "logcat">$Log_Path/$Log_file & sleep 20;adb shell "killall logcat"
    echo "log抓取结束,保存目录为：$Log_Path/$Log_file,如果没有自动上传成功请手动用微信反馈至群内..."
    echo "end......"
    sleep 5
    exit 0
}



###### START ######



##Theme
function fafa()
{
    cat <<eof
    
************************************************
                   益达工具箱         
------------------------------------------------
      运行脚本前务必加入益达车友群获取教程
      微信号：312410527    QQ群：139667813

  替换组合主题注意事项：4012以上系统都可以替换
  如果想换回官方原版不组合主题，请按版本号恢复     

菜单1/2/3 可按需替换或恢复官方压缩前的高清主题
------------------------------------------------

* 1.  替换高清组合主题 或 恢复经典流光主题     *

* 2.  替换高清组合主题 或 恢复沙漠赤金主题     *

* 3.  替换高清组合主题 或 恢复空间折叠主题     *

* 4.  口香糖                                   *

* 9.  升级高德地图 6.5.5                       *

* 66. 跳转 高德/爱趣听升级回退/配置全屏 主菜单 *

* 88. 退出                                     *

************************************************
eof

}


function fafa_choice()
{
    read -p "请输入菜单对应数字并回车: " select_number
    case $select_number in
        1)
            echo "------------------------------------------------"
            echo "替换高清组合主题输入40"
            echo ""
            echo "恢复系统原厂主题请输入版本号(1.5.0输入150，1.6.0输入160)"
            echo "------------------------------------------------"
            read -p "请输入对应数字并回车: " replace_number
            replace_system_theme theme0401 http://data.fa-fa.cc:5266/d/car/files/theme/"$replace_number"/theme0401.apk
            ;;
        2)
            echo "------------------------------------------------"
            echo "替换高清组合主题输入40"
            echo ""
            echo "恢复系统原厂主题请输入版本号(1.5.0输入150，1.6.0输入160)"
            echo "------------------------------------------------"
            read -p "请输入对应数字并回车: " replace_number
            replace_system_theme theme0301 http://data.fa-fa.cc:5266/d/car/files/theme/"$replace_number"/theme0301.apk
            ;;
        3)
            echo "------------------------------------------------"
            echo "替换高清组合主题输入40"
            echo ""
            echo "恢复系统原厂主题请输入版本号(1.5.0输入150，1.6.0输入160)"
            echo "------------------------------------------------"
            read -p "请输入对应数字并回车: " replace_number
            replace_system_theme theme0201 http://data.fa-fa.cc:5266/d/car/files/theme/"$replace_number"/theme0201.apk
            ;;
        4)
            replace_user_theme
            ;;
        9)
            AutoMapBeta
            ;;
        66)
            clear
            main
            ;;
        88)
            exit 0
            ;;
        99)
            clear
            fafa
            ;;



    esac
}

function theme()
{
    cat <<eof
    
************************************************
                   益达工具箱         
------------------------------------------------
      运行脚本前务必加入益达车友群获取教程
      微信号：312410527    QQ群：203364445

  DIY主题壁纸注意事项：4012以上系统都可以

#恢复系统主题壁纸请输入55回车
#在线主题删除重新下载即可
------------------------------------------------

* 1.  DIY定制经典流光主题壁纸                  *

* 2.  DIY定制沙漠赤金主题壁纸                  *

* 3.  DIY定制空间折叠主题壁纸                  *

* 4.  DIY定制#碳纤维主题壁纸                   *

* 5.  DIY定制#莲月中秋主题壁纸                 *

* 6.  DIY定制#清凉泳池主题壁纸                 *

* 7.  DIY定制#福气迎春主题壁纸                 *

* 8.  DIY定制#携青山主题壁纸                   *

* 9.  DIY定制#潮玩朋克主题壁纸                 *

* 10.  DIY定制#陌海幽兰主题壁纸                *

* 11.  DIY定制#极简秘境主题壁纸                *

* 12.  DIY定制#PowerMan主题壁纸                *

* 13.  DIY定制#Red主题壁纸                     *

* 20.  保留仪表盘-沙漠赤金+折叠空间（透明）    *

* 21.  保留仪表盘-清凉泳池+经典流光（透明）    *

* 22.  保留仪表盘-携青山+莲月中秋（透明）      *

* 55.  替换高清组合主题或恢复系统主题菜单      *

* 66. 跳转 高德/爱趣听升级回退/配置全屏 主菜单 *

* 88. 退出                                     *

************************************************
eof

}

function theme_choice()
{
	#begin
	Adb_Init
	echo_color "连接车机......" yellow
	theme_new_path='/system/app'
	Apk_vender_path='/system/vendor/app/theme0201'
	vender_check=`adb shell "if [ -d $Apk_vender_path ];then echo '1';else echo '2'; fi"`
	if [ "$vender_check" == "2" ]; then
	    theme_new_path='/system/app'
	else
	    theme_new_path='/system/vendor/app'
	fi
	#经典流光1
	jdlg_path="$theme_new_path/theme0401/theme0401.apk"
	#沙漠赤金2
	smcj_path="$theme_new_path/theme0301/theme0301.apk"
	#折叠空间3
	zdkj_path="$theme_new_path/theme0201/theme0201.apk"
	#碳纤维:4
	tqw_path="/sdcard/Download/theme/168/com.gwmv3.skin32.apk"
	#莲月中秋:5
	lyzq_path="/sdcard/Download/theme/147/com.gwmv3.skin13.apk"
	#清凉泳池:6
	qlyc_path="/sdcard/Download/theme/142/com.gwmv3.skin9.apk"
	#福气迎春:7
	fqyc_path="/sdcard/Download/theme/152/com.gwmv3.skin30.apk"
	#携青山:8
	xqs_path="/sdcard/Download/theme/167/com.gwmv3.skin31.apk"
	#潮玩朋克:9
	cwpk_path="/sdcard/Download/theme/124/com.gwmv3.skin7.apk"
	#陌海幽兰:10
	mhyl_path="/sdcard/Download/theme/122/com.gwmv3.skin6.apk"
	#极简秘境:11
	jjmj_path="/sdcard/Download/theme/119/com.gwmv3.skin4.apk"
	#PowerMan:12
	PowerMan="/sdcard/Download/theme/121/com.gwmv3.skin2.apk"
	#Red :13
	Red="/sdcard/Download/theme/123/com.gwmv3.skin8.apk"
	
	clear
	theme
	
	
    read -p "请输入对应数字并回车: " select_number
    case $select_number in
        1)
			echo_color "当前选择经典流光"
			Diy_system_theme theme0401 $jdlg_path
			;;
        2)
			echo_color "当前选择沙漠赤金"
            Diy_system_theme theme0301 $smcj_path
            ;;
        3)
			echo_color "当前选择折叠空间"
            Diy_system_theme theme0201 $zdkj_path
            ;;
        4)
            echo_color "#碳纤维:"
			Diy_system_theme com.gwmv3.skin32 $tqw_path
            ;;
        5)
			echo_color "#莲月中秋:"
			Diy_system_theme com.gwmv3.skin13 $lyzq_path
            ;;
        6)
			echo_color "#清凉泳池:6	"
			Diy_system_theme com.gwmv3.skin9 $qlyc_path
            ;;
        7)
			echo_color "#福气迎春:7	"
			Diy_system_theme com.gwmv3.skin30 $fqyc_path
            ;;
        8)
			echo_color "#携青山:8	"
			Diy_system_theme com.gwmv3.skin31 $xqs_path
            ;;
        9)
			echo_color "#潮玩朋克:9	"
			Diy_system_theme com.gwmv3.skin7 $cwpk_path
            ;;
        10)
			echo_color "#陌海幽兰:10	"
			Diy_system_theme com.gwmv3.skin6 $mhyl_path
            ;;
        11)
			echo_color "#极简秘境:11	"
			Diy_system_theme com.gwmv3.skin4 $jjmj_path
            ;;
        12)
			echo_color "#PowerMan:12	"
			Diy_system_theme com.gwmv3.skin2 $PowerMan
            ;;
        13)
			echo_color "#Red	"
			Diy_system_theme com.gwmv3.skin8 $Red
            ;;
        20)
			echo_color "已修复,跑一次即可"
            #Adb_Init
            #adb shell "mkdir ${smcj_path%/*} && chmod 755 ${smcj_path%/*}"
			#adb shell "\cp $zdkj_path $smcj_path"
			#ReBoot
			Diy_system_theme theme0301 $smcj_path
			;;
        21)
			echo_color "已修复,跑一次即可"
            #Adb_Init
            #adb shell "mkdir ${qlyc_path%/*} && chmod 755 ${qlyc_path%/*}"
			#adb shell "\cp $jdlg_path $qlyc_path"
			#ReBoot
			Diy_system_theme com.gwmv3.skin9 $qlyc_path
			;;
        22)
			echo_color "已修复,跑一次即可"
            #Adb_Init
            #adb shell "mkdir ${xqs_path%/*} && chmod 755 ${xqs_path%/*}"
			#adb shell "\cp $lyzq_path $xqs_path"
			#ReBoot
			Diy_system_theme com.gwmv3.skin31 $xqs_path
			;;
		55)
			fafa
			fafa_choice
			;;
        66)
            clear
            main
            ;;
        88)
            exit 0
            ;;

    esac
}


# function theme_choice_tips()
# {
# 	echo_color "------------------------------------------------"
#     echo_color "替换组合主题输入40， 恢复输入4位版本号，如：4016"
#     echo_color "------------------------------------------------"
#     echo_color "不知道版本号的请在工装模式中查看系统版本号"
#     echo_color "------------------------------------------------"
# 	echo_color "DIY制作主题请直接输入99"
#     echo_color "------------------------------------------------"
#     read -p "请根据以上提示选择输入数字并回车: " replace_number
# 	if [[ "$replace_number"=="99" ]];then
# 		Diy_system_theme $1 $2
# 	else
# 		replace_system_theme $1 http://data.fa-fa.cc:5266/d/car/files/theme/"$replace_number"/"$1".apk
# 	fi
# }


function read_path_filename()
{
	#echo_color "" >tmp.log
	readDir=$1
	#echo_color $readDir
	for df in `ls $readDir`
	do
		#判断是否是文件夹
		#echo_color "$readDir/$df"
		# 判断是否是普通文件
		if [ -f $readDir"/"$df ]; then
			# `echo $df|grep ^A`判断字符串首字母是否是A
			#$? -ne 0
			echo_color "检测是否符合指定png后缀的文件" yellow
			if [ `echo $df|grep -i png$` ]; then
			    echo_color "$readDir/$df"
				echo_color "目录下只读取第一个png图片文件"
				if [ `echo $df|grep PNG$` ]; then
				    mv $readDir/$df $readDir/${df%.*}.png1
				    mv $readDir/${df%.*}.png1 $readDir/${df%.*}.png
				fi
				res="${df%.*}.png"
				break
			elif [ `echo $df|grep -i jpg$` ]; then
				compressToWeb $df $readDir
				#
				fileName_tmp=${df%.*}
				res="${fileName_tmp}.png"
				break
			fi
		fi
	done 
}

function Diy_system_theme()
{
	echo_color "欢迎尝试使用益达工具DIY专属您的车机主题。"
	cd $Work_Path
	themedir="$Work_Path/theme"
	rm -rf $themedir
	mkdir -p $themedir
	cd $themedir
	theme_system_path=$2
	echo_color "$theme_system_path"
	Alpine_Env_Check="/etc/apk/repositories"
    Termux_Env_Check="/etc/apt/sources.list"
    echo_color "当前脚本执行环境检测中....."
    if [  -f "$Alpine_Env_Check"  ];then
        echo_color "当前为ish shell Alpine环境，安卓也可使用Termux执行本脚本"
		echo_color "苹果请打开文件-浏览-右上角编辑-打开ISH-完成-浏览ISH-创建theme文件夹"
		echo_color "再创建01文件夹将准备的一张主题图片放入其中"
		echo_color "如有第二张图片，请创建02文件夹，将第二张图片放入其中"
		echo_color "图片分辨率请使用1920px*720px,格式为png"
		apk add zip apksigner aapt  openssh openssl-dev libwebp imagemagick -y >/dev/null 2>&1
		diy_img_path="/root/theme"
		echo_color "苹果手机环境待修复请等待通知！！！"
		exit 0
    elif [  -f "$PREFIX/$Termux_Env_Check"  ];then
        echo_color "当前为Termux shell环境,苹果也可使用ish shell执行本脚本"
		echo_color "安卓请打开文件管理器-打开Download目录-创建theme文件夹"
		echo_color "再创建01文件夹将准备的一张主题图片放入其中"
		echo_color "如有第二张图片，请创建02文件夹，将第二张图片放入其中"
		echo_color "图片分辨率请使用1920px*720px,格式为png"
		echo_color "安装软件环境中,比较慢,请耐心等待。" red
		apt update -y  > /dev/null 2>&1
		apt install zip apksigner aapt openssl-tool libwebp imagemagick -y > /dev/null 2>&1
		#echo_color "$?" red
		if [ $? -ne 0 ] || ! command -v openssl > /dev/null 2>&1 ; then
		    echo_color "环境异常,尝试修复中...." red
		    rm -rf /data/data/com.termux/files/usr/var/lib/dpkg/*
		    mkdir /data/data/com.termux/files/usr/var/lib/dpkg > /dev/null 2>&1
		    apt install zip apksigner aapt openssl-tool libwebp imagemagick -y > /dev/null 2>&1
		else
		    echo_color "check ok" green
		fi
		diy_img_path="/sdcard/Download/theme"
	else
		echo_color "环境判断失败，请截图反馈" red
		exit 0
	fi
	echo_color "开始预校验"
	flag_01=0
	flag_02=0
	if [  -d "$diy_img_path"  ];then
		echo_color "存在$diy_img_path目录"
		if [  -d "$diy_img_path/01"  ];then
			echo_color "存在$diy_img_path/01目录"
			flag_01=1
			read_path_filename "$diy_img_path/01"
			img_01="$diy_img_path/01/$res"
			if [ ! `echo $img_01|grep png$` ]; then
				echo_color "$diy_img_path/01 未扫描到图片" red
				exit 0
			fi
			echo_color "执行格式转换01"
			compressToWeb $res "$diy_img_path/01"
			echo_color $img_01
		fi
		if [  -d "$diy_img_path/02"  ];then
			echo_color "存在$diy_img_path/02目录"
			flag_02=1
			res=""
			read_path_filename "$diy_img_path/02"
			img_02="$diy_img_path/02/$res"
			if [ ! `echo $img_02|grep png$` ]; then
				echo_color "$diy_img_path/02 未扫描到图片" yellow
				flag_02=0
			else
			    echo_color "02尝试执行格式转换webp"
			    compressToWeb $res "$diy_img_path/02"
			    echo_color $img_02
			fi
		fi
	else
		echo_color "DIY主题图片文件目录不存在！" red
		echo_color "确认是否按教程提前准备图片文件！" red
		echo_color "请检查后再次重试或截图反馈" red
		exit 0
	fi
	echo_color "------------------------------------------------"
	echo_color "1、将01为中控主页背景"
	echo_color "2、将01设置为中控、车辆、设置、菜单背景"
	echo_color "3、将01设为中控主页背景，02为车辆、设置、菜单背景"
	if [ "$select_number" -ge "4" ] && [ "$select_number" -ne 20 ];then
	    echo_color "0、重置该在线主题壁纸为默认壁纸" red
	fi
	echo_color " "
    read -p "请根据以上提示选择输入数字并回车: " diy_number
	if [ $flag_01 == "0" ];then
		echo_color "01图片不存在，请重试" red
		exit 0
	elif [ $flag_02 == "0" -a $diy_number == 3  ];then
		echo_color "02图片不存在，请重试" red
		exit 0
	fi
	theme_diy $diy_number $1 $theme_system_path $img_01 $img_02

}

function theme_diy()
{
	diy_number=$1
	theme_name=$2
	theme_system_path=$3
	img_01=$4
	img_02=$5
	hz="webp"
	sz="tmp/res/drawable-nodpi-v4/common_background01."
	zk="tmp/res/drawable-nodpi-v4/common_background02."
	sz1="tmp/res/drawable--1dpi/common_background01."
	zk1="tmp/res/drawable--1dpi/common_background02."
	if [ `echo $theme_name|awk -F"." '{print $3}'|awk -F 'n'  '$2>8{print $2}'` ] && [ "$select_number" -ne 21 ];then
		sz_path=$sz1
		zk_path=$zk1
	else
		sz_path=$sz
		zk_path=$zk
	fi
	sz_img_path="$sz_path$hz"
	zk_img_path="$zk_path$hz"
	echo_color "前置处理..."
	if [ "$select_number" -ge "4" ] && [ $diy_number == 0 ] && [ "$select_number" -ne 20 ];then
	    echo_color "重置该在线主题壁纸为默认壁纸"
	    #wget -q --show-progress -O $theme_name.apk  http://data.fa-fa.cc:5266/d/car/files/theme/bak/$theme_name.apk
	    wzget http://data.fa-fa.cc:5266/d/car/files/theme/if/bak/$theme_name.apk $theme_name.apk
	    echo_color "连接车机......"
    	Adb_Init
	    adb shell "pm uninstall $theme_name"
	    echo_color "File Upload..."
    	adb shell "mkdir -p  ${theme_system_path%/*} && chmod 755 ${theme_system_path%/*}"
    	adb push $theme_name.apk $theme_system_path
    	echo_color "......done"
    	echo_color "请直接在主题商城里应用该主题，在线主题无需重启车机!!!"
	    exit 0
	fi
	#wget -q --show-progress -O sign-tool.zip  http://data.fa-fa.cc:5266/d/car/files/theme/sign-tool.zip
	wzget http://data.fa-fa.cc:5266/d/car/files/theme/if/sign-tool.zip sign-tool.zip
	rm -rf cert && mkdir cert && rm -rf ~/.keystore
	unzip sign-tool.zip -d cert && cd cert && chmod 777 keytool-importkeypair && ./keytool-importkeypair  -p 123456 -pk8 platform.pk8 -cert platform.x509.pem -alias test
	cd ..
	#keytool -list
	echo_color "拉取主题文件,请保持网络稳定耐心等待。。。"
	#Adb_Init
	#adb pull $theme_system_path ./$theme_name.apk
	echo_color "$select_number"
	if [ "$select_number" -ge "19" ];then
	    echo_color "test"
	    #wget -q --show-progress -O $theme_name.apk  http://data.fa-fa.cc:5266/d/car/files/theme/$theme_name.1.apk
	    wzget  http://data.fa-fa.cc:5266/d/car/files/theme/if/$theme_name.1.apk $theme_name.apk
	else
	    #wget -q --show-progress -O $theme_name.apk  http://data.fa-fa.cc:5266/d/car/files/theme/$theme_name.apk
	    wzget  http://data.fa-fa.cc:5266/d/car/files/theme/if/$theme_name.apk $theme_name.apk
	fi
	#\cp ~/tmp.apk ./$theme_name.apk
	echo_color "解包"
	rm -rf tmp
	mkdir tmp
	unzip $theme_name.apk -d tmp/ >/dev/null 2>&1
	echo_color "识别及替换"
	if [ `ls $sz_path*|grep png$` ]; then
		hz="png"
		sz_img_path="$sz_path$hz"
		zk_img_path="$zk_path$hz"
	else
		img_01="${img_01%.*}.$hz"
		img_02="${img_02%.*}.$hz"
	fi
	if [ $diy_number == "1" ];then
		echo_color "将01为中控主页背景"
		\cp $img_01 $zk_img_path
	elif [ $diy_number == "2" ];then
		echo_color "将01设置为中控、车辆、设置、菜单背景"
		\cp $img_01 $zk_img_path
		\cp $img_01 $sz_img_path
	else
		echo_color "将01设为中控主页背景，02为车辆、设置、菜单背景"
		\cp $img_01 $zk_img_path
		\cp $img_02 $sz_img_path
	fi
	echo_color "临时目录打包"
	cd tmp
	zip -r ../$theme_name.tmp.apk ./* >/dev/null
	cd ..
	rm -rf tmp
	echo_color "APK对齐"
	zipalign  -v 4 $theme_name.tmp.apk $theme_name.tmp.algin.apk >/dev/null 2>&1
	echo_color "APK签名"
	apksigner sign -verbose --ks cert/platform.jks  --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true  --ks-pass pass:123456  --out $theme_name.tmp.sign.apk $theme_name.tmp.algin.apk >/dev/null 2>&1
	echo_color "APK签名验证"
	apksigner verify -v $theme_name.tmp.sign.apk|grep "true"
	echo_color "连接车机......"
	Adb_Init
	echo_color "File Upload..."
	adb shell "mkdir -p  ${theme_system_path%/*} && chmod 755 ${theme_system_path%/*}"
	adb push $theme_name.tmp.sign.apk $theme_system_path
	echo_color "......done"
	adb shell "ls -l $theme_system_path"
	cd ~ && rm -rf $themedir && rm -rf "${img_01%.*}.webp" && rm -rf "${img_01%.*}.jpg" && rm -rf "${img_02%.*}.webp" && rm -rf "${img_02%.*}.jpg"
	if [ "$select_number" -ge "4" ];then
	    echo_color "test fix"
	    adb shell "pm uninstall $theme_name"
	    echo_color "请直接在主题商城里应用该主题，在线主题无需重启车机!!!" red
	    sleep 15
	    main
	else
	    ReBoot
	fi
	
}

function compressToWeb()
{
    file=$1
    fileName=${file%.*}
    #echo "${file##*.}"
    if [[ ${file##*.} = "png" && ${fileName##*.} != "9" ]]
    then
        #echo $fileName
        cwebp -q 90 $2/$1 -o "$2/${fileName}.webp" >/dev/null 2>&1
        #rm -f $2/$1
	elif [[ ${file##*.} = "jpg" ]];then
		convert "$2/$1" "$2/${fileName}.png";
	elif [[ ${file##*.} = "PNG" && ${fileName##*.} != "9" ]]
    then
        #echo $fileName
        cwebp -q 90 $2/$1 -o "$2/${fileName}.webp" >/dev/null 2>&1
        #rm -f $2/$1
	elif [[ ${file##*.} = "JPG" ]];then
		convert "$2/$1" "$2/${fileName}.png";
    fi
}

function replace_system_theme()
{
    cd $Work_Path
    themedir="$Work_Path/theme"
    rm -rf $themedir
    mkdir -p $themedir
    cd $themedir
    echo_color " " yellow
    echo_color ">>> 正在校验版本号并下载主题，请耐心等候..." yellow
    wzget "$2" "$1".apk
    Adb_Init
    echo_color "连接车机......" yellow
    if [ -z "$1" ]; then
        echo_color "第一个参数为空，不存在参数" red
        exit 1
    else
        echo_color "$1"
    fi
    theme_new_path='/system/app'
    Apk_vender_path='/system/vendor/app/theme0201'
    vender_check=`adb shell "if [ -d $Apk_vender_path ];then echo '1';else echo '2'; fi"`
    if [ "$vender_check" == "2" ]; then
        theme_new_path='/system/app'
    else
        theme_new_path='/system/vendor/app'
        echo_color "清理异常目录" yellow
        adb shell rm -rf /system/app/$1/$1.apk
        adb shell rm -rf /system/app/$1
    fi
    echo_color "当前系统主题目录:$theme_new_path" yellow
    adb shell rm -rf $theme_new_path/$1/$1.apk
    adb push $1.apk $theme_new_path/$1/$1.apk
    echo_color "正在清理临时文件！" yellow
    rm -rf $themedir
    ReBoot
}

function replace_user_theme()
{
	cd $Work_Path
	themedir="$Work_Path/theme"
    rm -rf $themedir
	mkdir -p $themedir
    cd $themedir
	echo_color "开始下载主题，请稍后..." yellow
    wzget http://data.fa-fa.cc:5266/d/car/files/theme/tanke/theme_store theme_store 
	Adb_Init
	adb shell rm -rf /data/data/com.gwm.app.themestore/databases/*
	adb shell rm -rf /storage/emulated/0/Download/theme
	adb shell mkdir -p /storage/emulated/0/Download/theme
	adb push theme_store /data/data/com.gwm.app.themestore/databases/
    adb uninstall com.gwmv3.skin2
    adb uninstall com.gwmv3.skin4
    adb uninstall com.gwmv3.skin8
	echo_color "正在清理临时文件！"
	rm -rf $themedir
    ReBoot
}



function test_grant()
{
    
    if [[ "$1" == "0" ]];then
        echo_color ""
    else
        Adb_Init
        echo_color "########################" yellow
        adb shell "dumpsys package com.autonavi.amapauto"
        echo_color "########################" yellow
        grant "com.autonavi.amapauto" "android.permission.FOREGROUND_SERVICE"
        grant "com.autonavi.amapauto" "android.permission.ACCESS_NETWORK_STATE"
        grant "com.autonavi.amapauto" "android.permission.INTERNET"
        grant "com.autonavi.amapauto" "android.permission.RECEIVE_BOOT_COMPLETED"
        grant "com.autonavi.amapauto" "android.permission.ACCESS_WIFI_STATE"
        grant "com.autonavi.amapauto" "android.permission.ACCESS_LOCATION_EXTRA_COMMANDS"
        grant "com.autonavi.amapauto" "android.permission.ACCESS_COARSE_LOCATION"
        grant "com.autonavi.amapauto" "android.permission.RECORD_AUDIO"
        grant "com.autonavi.amapauto" "android.permission.SYSTEM_ALERT_WINDOW"
        grant "com.autonavi.amapauto" "android.permission.GET_TASKS"
        grant "com.autonavi.amapauto" "android.permission.BLUETOOTH_ADMIN"
        grant "com.autonavi.amapauto" "android.permission.BLUETOOTH"
        grant "com.autonavi.amapauto" "android.permission.CAMERA"
    fi
    grant "com.autonavi.amapauto" "android.permission.WRITE_EXTERNAL_STORAGE"
    grant "com.autonavi.amapauto" "android.permission.LOCAL_MAC_ADDRESS"
    grant "com.autonavi.amapauto" "android.permission.WRITE_MEDIA_STORAGE"
    grant "com.autonavi.amapauto" "android.permission.MANAGE_USB"
    grant "com.autonavi.amapauto" "android.permission.READ_EXTERNAL_STORAGE"
    grant "com.autonavi.amapauto" "android.permission.WRITE_SETTINGS"
    grant "com.autonavi.amapauto" "android.permission.POST_NOTIFICATIONS"
    grant "com.autonavi.amapauto" "android.permission.ACCESS_FINE_LOCATION"
    grant "com.autonavi.amapauto" "android.permission.READ_PHONE_STATE"
    grant "com.autonavi.amapauto" "android.permission.READ_MEDIA_IMAGES"
    grant "com.autonavi.amapauto" "android.permission.ACCESS_MEDIA_LOCATION"
    
    adb shell "dumpsys package com.autonavi.amapauto" | grep -i  "runtime permissions:" -A 20
    sleep 5
    
}

# function test_clear()
# {
#     Adb_Init
#     adb shell "df -h"
#     echo_color "释放爱趣听...."
#     adb shell "echo '' > /system/app/wecarflow/wecarflow.apk"
#     adb shell "rm -rf  /system/app/wecarflow/*"
#     echo_color "释放高德...."
#     adb shell "echo '' > /system/app/AutoMap/AutoMap.apk"
#     echo_color "删除原车高德地图系统文件"
#     adb shell "rm -rf /system/app/AutoMap/*"
#     echo_color "测试清理用户目录"
#     adb shell "rm -rf /data/user/0/com.autonavi.amapauto"
#     adb shell "rm -rf /data/user_de/0/com.autonavi.amapauto"
#     adb shell "rm -rf /data/app/*/com.autonavi.amapauto*"
#     adb shell "rm -rf /data/media/0/amapauto9"
#     adb shell "rm -rf /sdcard/amapauto9"
#     adb shell "rm -rf /sdcard/Android/data/com.autonavi.amapauto"
#     echo_color "请截图反馈！！！"
#     adb shell "lpdump"
#     adb shell "df -h"
#     adb enable-verity
#     echo_color "重启中....如需恢复请通过主菜单安装！！！！！！！"
#     ReBoot
# }




function menu()
{
    cat <<eof
    
***************************************************
*                      YiTools                    *
***************************************************

*  1.高德公众版 7.5.0 非全适配版 - 安波福专用     *

*  4.腾讯爱趣听升级至 3.1.6 版或还原              *

*  5.应用商店（安装远程URL apk应用）              *

*  6.配置软件是否为全屏                           *

*  8.收音机无法打开等回退专用                     *

*  9.高德适配版 7.1.5 或 6.5.5 - 安波福专用       *

*  12.高德7.5.0/7.1.5/6.5.5 - 华阳专用先看益达教程*

*  10.壁纸替换/替换组合主题/恢复原车主题等        *

*  0.退出                                         *

***************************************************
本脚本免费使用, 进益达车友群免费获取
抖音搜索: 哈弗益达
Tips: 请开启工装模式中TCP/IP且车机连手机热点
***************************************************
eof

}
function usage()
{
    read -p "请看清对应操作输入数字选项后回车: " choice
    case $choice in
        1)
            #AutoMap
            echo_color " "
            AutoMap
            sleep 5
            ;;
        2)
            #sidemenu
            echo_color " "
            echo_color "第三方音乐跳转功能暂停使用，后续留意益达群公告通知" plum
            sleep 5
            ;;
        4)
            wecarflow
            ;;
        5)
            clear
            installapk
            ;;
        6)
            quanping
            ;;
        8)
            kwkj
            ;;
        9)
            AutoMapBeta
            ;;
        10)
            clear
            #fafa
            theme
            theme_choice
            ;;
        11)
            EasyConnect
            ;;
        12)
            Navigation
            ;;
        9001)
            LogSubmit
            ;;
        9012)
            Adbd
            ;;
        9003)
            #自用
            Adb_ROOT
            ;;
        9044)
            clear_amap_all
            ;;
        0)
            exit 0
            ;;
		*)
            clear
            ;;

    esac
}
function  main()
{
    while true
    do
        #clear 
        menu
        usage
    done
}

Path_fix
Env_fix
CheckUpdate
byby
clear
main