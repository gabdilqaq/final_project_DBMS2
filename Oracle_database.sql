
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

CREATE OR REPLACE FUNCTION search_film(p_film_name IN films.title%TYPE)
    RETURN t_table IS
    t_result t_table := t_table();
    CURSOR cur_title IS SELECT id,title,image FROM films
        WHERE title = p_film_name AND popularity IS NOT NULL
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

SELECT * FROM table(all_films);


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
    v_image IN films.awards%TYPE);
    
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
    BEGIN
         UPDATE films SET 
            year = v_year,
            length = v_length,
            title = v_title,
            subject = v_subject,
            actor = v_actor,
            actress = v_actress,
            director = v_director,
            popularity = v_popularity,
            awards = v_awards,
            image = v_image
                WHERE id = v_id;
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
        v_image IN films.awards%TYPE)
        IS
    BEGIN
         INSERT INTO films(year, length,title,subject,actor,actress,director,popularity, awards,image)
         VALUES(
             v_year,
            v_length,
            v_title,
            v_subject,
            v_actor,
            v_actress,
            v_director,
            v_popularity,
            v_awards,
            v_image);
    END insert_films;

    PROCEDURE delete_film(p_id IN films.ID%TYPE) IS 
    BEGIN
        DELETE FROM films 
            WHERE id = p_id;
    END;
END query;

--BEGIN
--    insert_films(1654,100,'Kozy Korpesh','Drama','Kozy','Bayan','Akan',100,'Yes','kaz.png');
--END;































alter table films drop column id;
ALTER TABLE table_name ADD (id NUMBER(10));
UPDATE table_name SET id=ROWNUM;
ALTER TABLE table_name MODIFY (id PRIMARY KEY);

CREATE SEQUENCE film_id START WITH 1911;

CREATE OR REPLACE TRIGGER film_id_add 
BEFORE INSERT ON films
FOR EACH ROW
BEGIN
  SELECT film_id.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;

INSERT INTO films (YEAR, LENGTH, TITLE, SUBJECT, ACTOR, ACTRESS, DIRECTOR, POPULARITY, AWARDS, IMAGE) VALUES (
    1991,
    144,
    'Robin Hood: Prince of Thieves',
    'Action',
    'Costner',
    'tets',
    'Mastrantonio',
    8,
    'no',
    'NicholasCage.png'
);

SELECT * FROM FILMS
WHERE id >= 1900



    
  
  
  
  
  
  

        