USE [ProjectMSSQL]
GO
/****** Object:  Trigger [dbo].[TRG_Users_Group]    Script Date: 11/3/2016 3:40:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TRG_Users_Group] on [dbo].[Users_Group]
INSTEAD OF INSERT,UPDATE,DELETE
AS
DECLARE @action_type int;
DECLARE @sysadmin SYSNAME;
SELECT @action_type = case
                       when i.IdUser is not null and d.IdUser is     null then 1 -- insert
                       when i.IdUser is not null and d.IdUser is not null then 2 -- update
                       when i.IdUser is     null and d.IdUser is not null then 3 -- delete
                     end
from      inserted i
full join deleted  d on d.IdUser = i.IdUser;

SELECT @sysadmin = (SELECT r.name  as vRole 
FROM sys.server_role_members m JOIN
sys.server_principals r ON m.role_principal_id = r.principal_id  JOIN
sys.server_principals u ON m.member_principal_id = u.principal_id 
WHERE u.name = SUSER_SNAME());


BEGIN TRY
	BEGIN TRANSACTION
	SAVE TRAN TriggerTran		
 IF (@action_type = 1 AND @sysadmin='sysadmin')
	 BEGIN	 
	 INSERT INTO dbo.Users_Group (IdGroup,IdUser,IdRoles) SELECT I.IdGroup,I.IdUser,I.IdRoles FROM inserted I 	 	 
	 END
	 ELSE IF (@action_type = 3 AND @sysadmin='sysadmin')
	 BEGIN
	 DELETE FROM Users_Group
	 WHERE Id  IN(SELECT D.Id FROM deleted D)
	 PRINT ('DELETE');
	 END
	ELSE IF (@action_type = 2 AND @sysadmin='sysadmin')
	 BEGIN  	   	                 
	 UPDATE Users_Group SET  IdGroup =I.IdGroup, IdUser = I.IdUser, IdRoles = I.IdRoles  FROM Users_Group U INNER JOIN  inserted  I 
	 ON U.Id = I.Id
	 WHERE U.Id = I.Id
	 END
 COMMIT
 END TRY

 BEGIN CATCH	
	BEGIN
	    RAISERROR('You don t have permission to change data ',16,1);
		ROLLBACK TRAN TriggerTran										
		COMMIT																	
	END
END CATCH