USE [ProjectMSSQL]
GO
/****** Object:  Trigger [dbo].[TRG_Users]    Script Date: 11/3/2016 3:40:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TRG_Users] on [dbo].[Users]
--WITH EXECUTE AS OWNER 
INSTEAD OF INSERT,UPDATE,DELETE
AS
SET XACT_ABORT ON
SET NOCOUNT ON;

DECLARE @DomainLogin NVARCHAR(50);
DECLARE @sysadmin SYSNAME;
DECLARE @SID AS VARBINARY(MAX);
DECLARE @action_type INT;

SET  @DomainLogin =SUSER_SNAME(); 
SET @SID= SUSER_SID(SUSER_SNAME()); 

SELECT @action_type =CASE
                       WHEN i.IdUser is not null and d.IdUser is     null THEN 1 
                       WHEN i.IdUser is not null and d.IdUser is not null THEN 2 
                       WHEN i.IdUser is     null and d.IdUser is not null THEN 3 
                     END
                     FROM      inserted i
                     FULL join deleted  d ON d.IdUser = i.IdUser;

SELECT @sysadmin = (SELECT r.name  as SrvRole 
FROM sys.server_role_members m JOIN
sys.server_principals r ON m.role_principal_id = r.principal_id  JOIN
sys.server_principals u ON m.member_principal_id = u.principal_id 
WHERE u.name = SUSER_SNAME());

BEGIN TRY
	BEGIN TRANSACTION		
	SAVE TRAN TriggerTran	
    IF (@action_type = 1 AND @sysadmin='sysadmin')
	 BEGIN	 
	 INSERT INTO Users (Name,DataBird,Email,Position,Status_,Foto,DomainLogin,SID_,IdRoles) SELECT Name,DataBird,Email,Position,Status_,Foto,DomainLogin=@DomainLogin,SID_=@SID,IdRoles  FROM inserted 	 	 
	 END
	ELSE IF (@action_type = 3 AND @sysadmin='sysadmin')
	 BEGIN
	 DELETE FROM Users 
	 WHERE  IdUser IN(SELECT D.IdUser FROM deleted D)
	 PRINT ('DELETE');
	 END
	ELSE IF (@action_type = 2 AND  @sysadmin='sysadmin')
	 BEGIN  	   	                 
	 UPDATE Users SET  Name = I.Name,DataBird=I.DataBird,Email= I.Email,Position= I.Position,Status_= I.Status_,Foto= I.Foto,DomainLogin= @DomainLogin,SID_ = @SID,IdRoles = I.IdRoles  FROM Users U INNER JOIN  inserted  I 
	 ON U.IdUser = I.IdUser
	 WHERE U.IdUser = I.IdUser
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