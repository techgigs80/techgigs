#!/bin/sh                                     

HOSTNAME=`hostname`

#LANG=C
#LANG=ko.UTF-8
#export LANG
mkdir $HOSTNAME


######################################
########## 기본 설정 Check ###########
######################################

PASSWD="/etc/passwd"				#### 패스워드 파일 위치 ####
SHADOW="/etc/shadow"				#### 쉐도우 파일 위치 ####
GROUP="/etc/group"				#### group 파일 위치 ####
PASSWD_CONF_1="/etc/login.defs"			#### 패스워드 정책 파일 위치 ####
PASSWD_CONF_2="/etc/pam.d/system-auth"		#### 패스워드 정책 파일 위치 ####
HOSTS_EQUIV="/etc/hosts.equiv"			#### hosts.equiv 파일 위치 ####
LOGIN_CONF="/etc/pam.d/login"			#### 로그인 설정 파일 위치 ####
INETD_CONF="/etc/inetd.conf"			#### inetd.conf 파일 위치 ####
HOSTS="/etc/hosts"				#### hosts 파일 위치 ####
CRON_ALLOW="/etc/cron.allow"			#### cron.allow 파일 위치 ####
CRON_DENY="/etc/cron.deny"			#### cron.deny 파일 위치 ####
AT_ALLOW="/etc/at.allow"			#### at.allow 파일 위치 ####
AT_DENY="/etc/at.deny"				#### at.deny 파일 위치 ####
TELNET_BANNER="/etc/issue"			#### 텔넷 로그인 배너 설정 파일 ####
FTP_BANNER="/etc/banners/ftp.msg"		#### FTP 로그인 배너 설정 파일 ####
SYSLOG_CONF="/etc/syslog.conf"			#### SYSLOG 설정 파일 ####
SERVICES="/etc/services"			#### services 파일 위치 ####
SNMP_CONF="/etc/snmp/conf/snmpd.conf"		#### snmpd 설정 파일 위치 ####

######################################
######################################
##### Linux 7.1 #####

echo "***************************************************************************"				> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "*                                                                         *"				>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "*                        MES LINUX CheckList	                         		*"				>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "*                                                                         *"				>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "*                                                                         *"				>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "***************************************************************************"				>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " "													>> $HOSTNAME/$HOSTNAME.txt 2>&1

chmod 600 $HOSTNAME/$HOSTNAME.txt

echo "* Start Time "
	date
echo " "

echo "* Start Time " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	date 													>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " "													>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "* System Information Query Start "
echo "* System Information Query Start " 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " "													>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "### 네트워크 현황 ###"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1
	ifconfig -a												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "### 프로세스 현황 ###"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1
	ps -ef | grep -v grep | grep -v ps | sort | uniq							>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "### 열려있는 포트 리스트 ###"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	netstat -an | grep -i listen										>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo ". "													>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "************************** 1. 계정 및 패스워드 관리 *************************************"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "*****************************************************************************************" 		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US101. root 이외에 UID/GID가 0인 사용자가 존재하지 않는가?--------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "US101-1. UID가 0인 사용자" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		awk -F: '($3 == "0") {print $1}' $PASSWD 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "US101-2. GID 가 0인 사용자" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		awk -F: '($4 == "0") {print $1}' $PASSWD 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "관례적으로 100보다 작은 UID들과 10보다 작은 GID들은 시스템 계정을 위해 사용됨"			>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US102. 불필요한 계정이 존재하지 않는가?--------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US103. 불필요하게 쉘(shell)이 부여된 계정이 존재하지 않는가?---------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $PASSWD | awk -F: '{print $1, $7}' 								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "daemon, bin, lp, uucp 등은 불필요한 계정" 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "sys, bin, lp, uucp, nuucp, www, nobody 등은 쉘이 불필요한 계정(공란 or /bin/false)" 		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US104. 취약한 패스워드를 가진 사용자가 존재하지 않는가?-----------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/security/pwquality.conf	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1	
