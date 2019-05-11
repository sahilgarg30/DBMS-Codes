create table EmployeeER(
	fname varchar(20) not null,
	mname varchar(20),
	lname varchar(20) not null,
	ssn number(8) not null, 
	address varchar(40) not null,
	bdate date,
	sex varchar(1) not null check (sex in ('M', 'F')),
	salary number(8),
	sssn number(8),
	dno number(8),
	primary key (ssn)
);

alter table EmployeeER 
add constraint supFK foreign key(sssn) references EmployeeER(ssn);

alter table EmployeeER 
add constraint depFK foreign key(dno) references DepartmentER(dnumber);

insert into EmployeeER values ('Harold', 'J', 'Finch', 101, 'Classified', '10-NOV-61', 'M', 192000, null, 601);
insert into EmployeeER values ('John', 'B', 'Smith', 102, '5th Avenue, NY', '21-FEB-72', 'M', 112000, 101, 603);
insert into EmployeeER values ('Sameen', 'R', 'Shaw', 103, '4th Loop, NY', '18-DEC-78', 'F', 112000, 101, 603);
insert into EmployeeER values ('Samantha', 'R', 'Groves', 104, '1, Infinite Loop', '08-APR-79', 'F', 250000, null, 602);
insert into EmployeeER values ('Lionel', 'P', 'Fusco', 105, '18th Rose Drive', '10-JUN-68', 'M', 89000, 104, 606);
insert into EmployeeER values ('John', 'F', 'Greer', 106, 'Classified', '28-DEC-51', 'M', 800000, null, 609);

create table DepartmentER (
	dname varchar(20) unique not null,
	dnumber number(8) not null,
	mssn number(8) not null,
	sdate date,
	primary key (dnumber),
	foreign key (mssn) references EmployeeER(ssn)
);

insert into DepartmentER values ('Admin', 601, 101, '02-JAN-03');
insert into DepartmentER values ('Machine Field', 603, 102, '02-MAY-11');
insert into DepartmentER values ('Analog Interface', 602, 104, '02-JAN-03');
insert into DepartmentER values ('Enforcement', 606, 105, '02-JAN-78');
insert into DepartmentER values ('Samaritan', 609, 106, '02-DEC-13');

create table DeptLoacationER (
	dnum number(8) not null,
	dlocation varchar(20) not null,
	primary key (dnum,dlocation),
	foreign key (dnum) references DepartmentER(dnumber)
);

insert into DeptLoacationER values (601, 'Classified');
insert into DeptLoacationER values (602, 'Thornhill');
insert into DeptLoacationER values (603, 'NY');
insert into DeptLoacationER values (606, 'Brooklyn 99');
insert into DeptLoacationER values (609, 'Texas');

create table ProjectER (
    pno number(10) not null,
	pname varchar(20) not null,
	plocation varchar(20),
	dno number(8) not null,
	primary key (pname),
	foreign key (dno) references DepartmentER(dnumber)
);

insert into ProjectER values (401,'ProjectX', 'NY', 601);
insert into ProjectER values (402,'ProjectY', 'FR', 603);
insert into ProjectER values (403,'ProjectZ', 'TX', 606);
insert into ProjectER values (404,'ProjectW', 'CA', 609);

create table DependentER (
	essn number(8),
	dname varchar(20),
	sex varchar(1) not null check (sex in ('M', 'F')),
	bdate date,
	relationship varchar(20),
	primary key (essn,dname),
	foreign key (essn) references EmployeeER(ssn)
);

insert into DependentER values (101, 'Bear', 'M', '10-OCT-01', 'Pet');
insert into DependentER values (102, 'World', 'M', '10-OCT-01', 'Protector');
insert into DependentER values (103, 'Jakku', 'M', '10-OCT-01', 'Protector');
insert into DependentER values (104, 'Machine', 'M', '02-JAN-03', 'Interface');

create table WorksOnER (
	essn number(8) not null,
	pnme varchar(20) not null,
	hours number(6),
	primary key(essn,pnme),
	foreign key (essn) references EmployeeER(ssn),
	foreign key (pnme) references ProjectER(pname)
);

insert into WorksOnER values (101, 'ProjectX', 32);
insert into WorksOnER values (102, 'ProjectY', 16);
insert into WorksOnER values (103, 'ProjectZ', 16);
insert into WorksOnER values (104,'ProjectW' , 40);

QUERIES

select bdate,address from EmployeeER where fname = 'John' and mname = 'B' and lname = 'Smith';
select fname,address from EmployeeER,DepartmentER where dno = dnumber and dname = 'Admin';

select pno,ProjectER.dno,lname,bdate,address 
from EmployeeER,ProjectER,DepartmentER where 
ProjectER.dno = dnumber and ssn = mssn and plocation = 'NY';

select distinct salary from EmployeeER;

select A.fname,A.lname,B.fname,B.lname from EmployeeER A,EmployeeER B where A.sssn = B.ssn;

select distinct A.pno from ProjectER A,EmployeeER,DepartmentER,WorksOnER
where (EmployeeER.lname = 'Smith' and WorksOnER.essn = EmployeeER.ssn and WorksOnER.pnme = A.pname) or
(A.dno = DepartmentER.dnumber and mssn = EmployeeER.ssn and EmployeeER.lname = 'Smith');

select * from EmployeeER where address = 'Classified';

update EmployeeER
	set salary = 1.1*salary
	where EmployeeER.ssn = (select WorksOnER.essn from WorksOnER where WorksOnER.pnme = 'ProjectX');

select * from EmployeeER where dno = '603' and salary between 30000 and 40000;

select * from EmployeeER,WorksOnER where EmployeeER.ssn = WorksOnER.essn
order by EmployeeER.dno,fname,lname;

select fname from EmployeeER where sssn is null;

select A.fname from EmployeeER A,DependentER B where A.ssn = B.essn
and A.fname = B.dname and A.sex = B.sex; 

select A.fname from EmployeeER A where 
(select count(*) from DependentER where essn = A.ssn)=0;

select A.fname from EmployeeER A where
A.ssn. in (select mssn from DepartmentER) and 
(select count(*) from DependentER where essn = A.ssn)>=1;

select A.ssn from EmployeeER A where
A.ssn in (select essn from WorksOnER,ProjectER where pnme = pname
and (pno = '401' or pno = '402' or pno = '403'));

select sum(salary),max(salary),min(salary),avg(salary) from EmployeeER;

select sum(salary),max(salary),min(salary),avg(salary)
from EmployeeER,DepartmentER where dno = dnumber and dname = 'Machine Field';

select pno,pname,count(essn) from ProjectER,WorksOnER where pnme = pname
group by pname,pno;

select pno,pname,count(essn) from ProjectER,WorksOnER where pnme = pname
group by pname,pno having count(essn)>2;

select dnumber,count(ssn) from DepartmentER,EmployeeER where dno = dnumber
and salary>40000
group by dnumber having count(ssn)>5;