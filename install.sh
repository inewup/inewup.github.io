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
