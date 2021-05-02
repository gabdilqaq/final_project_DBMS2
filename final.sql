
create or replace TYPE t_films_table IS OBJECT(id NUMBER(10,0), title varchar2(200),image varchar2(200));
create or replace TYPE t_table IS TABLE OF t_films_table;


create or replace TYPE t_top_year IS OBJECT(year_of_release NUMBER(10,0), number_of_films NUMBER(10,0));
create or replace TYPE t_top_year_table IS TABLE OF t_top_year;


create or replace TYPE t_actions IS OBJECT(ID NUMBER(10,0), updated_at DATE, inserted_at DATE,deleted_at DATE);
create or replace TYPE t_actions_table IS TABLE OF t_actions;


create or replace TYPE t_top_subjectt IS OBJECT(subject VARCHAR2(60),percent_of_genre NUMBER(10,2));
create or replace TYPE t_top_subject_table IS TABLE OF t_top_subjectt;


CREATE OR REPLACE PACKAGE films_filter AS

    FUNCTION length_desc RETURN t_table;
    FUNCTION popularity RETURN t_table;
    FUNCTION year_asc RETURN t_table;
    FUNCTION subject(p_subject varchar2) RETURN t_table;
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

CREATE OR REPLACE FUNCTION search_film(p_film_name IN films.title%TYPE)
    RETURN t_table IS
    t_result t_table := t_table();
    CURSOR cur_title IS SELECT id,title,image FROM films
        WHERE (title LIKE '%'||p_film_name||'%' OR actor LIKE '%'||p_film_name||'%' OR  
               actress LIKE '%'||p_film_name||'%' OR director LIKE '%'||p_film_name||'%') 
               AND popularity IS NOT NULL
        ORDER BY popularity desc;
BEGIN
    FOR v_rec_film IN cur_title LOOP
        t_result.extend;
            t_result(t_result.count) := t_films_table(null, null,null);
            t_result(t_result.count).id := v_rec_film.id;
            t_result(t_result.count).title :=  v_rec_film.title;
            t_result(t_result.count).image :=  v_rec_film.image;
    END LOOP;
    RETURN t_result;
END;




CREATE OR REPLACE FUNCTION all_films 
    RETURN t_table IS
    t_result t_table :=t_table();
    CURSOR cur_all_film IS SELECT id ,title ,image FROM films;
BEGIN
    FOR v_rec_all_film IN cur_all_film LOOP
        t_result.extend;
            t_result(t_result.count) := t_films_table(null, null,null);
            t_result(t_result.count).id := v_rec_all_film.id;
            t_result(t_result.count).title :=  v_rec_all_film.title;
            t_result(t_result.count).image :=  v_rec_all_film.image;
    END LOOP;
    RETURN t_result;
END;


CREATE OR REPLACE FUNCTION admin_actions 
    RETURN t_actions_table IS
    t_result t_actions_table :=t_actions_table();
    CURSOR cur_actions IS SELECT * FROM time_of_actions;
BEGIN
    FOR v_rec_actions IN cur_actions LOOP
        t_result.extend;
            t_result(t_result.count) := t_actions(null, null, null, null);
            t_result(t_result.count).id := v_rec_actions.id;
            t_result(t_result.count).inserted_at :=  v_rec_actions."inserted_at";
            t_result(t_result.count).updated_at :=  v_rec_actions."updated_at";
            t_result(t_result.count).deleted_at :=  v_rec_actions."deleted_at";
    END LOOP;
    RETURN t_result;
END;

CREATE OR REPLACE PACKAGE query AS
    
    PROCEDURE insert_films(
    v_year IN films.year%TYPE,
    v_length IN films.length%TYPE,
    v_title IN films.title%TYPE,
    v_subject IN films.subject%TYPE,
    v_actor IN films.actor%TYPE,
    v_actress IN films.actress%TYPE,
    v_director IN films.director%TYPE,
    v_popularity IN films.popularity%TYPE,
    v_awards IN films.awards%TYPE,
    v_image IN films.image%TYPE);
    
    PROCEDURE update_films(
    v_year IN films.year%TYPE,
    v_length IN films.length%TYPE,
    v_title IN films.title%TYPE,
    v_subject IN films.subject%TYPE,
    v_actor IN films.actor%TYPE,
    v_actress IN films.actress%TYPE,
    v_director IN films.director%TYPE,
    v_popularity IN films.popularity%TYPE,
    v_awards IN films.awards%TYPE,
    v_image IN films.awards%TYPE,
    v_ID IN films.ID%TYPE);
    
    PROCEDURE delete_film(p_id IN films.ID%TYPE);
