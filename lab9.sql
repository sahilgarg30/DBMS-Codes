9.1
	set serveroutput on;
	create or replace procedure print_msg is
		begin
			dbms_output.put_line('Have a good day!');
		end;
		/


	declare
	begin
		print_msg;
	end;
	/		

9.2 
	set serveroutput on;
	create or replace procedure print_name(dept student.dept_name%type) is
		cursor c1 is
		select name from student where dept_name=dept;

		cursor c2 is
		select name from instructor where dept_name=dept;



		begin
		for item1 in c1
		loop
			dbms_output.put_line(to_char(item1.name));
		end loop;
		dbms_output.put_line('---------instructor-------');

		for item2 in c2
		loop
			dbms_output.put_line(to_char(item2.name));
		end loop;

	end;
	/

	declare
	begin
		print_name('Comp. Sci.');
	end;
	/

9.3 
	set serveroutput on;
	create or replace procedure department_highest(dept department.dept_name%type) is
		cursor c3 is
		select * from instructor where dept_name=dept and salary=(select max(salary) from instructor where dept_name=dept);

		begin
			for item3 in c3
			loop 
			dbms_output.put_line(to_char(item3.dept_name)||'  '||to_char(item3.name)||'  '||to_char(item3.salary));
			end loop;
		end;
		/

	declare	
		cursor cur1 is
		select dept_name from instructor group by dept_name;

		begin
			for item in cur1
			loop
			department_highest(item.dept_name);
			end loop;
		end;
		/

9.5
create or replace function Square(a number)
		return number as
		sq number;
		begin
			sq := a*a;
			return sq;
		end;
		/

	declare
	begin
		dbms_output.put_line('Square of number '||to_char(9)||' is '||Square(9));
	end;
	/

9.6
create or replace function course_popular(dept course.dept_name%type) 
		return takes.course_id%type
	as		
		pop takes.course_id%type;
	begin
		with counts as (select takes.course_id,count(ID) as students from takes group by takes.course_id having takes.course_id IN (select course_id from course where dept_name = dept)),
		maxCounts as (select max(students) as ms from counts)
		select course_id into pop from counts,maxCounts where students = maxCounts.ms;
		return pop;
	EXCEPTION
	when too_many_rows then dbms_output.put_line('Many courses.');
	return 'many courses';
	end;
	/

declare
cursor c1 is select distinct(dept_name) from course;
begin
for item in c1
loop
dbms_output.put_line(item.dept_name || '   ' || course_popular(item.dept_name));
end loop;
end;
/

9.7 
create package p1 as
	function msal(dept department.dept_name%type)
	return instructor.salary%type;
	procedure instnames(dept department.dept_name%type);
end p1;
/
create or replace package body p1 as
	procedure instnames(dept department.dept_name%type) is
			cursor c1 is select name from instructor where dept_name = dept;
		begin
			for item in c1
			loop
			dbms_output.put_line(item.name);
			end loop;
		end;

	function msal(dept department.dept_name%type)
	return instructor.salary%type as
	maxsal instructor.salary%type;
	begin
	select max(salary) into maxsal from instructor where dept_name = dept;
	return maxsal;
	end;
end p1;
/
declare
n number;
begin
dbms_output.put_line('Comp. Sci. department - ');
p1.instnames('Comp. Sci.');
n:=p1.msal('Comp. Sci.');
dbms_output.put_line('Max Salary = '||to_char(n));
end;
/
9.8
CREATE OR REPLACE PROCEDURE interestCalculation (
	principal number,
	timet number,
	rate number,
	si OUT number,
	ci OUT number,
	totalSum IN OUT number
) IS
	initSum number;
BEGIN
	si := (principal * rate * timet) / 100;
	initSum := totalSum;
	totalSum := totalSum * power(((1 + (rate/100))), FLOOR(timet));
	ci := totalSum - initSum;
END;
/

DECLARE
	principal number := 10000;
	rate number := 10;
	timet number := 3;
	si number;
	ci number;
	totalSum number := 44000;
BEGIN
	interestCalculation (principal, timet, rate, si, ci, totalSum);
	DBMS_OUTPUT.PUT_LINE('principal = ' || principal);
	DBMS_OUTPUT.PUT_LINE('rate = ' || rate);
	DBMS_OUTPUT.PUT_LINE('time = ' || timet);
	DBMS_OUTPUT.PUT_LINE('si = ' || si);
	DBMS_OUTPUT.PUT_LINE('ci = ' || ci);
	DBMS_OUTPUT.PUT_LINE('totalSum = ' || totalSum);
END;
/