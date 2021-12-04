create table sorting ( 
	Input varchar(1)
);

insert into sorting
	values ('A'), ('C'), ('D'), ('C'), ('D'), ('D'), ('B');
	
select Input as Output, unicode(Input)-64 as SortOrder from sorting order by SortOrder;