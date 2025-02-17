-- Add User Procedure
CREATE procedure AddUser(
    in p_username VARCHAR(100),
    in p_email VARCHAR(100),
    in p_phone INT NOT NULL,
    in p_role VARCHAR(50),
) begin
declare v_email int;
declare v_phone int;
SELECT count(*) into v_email
from Users
WHERE email = p_email;
SELECT count(*) into v_phone
from users
where phone = p_phone;
if v_email = 0
and v_phone then
insert into Users (username, email, phone, role)
values (p_username, p_email, p_phone, p_role);
else SIGNAL SQLSTATE 45000
set MESSAGE_TEXT = 'email or phone already exists';
end if;
-- update Procedure --
CREATE PROCEDURE UpdateUser(
    IN p_id_user INT,
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone INT NOT NULL,
    IN p_role VARCHAR(50)
) BEGIN
DECLARE user_exists INT;
SELECT COUNT(*) INTO user_exists
FROM Users
WHERE id_user = p_id_user;
IF user_exists = 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'User not found';
ELSE
UPDATE Users
SET username = p_username,
    email = p_email,
    phone = p_phone,
    role = p_role
WHERE id_user = p_id_user;
END IF;
END;
-- delete procedure --
REATE procedure DeleteUser(in p_id_user int) begin if(
    select count(*) Users
    where id_user = p_id_user
) = 0 then SIGNAL SQLSTATE
set MESSAGE_TEXT = 'user not found';
else
delete from Users
where id_user = p_id_user;
end if;
end;
-- get count user function --
CREATE function GetCountUser() returns int begin
declare Total_user int;
select count (*) into Total_user
from Users;
return Total_user
end;
-- get all users --
procedure GetAllUsers() begin
select *
from Users;
end;
-- after delete user procedure --
CREATE trigger afetr_user_delete
after delete on Users for each row begin
insert into DeleteUsers(id_user, username, email, phone, role)
values (
        OLD.id_user,
        OLD.username,
        OLD.email,
        OLD.phone,
        OLD.role
    );
end;
-- get user by id --
CREATE PROCEDURE GetUserById(in p_id_user int) begin
select *
from Users
where id_user = p_id_user;
end;