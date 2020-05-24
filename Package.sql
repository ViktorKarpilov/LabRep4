CREATE TYPE dist_time AS OBJECT (
  Date_year  NUMBER,
  Distance  NUMBER
);
/

CREATE TYPE dist_time_tab IS TABLE OF dist_time;
/

CREATE OR REPLACE PACKAGE Package_Test AS 
    
   PROCEDURE UpdateIncedent_Participiant( 
       old_Participiant IN NUMBER,
       old_Incedent IN NUMBER,
       new_Participiant IN NUMBER,
       new_Incedent IN NUMBER 
       ); 
    Function FindDistance
   ( 
    In_Participiant IN NUMBER,
    Date_year IN NUMBER,
    in_CITY IN VARCHAR2)
    return dist_time_tab PIPELINED;
   
END Package_Test;
/


CREATE OR REPLACE PACKAGE BODY Package_TEST AS  
   
    Procedure UpdateIncedent_Participiant
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
    
    
        Function FindDistance
       ( 
        In_Participiant IN NUMBER,
        Date_year IN NUMBER,
        in_CITY IN VARCHAR2
       )
       RETURN  dist_time_tab PIPELINED
    IS
        cursor c1 is 
        
        select
        EXTRACT(YEAR from incedent.starttime) as Date_year,sum(distance) as Distance
        from
        state
        inner join country
        on state.country_country=country.country
        inner join city
        on city.state_state = state.state
        inner join street
        on street.city_city = city.city
        inner join incedent
        on incedent.street_street = street.street
        inner join incedent_participiant
        on incedent_participiant.incedent = incedent.incedent_id
        
        WHERE
            EXTRACT(YEAR from incedent.starttime) <= Date_year
            and
            city = in_CITY
            and
            participiant = in_Participiant
        GROUP BY
            EXTRACT(YEAR from incedent.starttime);
            
        
        result_year NUMBER;
        result_  FuncTest%ROWTYPE;
        
    BEGIN
        FOR rec in c1
        LOOP
    --        fetch c1 into result_;
            Dbms_Output.Put_Line(result_.Date_year);
            PIPE ROW(dist_time(rec.Date_year,rec.Distance));
        END LOOP;
    RETURN;
    EXCEPTION
    WHEN OTHERS THEN
       raise_application_error(-20001,'There are no such participiant');
    END;
END Package_TEST;
/
--Package test
EXEC Package_TEST.UpdateIncedent_Participiant(2,10,2,12);
/

SELECT *
FROM   TABLE(Package_TEST.FindDistance(2,2016,'LA'));

