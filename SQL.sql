USE ProjectMSSQL
GO
CREATE TABLE Users(
IdUser int not null,
Name varchar(50) not null,
DataBird Date null,
Email  varchar null,
Position varchar(20),
Status_ bit not null,
Foto varbinary(max) null,
Login_ varchar(25) null, 
SID_ varchar(25) null,
CONSTRAINT PK_Id_User PRIMARY KEY CLUSTERED(IdUser)
);
GO
--ALTER TABLE Users
--ADD CONSTRAINT PK_Users_Id PRIMARY KEY CLUSTERED(Id)
--GO
CREATE TABLE Groups
(
IdGroup int  IDENTITY(1,1)not null,
NameGroup varchar(25) not null,
IdRoles int not null,
CONSTRAINT PK_IdGroup PRIMARY KEY CLUSTERED(IdGroup),
CONSTRAINT FK_Id_Role FOREIGN KEY(IdRoles) REFERENCES Roles(IdRole)
);
GO

SELECT * FROM Groups
--ALTER TABLE Groups
--ADD FK_Id_Role  CONSTRAINT FOREIGN KEY(Roles) REFERENCES Roles(IdRole)
--GO

CREATE TABLE Users_Group
(
[Id] int IDENTITY(1,1) NOT NULL, 
IdUser int not null,
IdGroup int not null,
PRIMARY KEY CLUSTERED([Id] ASC),
CONSTRAINT FK_Users FOREIGN KEY(IdUser) REFERENCES Users(IdUser),
CONSTRAINT FK_Group FOREIGN KEY(IdGroup) REFERENCES Groups(IdGroup)
);
GO
SELECT * FROM Users_Group
GO
ALTER TABLE Users_Group ADD CONSTRAINT FK_Group FOREIGN KEY(IdGroup) REFERENCES Groups(IdGroup)
GO

CREATE TABLE Roles
(
IdRole int not null ,
Roles varchar(25) not null,
CONSTRAINT PK_Id_Role PRIMARY KEY CLUSTERED(IdRole)
);
GO

CREATE TABLE Ranks
(
IdRank int not null,
Ranks varchar(25) not null,
primary key(IdRank)
);
GO

CREATE TABLE Users_Ranks
(
[Id]  INT IDENTITY(1,1) NOT NULL,
IdUser int not null,
IdRank int not null,
Months int not null,
Data Date not null
PRIMARY KEY CLUSTERED ([Id] ASC)
CONSTRAINT FK_UsersRank FOREIGN KEY(IdUser) REFERENCES Users(IdUser),
CONSTRAINT FK_Rank FOREIGN KEY(IdRank) REFERENCES Ranks(IdRank)
);
--GO
--ALTER TABLE Users_Ranks DROP CONSTRAINT FK_Rank
--GO

CREATE TABLE [dbo].[Statuses]
(
IdStatus int  not null,
NameStatus char(10) not null
PRIMARY KEY CLUSTERED ([IdStatus] ASC)
);

CREATE TABLE [dbo].[Project]
(
IdProject INT IDENTITY(1,1) not null,
DateStart Date not null,
DateEnd Date  null,
IdStatus int  null,
PRIMARY KEY CLUSTERED ([IdProject] ASC)
CONSTRAINT FK_Project_Stauses FOREIGN KEY(IdStatus) REFERENCES Statuses(IdStatus)
);

GO
ALTER TABLE Project ADD CONSTRAINT CK_Check_DateStart_DateEnd
CHECK (DateStart IS NOT NULL AND  NOT ( DateStart > DateEnd))
GO


CREATE TABLE [dbo].[Project_Users]
(
Id int IDENTITY(1,1) not null,
Id_User int not null,
IdProject int not null,
HeadProjectId  INT  NULL,
PRIMARY KEY CLUSTERED (Id ),
CONSTRAINT FK_Project_Users_Project FOREIGN KEY([IdProject]) REFERENCES Project([IdProject]),
);

GO
ALTER TABLE [dbo].[Project_Users] ADD CONSTRAINT CK_Check_IdUser_HeadProjectId
CHECK (Id_User IS NOT NULL AND HeadProjectId IS NULL OR Id_User IS NOT NULL AND HeadProjectId IS NOT NULL)

ALTER TABLE [dbo].[Project_Users]  WITH CHECK ADD  CONSTRAINT [FK_Project_Users_HeadProjectId] FOREIGN KEY([HeadProjectId])
REFERENCES [dbo].[Users] ([IdUser])
GO

ALTER TABLE [dbo].[Project_Users] CHECK CONSTRAINT [FK_Project_Users_HeadProjectId]
GO

ALTER TABLE [dbo].[Project_Users] WITH CHECK ADD  CONSTRAINT [FK_Project_Users_Users] FOREIGN KEY([Id_User])
REFERENCES [dbo].[Users] ([IdUser])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Project_Users] CHECK CONSTRAINT [FK_Project_Users_Users]
GO


CREATE TABLE [dbo].[Tasks]
(
[IdTask] INT IDENTITY(1,1) not null,
[DateStart] Date not null,
[DateEnd] Date  null,
[IdStatus] int  not null,
[Discribe] VARCHAR(100) NOT NULL,
[UserId] INT NOT NULL,
[IdProject]INT NOT NULL,
PRIMARY KEY CLUSTERED ([IdTask]),
CONSTRAINT FK_Tasks_UserId FOREIGN KEY([UserId]) REFERENCES  [dbo].[Users] ([IdUser]),
CONSTRAINT FK_Tasks_IdStatus FOREIGN KEY([IdStatus]) REFERENCES  [dbo].[Statuses] ([IdStatus]),
CONSTRAINT FK_Tasks_IdProject FOREIGN KEY([IdProject]) REFERENCES  [dbo].[Project] ([IdProject])
);


CREATE TABLE TimeTracking
(
[IdTimeTracking] INT NOT NULL,
[IdUser] INT NOT NULL,
[vDate] Date NOT NULL,
[SpendTime] INT NOT NULL,
[IdTask] INT NOT NULL,
CONSTRAINT FK_TimeTracking_UserId FOREIGN KEY([IdUser]) REFERENCES  [dbo].[Users] ([IdUser]),
CONSTRAINT FK_TimeTracking_IdTasks FOREIGN KEY([IdTask]) REFERENCES  [dbo].[Tasks] ([IdTask])
);



CREATE TABLE [dbo].[History]
(
[IdHistory] Int NOT NULL,
[IdUser] INT NOT NULL,
[vDate] Date  NOT NULL,
[Operation] VARCHAR(25) NOT NULL,
[AttribureChanged] VARCHAR(25)  NULL,
CONSTRAINT FK_History_UserId FOREIGN KEY([IdUser]) REFERENCES  [dbo].[Users] ([IdUser]),
);











