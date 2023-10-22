#!/bin/bash

#Note: The Bellow Variables must be Defined and Exported  in /etc/profile/ and /etc/bashrc To  Be Used And Understood By Ssh Came Back to the Nginx Server Itself And Must  Be Sourced By Running   source /etc/profile and source /etc/bashrc
#Path_To_Nginx_Config=/appserver/nginx/nginx-1.8.1/conf/nginx.conf 
#Path_to_CheckLogin=/home/zabbix/script/checkLogin.sh  
#Path_to_Scripts_Folder=/appserver/crontabjobs/
#Ip_List=$( grep "^ *server [1-9].*;"  $Path_To_Nginx_Config | egrep  [1-9.]* | tr -s " " | cut -f 3 -d " " | cut -d : -f 1| awk 'BEGIN{ORS=" ";OFS=" "}   {print $0}')


Ip_List=$(expand -t 8 $Path_To_Nginx_Config|  grep "^ *server [1-9].*;" -| egrep  [1-9.]* | tr -s " " | cut -f 3 -d " " | cut -d : -f 1| awk 'BEGIN{ORS=" ";OFS=" "}   {print $0}')


for i in $Ip_List;


do  echo $i >/appserver/IP;echo Checking IP $(cat /appserver/IP)  Health Is In Progress*****;

ssh  $i ' if [  `$Path_to_CheckLogin` != '1' ]
then 

ssh `echo $SSH_CLIENT| awk "{ print $1 }"|cut -d " " -f 1`       "${Path_to_Scripts_Folder}sedremove.sh;echo ' Upstream $(cat /appserver/IP) Has Been Commented at $(date)  Because of CheckLogin Failure !!!' >> ${Path_to_Scripts_Folder}NginxHealthCheck.log;service nginx reload";

while [ 1 ]

do 
   sleep 10

   if [  `$Path_to_CheckLogin` != '0' ]

   then
 
   ssh `echo $SSH_CLIENT| awk "{ print $1 }"|cut -d " " -f 1` "${Path_to_Scripts_Folder}sedrecover.sh;echo ' Upstream $(cat /appserver/IP) Has Been Recovered--UnCommented---  at $(date)' >> ${Path_to_Scripts_Folder}NginxHealthCheck.log;service nginx reload"

break
  fi
done

     fi'

done



