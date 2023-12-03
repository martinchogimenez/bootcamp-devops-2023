
#!/bin/bash

#variables
REPO="bootcamp-devops-2023"

USERID=$(id -u)
#colores
LRED='\033[1;31m'
LGREEN='\033[1;32m'
NC='\033[0m'
LBLUE='\033[0;34m'
LYELLOW='\033[1;33m'

#Actualizando
apt-get update

echo "El servidor está actualizado"


if [ "${USERID}" -ne 0 ]; then
    echo -e "\n${LRED}Correr con usuario ROOT${NC}"
    exit
fi


if dpkg -l |grep -q git ;
then
        echo "ya esta instalado"
else
        echo "instalando paquete" 
        apt install git -y 
fi

###Instalación Apache ######
if dpkg -l |grep -q apache2 ;
then
    echo "ya esta instalado"
else
        echo "instalando paquete" 
        apt install apache2 -y 
        apt install -y php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl
        systemctl start apache2
        systemctl enable apache2
fi


###base de datos maria db ######
if dpkg -s mariadb-server > /dev/null 2>&1; then
    echo -e "\n${LBLUE}El servidor se encuentra Actualizado ...${NC}"
else
    echo -e "\n${LYELLOW}instalando MARIA DB ...${NC}"
    apt install -y mariadb-server
fi
###Iniciando la base de datos
    systemctl start mariadb
    systemctl enable mariadb

echo -e "\n${LBLUE}Configurando base de datos ...${NC}"

###Configuracion de la base de datos
mysql -e "
CREATE DATABASE devopstravel;
CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
flush privileges;"

###Carga de datos iniciales a la base de datos

mysql < database/devopstravel.sql



if [ -d "$REPO" ] ;
then    
    echo "la carpeta $REPO existe"
    cd ${REPO}
    git pull origin clase2-linux-bash
else
    echo "instalando web"
    sleep 1
    git clone https://github.com/roxsross/$REPO.git
    cd ${REPO}
    #git checkout clase2-linux-bash
    git pull origin clase2-linux-bash
    echo $REPO
fi

sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php
  
curl http://localhost

#reload
systemctl reload apache2