echo "---------------------------------------------------------------------"		>> $HOSTNAME/
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/pam.d/password-auth >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US105. 패스워드 파일에 대해 Shadow화를 적용하였는가?--------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1	
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $PASSWD											> $HOSTNAME/$HOSTNAME.PASSWD.txt 2>&1
		cat $SHADOW											> $HOSTNAME/$HOSTNAME.SHADOW.txt 2>&1
	echo "@권고사항[[수동체크]]"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "수집된 패스워드파일(PASSWD, SHADOW)을 패스워드크랙 도구로 확인" 					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "패스워드 혹은 쉐도우 파일 내 패스워드가 암호화되어 저장되어 있을 경우 C2 Level 적용 완료"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1	
echo "-----US106. 패스워드의 최소 길이를 8자 이상으로 설정하였는가?----------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/login.defs	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US107. 패스워드의 최대 사용 기간을 설정하였는가?----------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US108. 패스워드의 최소 사용 기간을 설정하였는가?----------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	cat /etc/pam.d/system-auth								>$HOSTNAME/$HOSTNAME.etc.pam.d.system-auth.txt 2>&1
	echo "@권고사항(수동체크)" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "HOSTNAME.etc.pam.d.system-auth.txt 파일을 참고하여 아래와 같은 설정이 있는지 확인"	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "password requisite /lib/security/$ISA/pam_cracklib.so retry=3 minlen=8 lcredit=-2 ucredit=-1 dcredit=-1 ocredit=-1"	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "lcredit : 입력해야 할 최소 문자 수"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "ucredit : 입력해야 할 최대 문자 수"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "dcredit : 입력해야 할 최소 숫자 수"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "ocredit : 입력해야 할 최소 특수문자 수"							>> $HOSTNAME/$HOSTNAME.txt 2>&1	
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1	
echo "-----US109. 계정잠금 임계값을 설정하였는가? ----------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항(수동체크)" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "HOSTNAME.etc.pam.d.system-auth.txt 파일을 참고하여 아래와 같은 설정이 있는지 확인"	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "auth required /lib/security/pam_tally.so deny=5 lock_time=1800 no_magic_root reset"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "deny=5 5회 실패 시 계정 잠금"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "lock_time-1800 1800초(30분)간 계정 잠금"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US110. 최근 패스워드를 기억하도록 설정되어 있는가?------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항(수동체크)" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "HOSTNAME.etc.pam.d.system-auth.txt 파일을 참고하여 아래와 같은 설정이 있는지 확인"	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "password sufficient /lib/security/pam.unix.so use_authtok md5 shadow remember="		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "최근 사용했던 패스워드를 저장하여 중복 사용을 피함"				>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "만약 패스워드 최대 사용기간을 91일로 설정하였을 경우"				>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "패스워드 히스토리를 4로 설정할 것을 권고 함"						>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "ex) password sufficient /lib/security/pam.unix.so use_authtok md5 shadow remember=4"	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "************************** 2. 접근제어 *************************************"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "*****************************************************************************************" 		>> $HOSTNAME/$HOSTNAME.txt 2>&1	
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1	
echo "-----US201. 인가된 시스템에서만 접근이 가능하도록 설정하였는가?--------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* Xinetd 가동여부 및 서비스확인" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep xinetd | grep -v grep 								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/hosts.allow, hosts.deny 확인"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/hosts.allow										>> $HOSTNAME/$HOSTNAME.txt 2>&1						
		cat /etc/hosts.deny										>> $HOSTNAME/$HOSTNAME.txt 2>&1						
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/etc/hosts.allow, hosts.deny은 접근제어 설정파일"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "Xinetd 설치 확인 및 설정파일 필터 확인"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/hosts.equiv, $ HOME/.rhosts 파일의 설정 " 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep "rlogin|rcp|rcmd|rexec"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $HOSTS_EQUIV										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $HOME/.rhosts										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "R-Command 서비스를 사용하지 않을 경우"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "(/etc/hosts.equiv파일삭제 또는 #ln -s /dev/null /etc/hosts.equiv)"				>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "($ HOME/.rhosts파일삭제 또는 #ln -s /dev/null $ HOME/.rhosts)"					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "R-Command 서비스를 사용할 경우"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " '+ +' 혹은 '+'가 포함되지 않도록 하고 필요한 권한만 제공"					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US202. 일반 사용자의 SU 명령을 제한 하고 있는가?------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /usr/bin/su"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -l /usr/bin/su										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /bin/su"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -l /bin/su											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/group"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/group											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@ 권고사항"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " 권한있는 사용자만 su 명령어를 사용하도록 권한변경(그룹으로 관리)"				>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " 권한은 4750(-rwsr-x---) 권고, 455(-r-sr-xr-x)은 취약함"						>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US203. 암호화된 원격접속을 사용하고 있는가?-----------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* SSH 포트 확인 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		netstat -na | grep 22										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* SSH 프로세스 확인 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -aux | grep sshd										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "SSH를 이용하여 원격접속을 사용하고 있는지 점검"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US204. 원격에서 root로 로그인 가능하지 않게 설정 하였는가?--------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 로그인 설정 점검 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		grep -i "^auth" $LOGIN_CONF									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/etc/pam.d/login파일에 'auth required pam_securetty.so' 확인"					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/ftpusers 점검" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/ftpusers 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/ftpd/ftpusers 점검" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/ftpd/ftpusers										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "root와 벤더가 지원하는 기본 계정이 등록 되어 있는지 점검"						>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US205. IDLE 타임 아웃을 설정하였는가?-----------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/profile 점검" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/profile | grep TMOUT									>> $HOSTNAME/$HOSTNAME.txt 2>&1						
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	#echo "* /etc/default/login 점검" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	#	cat $LOGIN_CONF | grep TIMEOUT=									>> $HOSTNAME/$HOSTNAME.txt 2>&1						
	#echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/etc/profile은 'TMOUT=300', 'export TMOUT' 확인"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/etc/default/login은 'TIMEOUT=300' 확인"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "***************************** 3. 시스템 보안 ********************************************"		>> $HOSTNAME/$HOSTNAME.txt 2>&1	
