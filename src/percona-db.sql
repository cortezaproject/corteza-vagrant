create database corteza;
create user 'corteza'@'localhost' identified by 'corteza';
GRANT ALL PRIVILEGES ON * . * TO 'corteza'@'localhost';
flush privileges;