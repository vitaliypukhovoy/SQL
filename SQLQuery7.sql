use Example
CREATE TABLE dbo.TypeNews
(
  typeid INT PRIMARY KEY NOT NULL IDENTITY(1,1),
  typename VARCHAR(50) NULL
 );

CREATE TABLE dbo.News
(
  newsid INT NOT NULL IDENTITY(1,1),
  ntypeid INT NOT NULL,
  newsname VARCHAR(50) NULL,
  newsdata date not null,
  CONSTRAINT FK_News_TypeNews FOREIGN KEY (ntypeid)
  REFERENCES dbo.TypeNews (typeid)
);


select
ntypeid,
min(newsid),
--newsname,
min(newsname),
max (newsdata)
from dbo.News
group by  ntypeid

select 
*
from dbo.news


use Example
go
WITH castNews(id,nameNews,newsdata, rows_group) AS
(
select
n.ntypeid as id,
n.newsname as nameNews,
n.newsdata as newsdata,
n.rows_group as rows_group
from(select 
newsid,
ntypeid,
newsname,
newsdata,
ROW_NUMBER() over (partition by ntypeid order by newsdata  DESC) as rows_group
from dbo.News) as n
where rows_group = 1
)
select T.typeid, T.typename , N.nameNews, N.newsdata, N.rows_group from TypeNews as T
left join castNews as N on
t.typeid = n.id


use Example
go
WITH castNews(id,nameNews,newsdata, rows_group) AS
(
select
n.ntypeid as id,
n.newsname as nameNews,
n.newsdata as newsdata,
n.rows_group as rows_group
from(select 
newsid,
ntypeid,
newsname,
newsdata
--ROW_NUMBER() over (partition by ntypeid order by newsdata  DESC) as rows_group
from dbo.News) as n
where rows_group = 1
)
select T.typeid, T.typename , N.nameNews, N.newsdata, N.rows_group from TypeNews as T
left join castNews as N on
t.typeid = n.id