echo "*****************************************************************************************" 		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "/etc/ 경로의 모든 파일의 권한 확인 " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1
ls -al /etc/  >> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US301. 사용자 기본 환경 파일의 권한이 적절한가?-------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -al /etc/profile $HOME/.profile $HOME/.login $HOME/.cshrc $HOME/.sh_history $HOME/.bash_history >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "환경 설정 파일의 접근권한을 640으로 설정함"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US302. /etc/(x)inetd.conf 파일 소유자 및 권한 설정이 적절한가?-------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -al /etc/profile $HOME/.profile $HOME/.login $HOME/.cshrc $HOME/.sh_history $HOME/.bash_history >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "환경 설정 파일의 접근권한을 640으로 설정함"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US303. /etc/syslog.conf 파일 소유자 및 권한 설정이 적절한가?-------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -al /etc/syslog.conf $HOME/.profile $HOME/.login $HOME/.cshrc $HOME/.sh_history $HOME/.bash_history >> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -al /etc/rsyslog.conf $HOME/.profile $HOME/.login $HOME/.cshrc $HOME/.sh_history $HOME/.bash_history >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "환경 설정 파일의 접근권한을 640으로 설정함"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US304. /etc/services 파일 소유자 및 권한 설정이 적절한가?-------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -al /etc/services $HOME/.profile $HOME/.login $HOME/.cshrc $HOME/.sh_history $HOME/.bash_history >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "환경 설정 파일의 접근권한을 640으로 설정함"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US305. /etc/hosts 파일의 내용 및 권한 설정이 적절한가?------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/hosts 파일 권한 설정 " 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -al $HOSTS											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/etc/hosts 설정 권한이 644이하, 소유주가 root인지 점검"						>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/hosts 파일 내용 확인 " 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $HOSTS											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US306. TMP 디렉토리의 권한을 Sticky bit로 설정 하였는가?----------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -ld /tmp /var/tmp										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@ 권고사항"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " /tmp, /var/tmp디렉토리의 권한이 1777(drwxrwxrwt)임을 확인"					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US307. 부팅 스크립트의 권한 설정이 적절한가?----------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/rc* 점검 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -alR /etc/rc*  										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /sbin/rc* 점검 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -alR /sbin/rc*										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/init* 점검 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -alR /etc/init*										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "부팅 스크립트 파일의 퍼미션은 '754'가 되도록 함"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US308. PATH 설정이 적절한가?--------------------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* bourn shell, ksh 일 경우"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/profile | grep -i path									>> $HOSTNAME/$HOSTNAME.txt 2>&1						
		cat $HOME/.profile | grep -i path								>> $HOSTNAME/$HOSTNAME.txt 2>&1						
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* C Shell일 경우"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/.login | grep -i path									>> $HOSTNAME/$HOSTNAME.txt 2>&1						
		cat $HOME/.cshrc | grep -i path									>> $HOSTNAME/$HOSTNAME.txt 2>&1						
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* BASH Shell일 경우"										>> $HOSTNAME/$HOSTNAME.txt 2>&1					
		cat $HOME/.bash_profile | grep -i path								>> $HOSTNAME/$HOSTNAME.txt 2>&1						
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* env 확인"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		env | grep -i path										>> $HOSTNAME/$HOSTNAME.txt 2>&1						
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "root계정의 PATH환경변수에 '.'이 포함되어 있는지 확인(제거)"					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US309. UMASK 설정이 적절한가?-------------------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
#	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
#	echo "* /etc/default/login 점검"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
#		cat $LOGIN_CONF | grep -i umask=								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/profile 점검"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/profile | grep -i umask								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* umask 명령확인"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		umask					 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "UMASK 값이 022 혹은 027인지 점검함"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US310. SUID/SGID의 설정이 적절한가?-------------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		find / \( -perm -04000 -o -perm -02000 \) -exec ls -al {} \;					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/usr/bin/chage, /usr/bin/gpasswd, /usr/bin/wall, /usr/bin/chfn, /usr/bin/newgrp"			>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/usr/bin/write, /usr/bin/at, /usr/sbin/usrnetctl, /usr/sbin/userhelper, /bin/mount"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/bin/umount, /usr/sbin/lockdev, /bin/ping, /usr/sbin/traceroute는 SUID/SGID 제거 권고"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 	
echo "-----US311. CPU 및 파일 시스템 사용률이 지나치게 높지 않은가?----------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 파일시스템 사용률" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		df -k												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "파일시스템 사용량이 80%이하인지 확인"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* CPU 사용률 - top 명령 " 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		top -n 2											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* CPU 사용률 - sar 명령 "										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		sar 2 10 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "CPU 사용량이 80%이하인지 확인함"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "***************************** 4. 서비스 보안 ********************************************"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "*****************************************************************************************" 		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1	
echo "-----US401. Finger(사용자 정보 확인) 서비스를 중지하였는가?----------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 취약한 r-명령어" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep 'rsh|rlogin|rexec|rcp'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "r-명령어가 NET Backup에 사용여부 확인"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 취약한 RPC 서비스" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep 'rpc.cmsd|rusersd|rstatd|rpc.statd|kcms_server|rpc.ttdbserverd|walld|rpc.nids|rpc.ypupdated|cachefsd|sadmind|sprayd|rpc.pcnfsd|rexed|rpc.rquotad' >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 기타 취약한 서비스" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep 'talk|uucp|finger|time|echo|discard|daytime|chargen|dtspcd|printer|tftp|dmi'	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "사용서비스 확인 요망"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US402. Anonymous FTP(익명 FTP) 서비스를 중지하였는가?--------------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* FTP 사용여부 확인 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep ftp | grep -v 'grep'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* $PASSWD에 ftp 계정 확인 " 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $PASSWD | grep -i ftp									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "Anonymous FTP 제한을 위해 ftp 계정 삭제확인"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US403. r command 서비스를 중지하였는가?----------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 취약한 r-명령어" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep 'rsh|rlogin|rexec|rcp'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "r-명령어가 NET Backup에 사용여부 확인"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 취약한 RPC 서비스" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep 'rpc.cmsd|rusersd|rstatd|rpc.statd|kcms_server|rpc.ttdbserverd|walld|rpc.nids|rpc.ypupdated|cachefsd|sadmind|sprayd|rpc.pcnfsd|rexed|rpc.rquotad' >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 기타 취약한 서비스" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep 'talk|uucp|finger|time|echo|discard|daytime|chargen|dtspcd|printer|tftp|dmi'	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "사용서비스 확인 요망"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US404. DoS 공격에 취약한 서비스를 중지하였는가?----------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 취약한 r-명령어" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep 'rsh|rlogin|rexec|rcp'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "r-명령어가 NET Backup에 사용여부 확인"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 취약한 RPC 서비스" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep 'rpc.cmsd|rusersd|rstatd|rpc.statd|kcms_server|rpc.ttdbserverd|walld|rpc.nids|rpc.ypupdated|cachefsd|sadmind|sprayd|rpc.pcnfsd|rexed|rpc.rquotad' >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 기타 취약한 서비스" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps aux | egrep 'talk|uucp|finger|time|echo|discard|daytime|chargen|dtspcd|printer|tftp|dmi'	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "사용서비스 확인 요망"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1	
echo "-----US405. 불필요한 NFS 서비스를 중지하였는가?-----------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* nfs 프로세스 확인"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep nfs										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/dfs/dfstab 점검"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		grep -v '^#' /etc/dfs/dfstab									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/exports 점검(linux)"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		grep -v '^#' /etc/exports									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "share 명령어 확인"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		share												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@ 권고사항"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " 쓰기권한으로 export시키지 않음. 읽기 모드로 사용하여야 하고"					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " 반드시 nfs를 사용해야 할 경우 보안설정(dfstab)에 주의함"						>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US406. tftp, talk 서비스를 중지하였는가?--------------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* FTP 사용여부 확인 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep ftp | grep -v 'grep'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* $PASSWD에 ftp 계정 확인 " 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $PASSWD | grep -i ftp									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* tftp 사용여부 확인 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep tftp | grep -v 'grep'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* talk 사용여부 확인 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep talk | grep -v 'grep'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* ntalk 사용여부 확인 " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep ntalk | grep -v 'grep'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* $PASSWD에 ftp 계정 확인 " 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $PASSWD | grep -i ftp									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "Anonymous FTP 제한을 위해 ftp 계정 삭제확인"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US407. SNMP community string을 추측하기 어렵게 설정 하였는가?-----------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* SNMP 사용여부 확인 - ps 명령"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep snmp | grep -v grep 								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* SNMP 사용여부 확인 - netstat 명령"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
		netstat -an | egrep ':161|.161'									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* snmpd.conf 파일에서 community 점검"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $SNMP_CONF | grep -i community								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "Snmp의 community을 정하는 규칙은 패스워드를 생성하는 규칙과 동일하게 적용"			>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US408. NFS 공유관련 취약점을 제거 하였는가?-----------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* nfs 프로세스 확인"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep nfs										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/dfs/dfstab 점검"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		grep -v '^#' /etc/dfs/dfstab									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/exports 점검(linux)"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		grep -v '^#' /etc/exports									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "share 명령어 확인"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		share												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@ 권고사항"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " 쓰기권한으로 export시키지 않음. 읽기 모드로 사용하여야 하고"					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " 반드시 nfs를 사용해야 할 경우 보안설정(dfstab)에 주의함"						>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US409. 서비스 배너에 시스템 정보를 제공하지 않는가?---------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* Telnet 배너 점검"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $TELNET_BANNER | grep -v '#'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* Ftp 배너 점검"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $FTP_BANNER | grep -v '#'									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/issue 메시지 점검" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/issue											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "'Authorized users only. All activity may be monitored and reported'와 같은 경고문 띄움"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "'본 시스템은 인가된 사용자만 사용할 수 있습니다. 시스템의 모든 작업행위는 모니터링 되며 위반행위는 법적 불이익을 받을 수 있습니다.'와 같은 경고문 띄움" >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US410. SNMP community string을 추측하기 어렵게 설정 하였는가?-----------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* SNMP 사용여부 확인 - ps 명령"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ps -ef | grep snmp | grep -v grep 								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* SNMP 사용여부 확인 - netstat 명령"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
		netstat -an | egrep ':161|.161'									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* snmpd.conf 파일에서 community 점검"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $SNMP_CONF | grep -i community								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "Snmp의 community을 정하는 규칙은 패스워드를 생성하는 규칙과 동일하게 적용"			>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1	
	echo "*********************************************ps 모든 프로세스 확인*********************************************"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	ps aux 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "*****************************************************************************************" 		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "******************************* 5. 모니터링 *********************************************"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "*****************************************************************************************" 		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1	
