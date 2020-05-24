SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER incedent_participiant_insert
BEFORE INSERT
   ON incedent_participiant
   FOR EACH ROW


DECLARE
   bof_participiant  NUMBER(10) DEFAULT 0;
   
BEGIN

    select participiant into bof_participiant
    from Participiants 
    where participiant = (:new.participiant);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    INSERT INTO Participiants(participiant) VALUES (:new.participiant);
    Dbms_Output.Put_Line('Added new participiant - '||:new.participiant);
    WHEN OTHERS THEN
    raise_application_error(-20200,'There are no such incedent');
END;
/
insert into incedent_participiant(incedent,participiant)
VALUES (10,5);