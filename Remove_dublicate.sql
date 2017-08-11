use shopDB

select * from dbo.Products

DELETE FROM dbo.Products
WHERE ProdID = (select max(ProdID)
from dbo.Products
group by Description
having count(*) >1)


DELETE FROM dbo.Products  
WHERE ProdID > (select MIN(ProdID)
                from dbo.Products as t2
                where t2.Description = dbo.Products.Description)

GO
ALTER TABLE dbo.Products
DROP COLUMN ProdID;
GO
ALTER TABLE dbo.Products
ALTER COLUMN name VARCHAR(50) NOT NULL;
GO
ALTER TABLE dbo.Products
ADD CONSTRAINT T_PK PRIMARY KEY(name);
GO

