DROP TABLE Areas;
CREATE TABLE Areas (radius float, area float);
INSERT INTO Areas VALUES (1, 3.14);
INSERT INTO Areas VALUES (2, 3.14 * 4);
INSERT INTO Areas VALUES (3, 3.14 * 9);
INSERT INTO Areas VALUES (4, 3.14 * 16);
set serveroutput on
DECLARE
	rad float;
	ara float;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Enter the radius you want to get the area for: ');
	rad := &rad;
	SELECT area INTO ara FROM Areas WHERE radius = rad;
	DBMS_OUTPUT.PUT_LINE('Area of radius ' || rad || ' = ' || ara);
EXCEPTION
	WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No data found!');
	WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Other Exc.');
END;
/
---------------------------------------------------------------------------------------------
set serveroutput on
DECLARE
	name varchar2(20);
	deptName varchar2(20);
	dcount int;
	EXC exception;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Enter department name: ');
	deptName := &deptName;

	SELECT name INTO name FROM instructor WHERE dept_name = deptName;
	SELECT name, count(*) into name, dcount FROM instructor GROUP BY name;

	IF dcount > 1 THEN
		raise EXC;
	END if;

	DBMS_OUTPUT.PUT_LINE('Name: '|| name);
EXCEPTION
	WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No associated instructor');
	WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Ambiguous data.');
	WHEN EXC THEN DBMS_OUTPUT.PUT_LINE('1 instructor, multiple depts');
END;
/
-------------------------------------------------------------------------------------------
DROP TABLE salesman_master;
DROP TABLE Comission_payable;

CREATE TABLE Salesman_master (sno int, sname varchar2(20), rate float, starget float, tsales float);
CREATE TABLE Comission_payable (camt float, sno int, pdate date);

INSERT INTO salesman_master VALUES (1, 'Murdock', 10.0, 1000, 500);
INSERT INTO salesman_master VALUES (2, 'Nelson', 2.5, 2000, 1000);
INSERT INTO salesman_master VALUES (3, 'Fisk', 4.5, 5000, 6000);

DECLARE
	target float;
	total float;
	salesmanno int;
	roc float;
	EXC exception;

BEGIN

	DBMS_OUTPUT.PUT_LINE('Enter salesman no: ');
	salesmanno := &salesmanno;

	SELECT sno, starget, tsales, rate INTO salesmanno, total, target, roc FROM Salesman_master WHERE sno = salesmanno;

	IF target > total THEN
		INSERT INTO Comission_payable VALUES (total * roc, salesmanno, (SELECT sysdate FROM dual));
		DBMS_OUTPUT.PUT_LINE('Commisson payed.');
	ELSE
		RAISE EXC;
	END IF;

EXCEPTION
		WHEN EXC THEN DBMS_OUTPUT.PUT_LINE('Salesman master has not reached the goal!');
		WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unknown error!');

END;
/

SELECT * FROM Salesman_master;
SELECT * FROM Comission_payable;

------------------------------------------------------------
DROP TABLE salary_raise;
CREATE TABLE salary_raise (i_id varchar(5), Raise_date date, Raise_amt number(8,2));

set serveroutput on;

DECLARE
	temp instructor%ROWTYPE;
	dname varchar2(20) := &dname;
	CURSOR c1 IS SELECT * FROM instructor WHERE dept_name = dname;

BEGIN
	OPEN c1;
	
	LOOP
		FETCH c1 INTO temp;
		EXIT WHEN c1%notfound;
		UPDATE instructor SET salary = salary * 1.05 WHERE ID = temp.ID;		
		INSERT INTO salary_raise VALUES (temp.id,sysdate,salary * 1.05 );
	END loop;

	CLOSE c1;
end;
/

SELECT * FROM salary_raise;
------------------------------------------------------------------------------------------------
set serveroutput on;

DECLARE
	CURSOR curse is SELECT * FROM student ORDER BY tot_cred;
	studrow student%rowtype;

BEGIN
	DBMS_OUTPUT.PUT_LINE('name \t|\t ID \t|\t credits');

	OPEN curse;
	LOOP 
		FETCH curse INTO studrow;
		DBMS_OUTPUT.PUT_LINE(studrow.name || ' | ' || studrow.ID || ' | ' || studrow.tot_cred);
		EXIT WHEN curse%ROWCOUNT > 9;
	END LOOP;

	CLOSE curse;
END;
/
------------------------------------------------------------------------------------------------