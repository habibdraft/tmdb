create table employees (
              employee_id int primary key, 
              employee_name varchar(50), 
              manager_employee_id int
              );
          
          create table projects (
              project_id int primary key, 
              project_name varchar(50)
              );
          
          create table employee_projects (
              employee_id int, 
              project_id int, 
              constraint fk_employee foreign key (employee_id) references employees(employee_id),
              constraint fk_project foreign key (project_id) references projects(project_id)
              );


insert into employees
	values (1, 'A', 2), (2, 'C', 4), (3, 'D', 2), (4, 'F', 0), (5, 'L', 4), (6, 'J', 4), (7, 'M', 2)

insert into projects
	values (1, 'B'), (2, 'L'), (3, 'M'), (4, 'K'), (5, 'X'), (6, 'F'), (7, 'Z')

insert into employee_projects
	values (1, 2), (2, 4), (3, 4), (4, 7), (5, 7), (6, 5), (7, 1)

create table employee_levels as
with employee_levels as (
        select employee_id, manager_employee_id, employee_name, 1 as level from employees
        where manager_employee_id = 0
        union all
        select c.employee_id, c.manager_employee_id, c.employee_name, level+1
        from employees c
        join employee_levels p
        on c.manager_employee_id = p.employee_id
        )
select * from employee_levels

select e.employee_id as most_senior_employee_id, p.project_id, min(e.level) as level_of_most_senior_employee from employee_levels as e, projects as p, employee_projects as ep 
where e.employee_id = ep.employee_id and p.project_id = ep.project_id
group by p.project_id
