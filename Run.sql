SET SERVEROUTPUT ON

--Trigger test
insert into incedent_participiant(incedent,participiant)
VALUES (10,4);

--Procedure test
EXEC UpdateIncedent_Participiant(1,10,1,11);

--Mistake section
EXEC UpdateIncedent_Participiant(333,12,222,10);
--END OF section

--Function test
SELECT *
FROM   TABLE(FindDistance(2,2016,'LA'));

