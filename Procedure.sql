CREATE OR REPLACE Procedure UpdateIncedent_Participiant
   ( 
   old_Participiant IN NUMBER,
   old_Incedent IN NUMBER,
   new_Participiant IN NUMBER,
   new_Incedent IN NUMBER 
   )
IS
    bof1 number default 0;
    bof2 number default 0;
    no_Incedent_OR_Participiant EXCEPTION;
    PRAGMA exception_init( no_Incedent_OR_Participiant, -20200 );
BEGIN
    select participiant, incedent into bof1,bof2
    from incedent_participiant
    where 
        participiant = old_participiant
        and
        incedent = old_incedent;
    
    update incedent_participiant
    set 
        participiant = new_Participiant,
        incedent = new_Incedent
    WHERE
        participiant = old_Participiant 
        and
        incedent = old_Incedent;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    raise_application_error(-20200,'There are no such incedent or participiant');
    WHEN OTHERS THEN
    raise_application_error(-20200,'There are already such note or there aro no such incedent');
END;
/

