create or replace function get_no_of_prereq(course_id1 Course.course_id%TYPE)
	return numeric as
	n numeric;
	cursor c1 is select * from Prereq where Prereq.course_id = course_id1;
	exc EXCEPTION;
	begin
	n:=0;
	for item in c1 loop
	n:=n+1;
	end loop;
	if n=0 then
		RAISE exc;
	end if;
	DBMS_OUTPUT.PUT_LINE(to_char(course_id1)||'  '||to_char(n));
	return n;
	EXCEPTION 
	WHEN NO_DATA_FOUND then
	DBMS_OUTPUT.PUT_LINE('No data');
	return 0;
	WHEN EXC then
	DBMS_OUTPUT.PUT_LINE(course_id1 || '  No prereq');
	return 0;
	WHEN OTHERS then
	DBMS_OUTPUT.PUT_LINE('error');
	return 0;
	end;
	/
	declare
	num numeric;
	cursor c1 is select distinct(course_id) from Course;
	begin
	for item in c1 loop
	num := get_no_of_prereq(item.course_id);
	end loop;
	end;
	/