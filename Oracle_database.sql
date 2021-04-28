create or replace TYPE t_films IS OBJECT(id NUMBER(10,0), title varchar2(200),image varchar2(200));
create or replace TYPE t_table_length IS TABLE OF t_films;


create or replace TYPE t_films_table IS OBJECT(id NUMBER(10,0), title varchar2(200),image varchar2(200));
create or replace TYPE t_table IS TABLE OF t_films_table;

CREATE OR REPLACE PACKAGE films_filter AS

    FUNCTION length_desc RETURN t_table;
    FUNCTION popularity RETURN t_table;
    FUNCTION year_asc RETURN t_table;
    FUNCTION subject(p_subject varchar2) RETURN t_table;
    FUNCTION year_search(p_year varchar2) RETURN t_table;
END;

CREATE OR REPLACE PACKAGE BODY films_filter AS
    --#1
    FUNCTION length_desc 
    RETURN t_table IS
    t_result t_table := t_table();
    CURSOR cur_length IS SELECT id, title, image FROM films
        WHERE length IS NOT NULL
        ORDER BY length desc;
    BEGIN
        FOR v_cur_length_rec in cur_length LOOP
            t_result.extend;
            t_result(t_result.count) := t_films_table(null, null,null);
            t_result(t_result.count).id := v_cur_length_rec.id;
            t_result(t_result.count).title := v_cur_length_rec.title;
            t_result(t_result.count).image := v_cur_length_rec.image;
        END LOOP;
        RETURN t_result;
    END length_desc;
    
    FUNCTION popularity 
    RETURN t_table IS
    t_result t_table := t_table();
    CURSOR cur_popularity IS SELECT id,title,image FROM films
        WHERE popularity IS NOT NULL
        ORDER BY popularity desc;
    BEGIN
        FOR v_cur_pop_rec in cur_popularity LOOP
            t_result.extend;
            t_result(t_result.count) := t_films_table(null, null,null);
            t_result(t_result.count).id := v_cur_pop_rec.id;
            t_result(t_result.count).title :=  v_cur_pop_rec.title;
            t_result(t_result.count).image :=  v_cur_pop_rec.image;
        END LOOP;
        RETURN t_result;
    END popularity;
    
    FUNCTION year_asc 
    RETURN t_table IS
    t_result t_table := t_table();
    CURSOR cur_year IS SELECT id,title,image FROM films
        WHERE year IS NOT NULL
        ORDER BY year asc;
    BEGIN
        FOR v_cur_year_rec in cur_year LOOP
            t_result.extend;
            t_result(t_result.count) := t_films_table(null, null,null);
            t_result(t_result.count).id := v_cur_year_rec.id;
            t_result(t_result.count).title :=  v_cur_year_rec.title;
            t_result(t_result.count).image :=  v_cur_year_rec.image;
        END LOOP;
        RETURN t_result;
    END year_asc;
    
    FUNCTION subject(p_subject VARCHAR2) 
    RETURN t_table IS
    t_result t_table := t_table();
    CURSOR cur_pop IS SELECT id,title,image FROM films
        WHERE subject = p_subject AND popularity IS NOT NULL
        ORDER BY popularity desc;
    BEGIN
        FOR v_cur_subject_rec in cur_pop LOOP
            t_result.extend;
            t_result(t_result.count) := t_films_table(null, null,null);
            t_result(t_result.count).id := v_cur_subject_rec.id;
            t_result(t_result.count).title :=  v_cur_subject_rec.title;
            t_result(t_result.count).image :=  v_cur_subject_rec.image;
        END LOOP;
        RETURN t_result;
    END subject;
    
    FUNCTION year_search(p_year VARCHAR2) 
    RETURN t_table IS
    t_result t_table := t_table();
    CURSOR cur_year_s IS SELECT id,title,image FROM films
        WHERE year = p_year AND popularity IS NOT NULL
        ORDER BY popularity desc;
    BEGIN
        FOR v_cur_year_rec in cur_year_s LOOP
            t_result.extend;
            t_result(t_result.count) := t_films_table(null, null,null);
            t_result(t_result.count).id := v_cur_year_rec.id;
            t_result(t_result.count).title :=  v_cur_year_rec.title;
            t_result(t_result.count).image :=  v_cur_year_rec.image;
        END LOOP;
        RETURN t_result;
    END year_search;
END;