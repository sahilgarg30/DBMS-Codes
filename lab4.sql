create table Employee(
Empno varchar(10) primary key,
EmpName varchar(20) not null,
Sex varchar(1) not null,
Salary  numeric(10,2) default(1000) not null,
Address varchar(20) not null,
DNo varchar(5),
check(Sex in ('M','F'))
);

create table Dept(
DNo varchar(5) primary key,
DeptName varchar(10) unique,
location varchar(10)
);

alter table Employee
add constraint fk foreign key(DNo) references Dept(DNo);

	insert into Dept values('CS101','Comp.Sci', ' AB5');
	insert into Dept values('EE420','Elec.','AB2');
	insert into Dept values('EC101','Elecn','AB5');
	insert into Employee values('160905286','Rishabh','M',1548693,'MIT Hostels','CS101');
	insert into Employee values('160905288','Arusha','F',1548293,'MIT Hostels','EE420');
	insert into Employee values('160905296','Somiya','F',1548993,'MIT Hostels','EC101');
	insert into Employee values('160909286','Nishchay','M',13348693,'MIT Hostels','CS101');
	insert into Employee values('160905386','Ankur','M',15489693,'MIT Hostels','EC101');
	insert into Employee values('160905586','Rusraksh','M',18693,'MIT Hostels','EE420');

	insert into Employee values('160905286','Rishabh','M',1548693,NULL,'CS101');
	insert into Employee values('160905286',NULL,'M',1548693,'MIT Hostels','CS101');
	insert into Dept values('CS102','Comp.Sci','AB5');

delete from Dept 
where DNo = 'CS101';

alter table Employee
drop constraint fk;
alter table Employee
add constraint ekf foreign key(DNo) references Dept(DNo) on delete cascade;

select name,length(name) from student;
select lower(name) from instructor;
select dept_name,substr(dept_name,3,3) from department;
select upper(name) from instructor;
select name,nvl(dept_name,'Comp. Sci.') from student;
select budget,round(budget/3,-2) from department;

alter table Employee
add dob date;
	update Employee set dob='08-May-1998' where EmpName='Rishabh';
	update Employee set dob='08-May-1997' where EmpName='Ankur';
	update Employee set dob='17-Jan-1998' where EmpName='Nishchay';
select EmpName,TO_CHAR(dob,'DD-MON-YYYY') from Employee;
select EmpName,TO_CHAR(dob,'DD-MON-YY') from Employee;
select EmpName,TO_CHAR(dob,'DD-MM-YYYY') from Employee;

select EmpName,TO_CHAR(dob,'YEAR') from Employee;
select EmpName,TO_CHAR(dob,'Year') from Employee;
select EmpName,TO_CHAR(dob,'year') from Employee;

select EmpName,TO_CHAR(dob,'DAY') from Employee;
select EmpName,TO_CHAR(dob,'Day') from Employee;

select EmpName,TO_CHAR(dob,'MONTH') from Employee;
select EmpName,TO_CHAR(dob,'Month') from Employee;

select EmpName,last_day(dob) lastDay,TO_CHAR(last_day(dob),'DAY') from Employee where EmpName = 'Rishabh';

select EmpName,round(MONTHS_BETWEEN(sysdate,dob)/12,0) age from Employee;

select EmpName,NEXT_DAY(ADD_MONTHS(dob,60*12),'Saturday') from Employee;

select EmpName,dob from Employee where TO_CHAR(dob,'YY')='98';

select EmpName,dob from Employee where TO_CHAR(dob,'YY') between '95' and '97';

select EmpName from Employee where TO_CHAR(ADD_MONTHS(dob,60*12),'YYYY')='2057';
