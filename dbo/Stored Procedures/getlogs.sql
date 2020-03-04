create proc getlogs(@count int)  
as  
begin  
select top (@count) * from tbl_ErrorLog order by 1 desc   
end