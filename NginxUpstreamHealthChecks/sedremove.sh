sed -i 's/server\ '$(cat /appserver/IP)'/#server\ '$(cat /appserver/IP)'/g' $Path_To_Nginx_Config
