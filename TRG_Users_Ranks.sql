USE [ProjectMSSQL]
GO
/****** Object:  Trigger [dbo].[TRG_Users_Ranks]    Script Date: 11/3/2016 3:39:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TRG_Users_Ranks] on [dbo].[Users_Ranks]
INSTEAD OF INSERT
AS
SET NOCOUNT ON;
BEGIN TRY
	BEGIN TRANSACTION		
	SAVE TRAN TriggerTran
    BEGIN	 
	 INSERT INTO Users_Ranks(IdUser,IdRank,Months,Data) SELECT IdUser,IdRank,Months,Data  
	 FROM inserted 
	 WHERE (SELECT  COUNT(*) from dbo.Users_Ranks UR  WHERE inserted.IdUser=UR.IdUser AND  MONTH(Data)=  MONTH(GETDATE())) <=1	 
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
