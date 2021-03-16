CREATE DATABASE wordpress;
CREATE USER 'omar'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'omar'@'localhost';
FLUSH PRIVILEGES;
QUIT