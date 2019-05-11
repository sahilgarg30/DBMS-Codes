declare
a number(4) := &a;
b number(4) := &b;
c number(4) := &c;
d number(8,2) :=0;
r1 number(8,2) := 0;
r2 number(8,2) := 0;
begin
d := power(b,2)-4*a*c;
r1 := (-b+sqrt(d))/(2*a);
r2 := (-b-sqrt(d))/(2*a);
if d>=0 then
DBMS_OUTPUT.PUT_LINE('Root 1 :'||r1);
end if;
if d>=0 then
DBMS_OUTPUT.PUT_LINE('Root 2 :'||r2);
end if;
end;
/

declare
doi date:= &doi;
dor date:= &dor;
fine number(8,2):=0;
begin
if dor-doi<6 then
	fine := 0.50;
elsif dor-doi<11 then
	fine := 1.00;
elsif dor-doi<30 then
	fine:=5.00;
else fine:=10.00;
end if;
DBMS_OUTPUT.PUT_LINE('fine :'||fine);
end;
/

declare
first number(2) :=0;
second number(2) :=1;
third number(2):=0;
i number;
num number(4) := &num;
begin
DBMS_OUTPUT.PUT_LINE(first);
DBMS_OUTPUT.PUT_LINE(second);
	loop
		third :=first+second;
		first :=second;
		second :=third;
		if third>num then
		exit;
		end if;
		DBMS_OUTPUT.PUT_LINE(third);
	end loop;
end;
/

declare
num number(10,2) := &num;
i number(20,5);
j number(10,2);
r number(10,2);
rev number(20,10):= 0;
begin
	i := num;
	loop
	r := mod(i,10);
	rev := rev*10+r;
	i := round(i/10);
	if i<=0 then
	exit;
	end if;
	end loop;
	if rev=num then
		DBMS_OUTPUT.PUT_LINE('is a palindrome');
	else
		DBMS_OUTPUT.PUT_LINE('not a palindrome');
	end if;
end;
/

Create table sphere(
	radius number(8,2),
	volume number(8,2),
	surfacearea number(8,2)
);
declare
r number(8,2) := 3;
volume number(8,2);
surfacearea number(8,2);
pi constant number := 3.14169;
begin
while r<8 
loop
volume := (4*pi*power(r,3))/3;
surfacearea := 4*pi*r*r;
insert into sphere values(r,volume,surfacearea);
r := r+1;
end loop;
end;
/

declare
num number(8,2) := &num;
fact number(20,4):=1;
i number;
begin
for i in 1..num loop
fact := fact*i;
end loop;
DBMS_OUTPUT.PUT_LINE('Factorial:'||fact);
end;
/

create table dates(
d1 date,
d2 date);

declare
x number(1):=5;
do date;
type d is varray(5) of date;
di d := d('21-JAN-2018','17-FEB-2018','26-JAN-2018','5-JAN-2018','1-MAR-2015');
i int := 1;
begin
while i<6
loop
do := di(i)+1;
insert into dates values (di(i),do);
i:=i+1;
end loop;
end;
/

DECLARE
	n int;
	c int;
	s int;
	a float;
	type numbers is varray(10) of integer;
	num numbers := numbers(1,2, 3, 4,-1, 59, 19, 03, -1, 10);
BEGIN
	DBMS_OUTPUT.PUT_LINE('');
	c := 0;
	s := 0;
	loop
		n := num(c + 1);
		if (n = -1) then
			goto ends;
		else
			c := c + 1;
			s := s + n;
		end if;
	end loop;
	
	<<ends>>
	if (c = 0) then
		a := 0;
	else
		a := s / c;
	end if;
	DBMS_OUTPUT.PUT_LINE('Average = ' || a);
END;
/