END;


CREATE OR REPLACE PACKAGE BODY query AS
      
    PROCEDURE update_films(
        v_year IN films.year%TYPE,
        v_length IN films.length%TYPE,
        v_title IN films.title%TYPE,
        v_subject IN films.subject%TYPE,
        v_actor IN films.actor%TYPE,
        v_actress IN films.actress%TYPE,
        v_director IN films.director%TYPE,
        v_popularity IN films.popularity%TYPE,
        v_awards IN films.awards%TYPE,
        v_image IN films.awards%TYPE,
        v_ID IN films.ID%TYPE) IS
        v_dyn_q VARCHAR2(1000);
    BEGIN
        v_dyn_q := 'UPDATE films SET 
                    year = '||v_year||',
                    length = '||v_length||', 
                    title = '' '||v_title||' '',
                    subject = '' '||v_subject||' '',
                    actor = '' '||v_actor||' '',
                    actress = '' '||v_actress||' '' ,
                    director = '' '||v_director||' '',
                    popularity =  '||v_popularity||',
                    awards = '' '||v_awards||' '',
                    image = '' '||v_image||' ''
                    WHERE id = '||v_id||' ';
        EXECUTE IMMEDIATE v_dyn_q;
    END update_films;

    
    PROCEDURE insert_films(
        v_year IN films.year%TYPE,
        v_length IN films.length%TYPE,
        v_title IN films.title%TYPE,
        v_subject IN films.subject%TYPE,
        v_actor IN films.actor%TYPE,
        v_actress IN films.actress%TYPE,
        v_director IN films.director%TYPE,
        v_popularity IN films.popularity%TYPE,
        v_awards IN films.awards%TYPE,
        v_image IN films.image%TYPE)
        IS
        v_dyn_q VARCHAR2(1000);
    BEGIN
        v_dyn_q := 'INSERT INTO films(year,length,title,subject,actor
                    ,actress,director,popularity,awards,image)
                    VALUES(' || v_year ||' , '||v_length||' ,'' '||v_title||
                    ' '','' '||v_subject||' '' ,'' ' ||v_actor||' '','' '
                    ||v_actress||' '','' '||v_director||'  '','
                    ||v_popularity||','' '||v_awards||
                    ' '','' '||v_image||' '')';
        EXECUTE IMMEDIATE v_dyn_q;
    END insert_films;
    
    
    PROCEDURE delete_film(p_id IN films.ID%TYPE) IS 
    v_dyn_q VARCHAR2(200);
    BEGIN
        v_dyn_q := 'DELETE FROM films WHERE id = ' || p_id || '';
        EXECUTE IMMEDIATE v_dyn_q;
    END;
END query;





ALTER TABLE  films  ADD (id NUMBER(10));
UPDATE  films  SET id=ROWNUM;
ALTER TABLE films MODIFY (id PRIMARY KEY not null);

CREATE SEQUENCE film_id START WITH 1911;

CREATE OR REPLACE TRIGGER film_id_add 
    BEFORE INSERT ON films
    FOR EACH ROW
    BEGIN
      SELECT film_id.NEXTVAL
      INTO   :new.id
      FROM   dual;
END;

CREATE TABLE time_of_actions
( 
  "updated_at" DATE,
  "inserted_at" DATE,
  "deleted_at" DATE ,
  id NUMBER(8) NOT NULL
);

    
CREATE OR REPLACE TRIGGER upd_film
AFTER UPDATE ON films FOR EACH ROW
BEGIN
    INSERT INTO time_of_actions(id, "updated_at")
    VALUES (:OLD.id , SYSDATE);
END;

CREATE OR REPLACE TRIGGER ins_film
AFTER INSERT ON films FOR EACH ROW
BEGIN
    INSERT INTO time_of_actions(id, "inserted_at")
    VALUES (:NEW.id , SYSDATE);
END;

CREATE OR REPLACE TRIGGER del_film
AFTER DELETE ON films FOR EACH ROW
BEGIN
    INSERT INTO time_of_actions(id, "deleted_at")
    VALUES (:OLD.id , SYSDATE);
END;

  







CREATE OR REPLACE FUNCTION top_year
    RETURN t_top_year_table IS
    t_result t_top_year_table := t_top_year_table();
    v_i INTEGER:=1;
    CURSOR cur_top IS SELECT year , COUNT(*) AS "number_of_films"
            FROM films
            GROUP BY year
            ORDER BY COUNT(*) DESC;
BEGIN
    FOR v_rec_top IN cur_top LOOP
        t_result.extend;
            t_result(t_result.count) := t_top_year(null, null);
            t_result(t_result.count).year_of_release := v_rec_top.year;
            t_result(t_result.count).number_of_films :=  v_rec_top."number_of_films";
            EXIT WHEN v_i = 3;
            v_i:=v_i+1;
    END LOOP;
    RETURN t_result;
END;

CREATE OR REPLACE FUNCTION top_subject
    RETURN t_top_subject_table IS
    t_result t_top_subject_table := t_top_subject_table();
    v_i INTEGER:=1;
    v_sum INTEGER := 0;
    v_percent NUMBER(10,2) ;
    v_percent_sum NUMBER(10,2):= 0;
    CURSOR cur_top IS SELECT subject , COUNT(*) AS "num_subject"
            FROM films
            GROUP BY subject
            ORDER BY COUNT(*) DESC;
BEGIN
    FOR v_rec_top IN cur_top LOOP
        v_sum := v_sum + v_rec_top."num_subject";
    END LOOP;

    FOR v_rec_top2 IN cur_top LOOP
        t_result.extend;
            t_result(t_result.count) := t_top_subjectt(null, null);
            t_result(t_result.count).subject := v_rec_top2.subject;
            v_percent := (v_rec_top2."num_subject"*100)/v_sum;
            v_percent_sum:=v_percent_sum+v_percent;
            t_result(t_result.count).percent_of_genre :=  v_percent;
            IF v_i = 6 THEN
                t_result(t_result.count).subject := 'Others';
                 t_result(t_result.count).percent_of_genre := (100-v_percent_sum);
            END IF;
            EXIT WHEN v_i = 6;
            v_i:=v_i+1;
    END LOOP;
    RETURN t_result;
END;
















alter table films add (count_of_seacrh number(5,0)default 0);

CREATE OR REPLACE PACKAGE algos AS
    PROCEDURE increment_count(p_id  IN films.ID%TYPE);
    FUNCTION top_five_film RETURN t_table;
END;

CREATE OR REPLACE PACKAGE BODY algos AS
    PROCEDURE increment_count(p_id  IN films.ID%TYPE) IS
    BEGIN
       UPDATE films SET 
            count_of_seacrh = (count_of_seacrh+1)
            WHERE id = p_id;
    END;
    
    FUNCTION top_five_film 
    RETURN t_table IS
    v_row NUMBER:=1;
    t_result t_table := t_table();
    CURSOR cur_topfilms IS SELECT id,title,image FROM films
        ORDER BY count_of_seacrh DESC;
    BEGIN
        FOR v_rec_topfilms in cur_topfilms LOOP
            t_result.extend;
            t_result(t_result.count) := t_films_table(null, null,null);
            t_result(t_result.count).id := v_rec_topfilms.id;
            t_result(t_result.count).title :=  v_rec_topfilms.title;
            t_result(t_result.count).image :=  v_rec_topfilms.image;
            EXIT WHEN v_row=5;
            v_row:=v_row+1;
        END LOOP;
        RETURN t_result;
    END top_five_film;
END;
    
