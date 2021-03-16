FROM debian:buster

# default-mysql-server INSTALLS THE PACKAGE FOR THE DEFAULT MySQL
# SERVER (MariaDB) IN DEBIAN, AS WELL AS THE PACKAGES FOR THE CLIENT
# AND FOR THE DATABASE COMMON FILES.
RUN apt-get update && apt-get install -y \
	nginx \
	default-mysql-server \
	php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common \
	php7.3-json php7.3-opcache php7.3-readline php7.3-mbstring php7.3-xml \
	openssl \
	wget

# THE DEBIAN REPOSITORY DOES NOT CONTAIN PACKAGES FOR wordpress AT THIS TIME,
# AND THE phpmyadmin DEBIAN PACKAGE CONFIG MIGHT DIFFER FROM THE OFFICIAL DOCS
# ONE. THEREFORE WE USE wget TO DOWNLOAD THEM FROM THEIR RESPECTIVE REPOSITORIES. 
RUN wget https://wordpress.org/latest.tar.gz -P /tmp/wp \
	&& wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.tar.gz -P /tmp/pma

# openssl ALLOWS US TO OBTAIN OUR OWN SSL CERTIFICATE. -out AND -keyout INDICATE
# WHERE TO STORE THE GENERATED CERTIFICATE AND KEY RESPECTIVELY. 
# THE openssl COMMAND LAUNCHES A COMMAND PROMPT TO ANSWER A SERIES OF QUESTIONS
# THAT NEED TO BE ANSWERED TO GENERATE THE CERTIFICATE. THE -subj FLAG ALLOWS US
# TO PROVIDE THE ANSWERS TO THOSE QUESTIONS WITHOUT OPENING A COMMAND PROMPT. 
RUN openssl req -x509 -out /etc/ssl/certs/localhost.crt \
	-keyout /etc/ssl/private/localhost.key \
	-newkey rsa:2048 -nodes -sha256 -subj '/C=ES/CN=localhost'

# COPY THE srcs FOLDER TO ONE OF THE SAME NAME INSIDE THE IMAGE.
COPY ./srcs ./srcs

# REMOVE THE DEFAULT nginx CONFIGURATION AND APPLY OUR OWN CONFIGURATION FILE
# FOR my_website.
RUN rm /etc/nginx/sites-enabled/default \
	&& mkdir /var/www/my_website \
	&& mv /srcs/index.html /var/www/my_website/index.html \
	&& mv /srcs/my_website.conf /etc/nginx/sites-available/ \
	&& ln -s /etc/nginx/sites-available/my_website.conf /etc/nginx/sites-enabled/

# INSTALLATION AND CONFIGURATION OF phpmyadmin AND wordpress IMPORTING OUR OWN
# CONFIGURATION FILES.
# --strip-components=1 DELETES GIVEN NUMBER OF LEADING COMPONENTS (or directories)
# FROM FILE NAMES BEFORE EXTRACTION. IN THIS CASE, DOWNLOADS wordpress CONTENTS IN 
# /var/www/my_website INSTEAD OF /var/www/my_website/wordpress, SO IT COULD BE SAID
# THAT ELIMINATES A DIRECTORY LEVEL FROM THE EXTRACTED FILES.
# -C CAUSES THE COMMAND TO EXECUTE INSIDE THE SPECIFIED PATH INSTEAD OF THE CURRENT
# WORKING DIRECTORY. ADDING file_1 AND file_2 TO THE autoindex FOLDER FOR TESTING
# THE AUTOINDEX FUNCTION OF nginx. FINALLY, ALL FILES' PERMISSIONS UNDER my_website
# DIRECTORY ARE MODIFIED TO ALLOW THE OWNER TO READ, WRITE AND EXECUTE ANY OF THEM,
# AND USER GROUPS AND OTHERS ONLY READ AND EXECUTE. AND THEN THE OWNER OF THAT
# SAME FOLDER IS CHANGED TO www-data USER AND GROUP, WHICH IS NGINX'S DEFAULT USER.
RUN mkdir /var/www/my_website/pma \
	&& mkdir /var/www/my_website/wp \
	&& mkdir var/www/my_website/autoindex \
	&& tar -xzf /tmp/pma/phpMyAdmin-5.1.0-all-languages.tar.gz --strip-components=1 -C /var/www/my_website/pma \
	&& tar -xzf /tmp/wp/latest.tar.gz --strip-components=1 -C /var/www/my_website/wp \
	&& mv /srcs/config.inc.php /var/www/my_website/pma/ \
	&& mv /srcs/wp-config.php /var/www/my_website/wp/ \
	&& mv /srcs/file_1.html var/www/my_website/autoindex/ \
	&& mv /srcs/file_2.html var/www/my_website/autoindex/ \
	&& chmod -R 755 /var/www/my_website \
	&& chown -R www-data:www-data /var/www/my_website