echo "-----US501. 로그기록 설정이 적절한가?----------------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "SYSLOG_CONF " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $SYSLOG_CONF | grep -v '^#'									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "rSYSLOG_CONF " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/rsyslog.conf 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
		
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/etc/syslog.conf 다음의 설정을 권고함"								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "mail.debug	/var/adm/syslog/mail.log" 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "*.info		/var/adm/syslog/syslog.log" 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "*.alert		/var/adm/syslog/syslog.log" 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "*.alert		/dev/console" 									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "*.alert		root" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "*.emerg		*" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "-----US502. SU 로그를 기록하고 있는가?---------------------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/default/su 점검" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/default/su | grep -i sulog								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/syslog.conf 점검" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $SYSLOG_CONF | grep -i auth									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* sulog 존재여부 확인"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -al /var/log/sulog										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* securelog 존재여부 확인"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/syslog.conf | egrep -i "auth|authpriv"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /var/log/ 존재여부 확인"									>> $HOSTNAME/$HOSTNAME.txt 2>&1
		ls -al /var/log							>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "/var/log/sulog 또는 /var/adm/secure를 기록하도록 설정하였는지 여부와 실제 sulog 존재 여부를 확인"	>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1


echo "***************************** 6. 기타 보안관리 *******************************************"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "*****************************************************************************************" 		>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " " 													>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo "-----US601. 로그온 시 접근 경고 메시지를 표시하는가?-------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* Telnet 배너 점검"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $TELNET_BANNER | grep -v '#'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* Ftp 배너 점검"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $FTP_BANNER | grep -v '#'									>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* /etc/welcome.msg, vsftpd.conf 메시지 점검" 							>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/welcome.msg										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /etc/vsftpd/vsftpd.msg | grep -i ftpd_banners						>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "'Authorized users only. All activity may be monitored and reported'와 같은 경고문 띄움"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "'본 시스템은 인가된 사용자만 사용할 수 있습니다. 시스템의 모든 작업행위는 모니터링 되며 위반행위는 법적 불이익을 받을 수 있습니다.'와 같은 경고문 띄움" >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "-----US602. 스케줄링(scheduling)의 작업내용 및 사용권한이 적절한가?----------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 주기적으로 수행되는 스케줄 내역 조회(cron)"							>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $PASSWD | awk -F: '{print $1}' | sort | uniq > tmp.tmp
		for HD in `cat tmp.tmp`
		do
		        echo $HD										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		        crontab -u $HD -l | grep -v '^#'								>> $HOSTNAME/$HOSTNAME.txt 2>&1
		        echo ".................................................................."		>> $HOSTNAME/$HOSTNAME.txt 2>&1
		done
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* 일회성으로 수행되는 스케줄 내역 조회(at)"	 						>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $PASSWD | awk -F: '{print $1}' | sort | uniq > tmp.tmp
		for HD in `cat tmp.tmp`
		do
		        echo $HD										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		        atq $HD											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		        echo ".................................................................."		>> $HOSTNAME/$HOSTNAME.txt 2>&1
		done
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* cron.allow 점검"										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $CRON_ALLOW											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* cron.deny 점검"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $CRON_DENY											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* at.allow 점검"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $AT_ALLOW											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "* at.deny 점검"											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat $AT_DENY											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "*.allow파일에는 이용할 사용자, *.deny파일에는 제한할 사용자 추가"					>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "-----US603. 최신의 시스템 패치가 설치되어 있는가?----------------------------------------"		>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
		uname -a											>> $HOSTNAME/$HOSTNAME.txt 2>&1
		rpm -qa | cut -f2 -d'' 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
		cat /proc/version       >> $HOSTNAME/$HOSTNAME.txt 2>&1
		dpkg -l | grep linux-generic  >> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "@권고사항" 											>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "Redhat 보안 사이트" 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo "http://www.redhat.com/security/updates/"				 				>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo ". "												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	echo " " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	
rm tmp.tmp

echo " "
echo "* System Information Query End "
echo " "
echo "* System Information Query End " 										>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " "													>> $HOSTNAME/$HOSTNAME.txt 2>&1

echo "* End Time "
	date
echo " "

echo "* End Time " 												>> $HOSTNAME/$HOSTNAME.txt 2>&1
	date 													>> $HOSTNAME/$HOSTNAME.txt 2>&1
echo " "													>> $HOSTNAME/$HOSTNAME.txt 2>&1

tar -cvf $HOSTNAME.tar $HOSTNAME
rm -rf $HOSTNAME
exit 0