CREATE TYPE dist_time AS OBJECT (
  Date_year  NUMBER,
  Distance  NUMBER
);
/

CREATE TYPE dist_time_tab IS TABLE OF dist_time;
/


CREATE OR REPLACE Function FindDistance
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
/