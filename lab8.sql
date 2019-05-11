-- 1 (i)
DROP TABLE Salary_Raise;
CREATE TABLE Salary_Raise (iid varchar(20), rdate date, raise numeric(8, 2));

DECLARE

	CURSOR curse IS
		SELECT * FROM Instructor WHERE dept_name = 'Biology' FOR UPDATE;
	raiseamt numeric(8, 2);

BEGIN

	FOR sal IN curse LOOP
		raiseamt := sal.salary * 1.05;
		UPDATE Instructor SET salary = salary * 1.05 where ID = sal.ID;
		INSERT INTO Salary_Raise VALUES (sal.ID, CURRENT_DATE, raiseamt);
	END LOOP;

END;
/

SELECT * FROM Salary_Raise;

-- 1 (ii)

DROP TABLE Salary_Raise;
CREATE TABLE Salary_Raise (iid varchar(20), rdate date, raise numeric(8, 2));

DECLARE

	id varchar(5);
	sal numeric(8,2);
	dept varchar(20);
	raiseamt numeric(8,2);

	CURSOR curse IS
		SELECT ID, salary, dept_name FROM Instructor FOR UPDATE;

BEGIN

	OPEN curse;

	LOOP
		FETCH curse INTO id, sal, dept;
		IF dept = 'Comp. Sci.' THEN
			UPDATE Instructor SET salary = sal * 1.05 WHERE CURRENT OF curse;
			raiseamt := sal * 1.05;
			INSERT INTO Salary_Raise VALUES (id, CURRENT_DATE, raiseamt);
		END IF;
		EXIT WHEN curse%NOTFOUND;
	END LOOP;

END;
/

SELECT * FROM Salary_Raise;

-- 2

CREATE TABLE Item_Master (itemid int primary key, descrption varchar(50), balanceStock int);
CREATE TABLE Item_Transaction (itemid int primary key, descrption varchar(50), quantity int);

INSERT INTO Item_Master VALUES (1, 'Kryptonite Balls', 10);
INSERT INTO Item_Master VALUES (2, 'Batrangs', 200);
INSERT INTO Item_Master VALUES (3, 'Smoke Bombs', 100);

DECLARE

	CURSOR curse(item int) IS
		SELECT * FROM Item_Master WHERE itemid = item FOR UPDATE;

	rowItemMaster Item_Master%ROWTYPE;
	id int;
	des varchar(50);
	qty int;
	oldqty int;
	EXC EXCEPTION;

BEGIN

	id := &id;
	des := &des;
	qty := &qty;

	OPEN curse(id);

	FETCH curse INTO rowItemMaster;
	IF curse%NOTFOUND THEN
		INSERT INTO Item_Master VALUES (id, des,0);
	ELSE
		SELECT balanceStock INTO oldqty FROM Item_Master where itemid = id;
		IF (oldqty - qty < 0) THEN
			raise EXC;
		ELSE
		UPDATE Item_Master SET balanceStock = balanceStock - qty WHERE itemid = id;
		INSERT INTO Item_Transaction VALUES (id,des,qty);
		END IF;
	END IF;

EXCEPTION
WHEN EXC THEN DBMS_OUTPUT.PUT_LINE('quantity not available.');
END;

/

SELECT * FROM Item_Master;
SELECT * FROM Item_Transaction;

-- 3

DECLARE

	tsal numeric;

BEGIN

	SAVEPOINT insertIn;

	INSERT INTO Instructor VALUES ('10122', 'Walter White', 'Biology',80000);

	SAVEPOINT salInc;

	UPDATE Instructor SET salary = 100000 WHERE name LIKE '%Mozart%';
	UPDATE Instructor SET salary = 150000 WHERE name LIKE '%Srinivasan%';

	SELECT SUM(salary) INTO tsal FROM Instructor;
	IF tsal > 2000000 THEN
		ROLLBACK TO SAVEPOINT salInc;
		DBMS_OUTPUT.PUT_LINE('ROLLBACKED!');
	END IF;

END;
/


declare
cursor c IS
	SELECT * from student natural join takes where course_id = 'CS-101';
BEGIN
FOR ITEM in c
	LOOP
	DBMS_OUTPUT.PUT_LINE(ITEM.ID || ' '|| ITEM.tot_cred);
	IF ITEM.tot_cred<50 then
		delete from takes where takes.ID = ITEM.ID;
	END IF;
	END LOOP;
	END;
/