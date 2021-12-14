create user 'rosana';

select * from mysql.user;

drop user 'rosana';

create user 'rosana' identified by '123';

select * from mysql.user;

show grants for rosana;

grant select, insert, update, delete on cafe.funcionario to rosana;
grant select, insert, update on cafe.propriedade to rosana;
flush privileges;

show grants for rosana;
#grant select on cafe.* to rosana;
#revoke select on cafe.propriedade from rosana;

revoke insert on cafe.funcionario from rosana;

flush privileges;

show grants for rosana;

grant select (idCultura, descCultura, dataExclusao) 
on cafe.cultura to rosana;

show grants for rosana;

create user 'pulguinha'@'localhost' identified by '123';
grant select on cafe.* to pulguinha@localhost;
flush privileges;

show grants for rosana;
show grants for pulguinha@localhost;

#super user (ower of cafe)
grant all privileges on cafe.*  
to rosana with grant option;

flush privileges;

show grants for rosana;

#dba user
grant all privileges on *.*  to rosana with grant option;
flush privileges;
show grants for rosana;

select * from mysql.user;
#GRANT USAGE ON *.* TO 'rosana'@'%' IDENTIFIED BY PASSWORD '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257';


revoke all privileges, grant option from 'rosana'@'%';

show grants for rosana;
drop user pulguinha@localhost;
drop user rosana;