# INITIATING mysql FOR SQL COMMANDS EXECUTION. CREATION OF wordpress AND 
# phpmyadmin DATABASES. CREATION OF USERS TO ACCESS THOSE DATABASES BY PROVIDING
# THEM THE NECESSARY PRIVILEGES. 
# THE mysql COMMAND ALLOWS US TO EXECUTE SQL COMMANDS UNTIL EXECUTING quit.
# WITH < IT IS POSSIBLE TO EXECUTE SQL COMMANDS FROM .sql FILES.
# NORMALLY, FOR EXECUTING mysql, IT IS NECESSARY TO ENTER THE SYSTEM USER AND
# PASSWORD LIKE THIS: mysql -u root < srcs/wp_db.sql, BUT WHEN INSTALLING mysql
# IN DEBIAN WITHOUT mysql_secure_installation, THE root USER DOES NOT NEED
# TO PROVIDE A password, THEREFORE A PASSWORD SHOULD BE CONFIGURED FOR THE SYSTEM
# TO ASK THE USER AND PASSWORD EACH TIME mysql IS EXECUTED.
# mysql < /srcs/root_creds.sql MODIFIES THE root password (BECAUSE I DON'T KNOW
# WHICH IS THE DEFAULT ONE) IN ORDER TO ACCESS phpmyadmin WITH THIS USER AND
# CHECK IF IT HAS PRIVILEGES TO CREATE DATABASES. THE OTHER USERS WE CREATED CAN'T,
# BECAUSE WE GAVE THEM PRIVILEGES OVER SPECIFIC DATABASES.
RUN service mysql start \
	&& mysql < /srcs/wp_db.sql \
	&& mysql < var/www/my_website/pma/sql/create_tables.sql \
	&& mysql < /srcs/pma_db.sql \
	&& mysql < /srcs/root_creds.sql 

# REMOVES THE UNNECESARY FOLDERS WE CREATED.
RUN rm -rf /srcs \
	&& rm -rf /tmp/pma \
	&& rm -rf /tmp/wp

# THE PORTS THAT THE CONTAINER WILL EXPOSE FOR CONNECTING TO THE INTERNET.
# 80 FOR http AND 443 FOR https.
# WHEN CREATING AND RUNNING A CONTAINER BASED ON THIS IMAGE, IT WILL BE NECESSARY
# TO INCLUDE THESE PORTS IN THE docker run COMMAND.
EXPOSE 80 443

# IF ONLY THE nginx SERVICE HAD TO BE EXECUTED, CMD ["nginx", "-g", "daemon off;"]
# WOULD BE USED. BUT AS WE HAVE TO RUN 3 DIFFERENT SERVICES AT THE SAME TIME,
# && IS USED TO CONCATENATE EACH EXECUTION COMMAND IN JUST ONE CMD INSTRUCTION.
# THIS IS DONE, BECAUSE THERE CAN BE ONLY ONE CMD INSTRUCTION IN EACH IMAGE.
# WE COULD HAVE USED AN .sh SCRIPT EXECUTING IT WITH THE CMD INSTRUCTION AND
# THE EXECUTE THE 3 SERVICES FROM THE SCRIPT FILE.
# WITHOUT daemon off NGINX DOES NOT KEEP RUNNING INSIDE A DOCKER CONTAINER,
# IT SHUTS DOWN IMMEDIATELY. INSTEAD OF INCLUDING daemon off IN THE EXECUTION
# COMMAND, IT COULD BE ADDED TO THE nginx.conf FILE
# USING THIS COMMAND: RUN echo "daemon off;" >> /etc/nginx/nginx.conf
# BEFORE EXECUTING THE nginx SERVICE. nginx GETS EXECUTED AFTER THE OTHER
# PROCESSES BECAUSE daemon off MAKES IT RUN IN THE FOREGROUND, SO IF IT WAS
# EXECUTED IN THE FIRST PLACE, THE OTHER PROCESSES WOULDN'T GET EXECUTED
# UNTIL nginx TERMINATES.
CMD service php7.3-fpm start \
	&& service mysql start \
	&& nginx -g "daemon off;"
