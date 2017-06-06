SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER dbo.TRG_Users_Group on dbo.Users_Group
INSTEAD OF INSERT
AS
BEGIN
     INSERT INTO dbo.Users_Group(IdUser)
	 SELECT IdUser
	 FROM INSERTED i
	 WHERE (SELECT max(IdUser) from dbo.Users_Ranks)<=2 

	 INSERT INTO dbo.Users_Group(IdUser)
	 SELECT 0
	 FROM INSERTED
	 WHERE  (SELECT max(IdUser) from dbo.Users_Ranks)>2 
END


