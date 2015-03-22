/* DROP de toute la base */

DROP SEQUENCE seq_id_cl;
DROP SEQUENCE seq_id_empl;
DROP SEQUENCE seq_id_chef;
DROP SEQUENCE seq_id_p;
DROP SEQUENCE seq_id_cd;
DROP SEQUENCE seq_id_film;
DROP SEQUENCE seq_id_livre;


DROP TABLE Disques;
DROP TABLE Films;
DROP TABLE Livres;
DROP TABLE Retours;
DROP TABLE Emprunts;
DROP TABLE Medias;
DROP TABLE Chefs;
DROP TABLE Employes;
DROP TABLE Clients;
DROP TABLE Personnes;

drop user PierreG;
drop user CedricB;
drop user TheoD;
drop user FrancoisH;

/* Creaton d'utilisateurs de la base*/

create user PierreG identified by PG; /*un client */
create user CedricB identified by CB; /* responsable du rayon Livres */
create user TheoD identified by TD; /* responsable du rayon disque */
create user FrancoisH identified by FN; /* responsable du rayon disque */



/* Creation des differents tables */

/* table Clients */
CREATE TABLE Clients(
            id_cl NUMBER(3),
            date_ab DATE,
            duree_ab NUMBER(2),
            id_p NUMBER(3),
            CONSTRAINT clients_pk PRIMARY KEY (id_cl));



/* table Personnes */
CREATE TABLE Personnes(
            id_p NUMBER(3),
            nom VARCHAR2(20),
            prenom VARCHAR2(20),
            adresse VARCHAR2(50),
            tel NUMBER(10),
            CONSTRAINT Personnes_pk PRIMARY KEY (id_p));

/* table Employes */
CREATE TABLE Employes(
            id_empl NUMBER(3),
            id_chef NUMBER(3),
            rayon VARCHAR2(30) check(rayon='Livres' OR rayon='Films' OR rayon='Disques')  ,
            heure_emb DATE,
            heure_deb DATE,
            id_p NUMBER(3),
            CONSTRAINT employes_pk PRIMARY KEY (id_empl));
            
/* table Chefs */
CREATE TABLE Chefs(
            id_chef NUMBER(3),
            id_empl NUMBER(3),
            CONSTRAINT chefs_pk PRIMARY KEY (id_chef),
            CONSTRAINT chefs_fk FOREIGN KEY (id_empl) REFERENCES Employes(id_empl));
            
/* table Medias */
CREATE TABLE Medias(
            ref_m NUMBER(3),
            type_m VARCHAR2(20) check(type_m='Livre' OR type_m='Film' OR type_m='Disque'),
            titre VARCHAR2(40),
            genre VARCHAR2(20),
            annee DATE,
            editeur VARCHAR2(40),
            groupe VARCHAR2(40),
            realisateur VARCHAR2(40),
            CONSTRAINT medias_pk PRIMARY KEY (ref_m));
            
/* table Emprunts */            
CREATE TABLE Emprunts(
            id_cl NUMBER(3),
            ref_m NUMBER(3),
            date_emp DATE,
            date_ret_reelle DATE,
            CONSTRAINT emprunts_pk PRIMARY KEY (id_cl, ref_m, date_emp),
            CONSTRAINT emprunts_fk1 FOREIGN KEY (id_cl) REFERENCES Clients(id_cl),
            CONSTRAINT emprunts_fk2 FOREIGN KEY (ref_m) REFERENCES Medias(ref_m));

/* table Emprunt */   
CREATE TABLE Retours(
            ref_m NUMBER(3),
            date_emp DATE,
            date_ret_prevue DATE,
            CONSTRAINT Retours_pk PRIMARY KEY (ref_m, date_emp),
            CONSTRAINT Retours_fk1 FOREIGN KEY (ref_m) REFERENCES Medias(ref_m));
            
/* table Livres */            
CREATE TABLE Livres(
          titre VARCHAR2(30),
          auteur VARCHAR2(30),
          editeur VARCHAR2(30),
          CONSTRAINT livres_pk PRIMARY KEY (titre, editeur));

/* table Films */           
CREATE TABLE Films(
          titre VARCHAR2(30),
          realisateur VARCHAR2(20),
          duree_f NUMBER(3),
          CONSTRAINT films_pk PRIMARY KEY (titre, realisateur));

/* table Disques */          
CREATE TABLE Disques(
          titre VARCHAR2(40),
          groupe VARCHAR2(30),
          nb_pistes NUMBER(2),
          duree_d NUMBER(3),
          CONSTRAINT disques_pk PRIMARY KEY (titre, groupe));

/*Privileges des utilisateurs */
grant connect to PierreG;
grant connect to CedricB;
grant connect to TheoD;
grant connect to FrancoisH;
grant select on Disques to PierreG;
grant select on Livres to PierreG;
grant select on Films to PierreG;
grant select,update,insert on Livres to CedricB;
GRANT EXECUTE ON add_livre TO CedricB;
grant select,update,insert on Disques to TheoD;
GRANT EXECUTE ON add_cd TO TheoD;
grant select,update,insert on Films to FrancoisH;
GRANT EXECUTE ON add_film TO FrancoisH;


/* Creation des differents sequences */          
/* sequence seq_id_cl, pour les numeros des clients */
CREATE SEQUENCE seq_id_cl
START WITH 1
INCREMENT BY 1
NOCYCLE
MAXVALUE 999;

/* sequence seq_id_p, pour les numeros des personnes */
CREATE SEQUENCE seq_id_p
START WITH 1
INCREMENT BY 1
NOCYCLE
MAXVALUE 999;

/* sequence seq_id_empl, pour les numeros des employés */
CREATE SEQUENCE seq_id_empl
START WITH 1
INCREMENT BY 1
NOCYCLE
MAXVALUE 999;

/* sequence seq_id_chef, pour les numeros des chefs */
CREATE SEQUENCe seq_id_chef
START WITH 1
INCREMENT BY 1
NOCYCLE
MAXVALUE 999;

/* sequence seq_id_cd, pour les numeros des cd */
CREATE SEQUENCe seq_id_cd
START WITH 1
INCREMENT BY 1
NOCYCLE
MAXVALUE 299;

/* sequence seq_id_film, pour les numeros des films */
CREATE SEQUENCe seq_id_film
START WITH 300
INCREMENT BY 1
NOCYCLE
MAXVALUE 599;

/* sequence seq_id_livre, pour les numeros des livres */
CREATE SEQUENCe seq_id_livre
START WITH 600
INCREMENT BY 1
NOCYCLE
MAXVALUE 999; 
          
/* trigger qui ajoute un tupple a Emprunt */
CREATE OR REPLACE TRIGGER ajout_Retours
  AFTER INSERT
  ON EMPRUNTS
  FOR EACH ROW
BEGIN
  IF :NEW.ref_m<'600' THEN
    INSERT INTO Retours VALUES(:NEW.ref_m,:NEW.date_emp,:NEW.date_emp+21);
  ELSE
    INSERT INTO Retours VALUES(:NEW.ref_m,:NEW.date_emp,ADD_MONTHS(:NEW.date_emp,1));
  END IF;
END;
/

SET serveroutput ON;
/* trigger qui assure qu'un emprunt ne peut etre fait que si le media est disponible */   
CREATE OR REPLACE TRIGGER verif_emprunt
  BEFORE INSERT
  ON Emprunts
  FOR EACH ROW
DECLARE
  d NUMBER;
  deja_emprunte EXCEPTION;
BEGIN
  SELECT COUNT(*) INTO d
  FROM Emprunts 
  WHERE Emprunts.ref_m=:NEW.ref_m
  AND Emprunts.date_ret_reelle is null;
  IF d=1 THEN
    RAISE deja_emprunte;
  END IF;
EXCEPTION
  WHEN deja_emprunte THEN
    RAISE_APPLICATION_ERROR(-20001, 'Le document est déjà emprunté');
END;
/

/* Vue qui represente touts les media en retard */
CREATE OR REPLACE VIEW retard AS 
SELECT nom, prenom, EMPRUNTS.ref_m, EMPRUNTS.date_emp
FROM CLIENTS,PERSONNES, EMPRUNTS, Retours
WHERE CLIENTS.ID_CL=EMPRUNTS.ID_CL
AND PERSONNES.ID_P=CLIENTS.ID_P
AND EMPRUNTS.ref_m=Retours.REF_M
AND EMPRUNTS.DATE_EMP=Retours.DATE_EMP
AND Retours.DATE_RET_PREVUE<SYSDATE;



/* Vue qui represente touts les media disponible */
CREATE OR REPLACE VIEW disponibles AS
SELECT TITRE FROM MEDIAS WHERE MEDIAS.REF_M NOT IN
(SELECT REF_M FROM MEDIAS NATURAL JOIN EMPRUNTS);

/* procedure pour ajouter un client */
create or replace PROCEDURE add_cl(nom IN VARCHAR2, 
                                    prenom IN VARCHAR2, 
                                    adresse IN VARCHAR2, 
                                    tel IN NUMBER,
                                    date_ab IN DATE,
                                    duree_ab IN NUMBER)
IS 
BEGIN
    INSERT INTO PERSONNES VALUES(seq_id_p.nextval,prenom, nom,adresse, tel);
    INSERT INTO Clients VALUES(seq_id_cl.nextval,date_ab,duree_ab,seq_id_p.CURRVAL);
END;
/





/* procedure pour afficher les employés d'un rayon */
create or replace PROCEDURE EMP_RAYON (ray in VARCHAR2)
AS
CURSOR c1 IS
  SELECT PRENOM, NOM FROM PERSONNES,EMPLOYES
    WHERE PERSONNES.id_p = EMPLOYES.id_p
    and EMPLOYES.rayon = ray;
BEGIN
	FOR row IN c1 LOOP
    dbms_output.put_line(row.nom);
  END LOOP;
END;


/* procedure pour ajouter un employé */
create or replace PROCEDURE add_empl(nom IN VARCHAR2, 
                                    prenom IN VARCHAR2, 
                                    adresse IN VARCHAR2, 
                                    tel IN NUMBER,
                                    ray IN VARCHAR2, 
                                    h_e IN DATE, 
                                    h_d IN DATE)
IS
  id_c NUMBER(3);
BEGIN
    SELECT Employes.id_chef INTO id_c FROM Employes, Chefs WHERE Employes.id_empl=Chefs.id_empl AND Employes.rayon=ray;
    INSERT INTO PERSONNES VALUES(seq_id_p.nextval,prenom, nom,adresse, tel);
    INSERT INTO Employes VALUES(seq_id_empl.nextval,id_c,ray,h_e,h_d,seq_id_p.CURRVAL);
END;
/

/* procedure pour ajouter un cd */
CREATE OR REPLACE PROCEDURE add_cd(titre IN VARCHAR2,
                                    genre IN VARCHAR2,
                                    annee IN DATE,
                                    groupe IN VARCHAR2,
                                    nb_pistes IN NUMBER,
                                    duree IN NUMBER)
IS
  
BEGIN
    INSERT INTO Medias VALUES(seq_id_cd.nextval,'Disque',titre, genre, annee,'',groupe,'');
    INSERT INTO Disques VALUES(titre,groupe, nb_pistes,duree);
END;
/

/* procedure pour ajouter un film */
CREATE OR REPLACE PROCEDURE add_film(titre IN VARCHAR2,
                                    genre IN VARCHAR2,
                                    annee IN DATE,
                                    realisateur IN VARCHAR2,
                                    duree IN NUMBER)
IS
  
BEGIN
    INSERT INTO Medias VALUES(seq_id_film.nextval,'Film',titre, genre, annee,'','',realisateur);
    INSERT INTO Films VALUES(titre,realisateur,duree);
END;
/
 
/*procedure pour ajouter un livre */
CREATE OR REPLACE PROCEDURE add_livre(titre IN VARCHAR2,
                                    genre IN VARCHAR2,
                                    annee IN DATE,
                                    auteur IN VARCHAR2,
                                    editeur IN VARCHAR2)
IS
  
BEGIN
    INSERT INTO Medias VALUES(seq_id_livre.nextval,'Livre',titre, genre, annee,editeur,'','');
    INSERT INTO Livres VALUES(titre,auteur,editeur);
END;
/



/* Insertion de Tupples */


BEGIN
  add_cl('Eddy', 'Tudor', '15 rue de la couette', '0548384756',to_date('24-01-2015','DD-MM-YYYY'),'12');
  add_cl('Jean-Régis', 'Treux', '19 boulevard de la cassette', '0645346756',to_date('16-11-2014','DD-MM-YYYY'),'6');
  add_cl('Jean', 'Bon-Beurre', '17 rue du sandwich', '0685721514',to_date('16-10-2014','DD-MM-YYYY'),'12');
  add_cl('Valery', 'Iettes', '13 rue du gras', '0612967584',to_date('16-10-2014','DD-MM-YYYY'),'6');
  add_cl('Vladimir', 'Vaisselle', '17 rue du nettayant', '0678965236',to_date('16-10-2014','DD-MM-YYYY'),'6');
  add_cl('Theo', 'Remme', '08 avenue de Pythagore', '0645728589',to_date('15-11-2014','DD-MM-YYYY'),'6');
  add_cl('Sebastien', 'Moi-ca', '13 rue du maintien', '0632568975',to_date('08-09-2014','DD-MM-YYYY'),'12');
  add_cl('Manu', 'Tension', '8 impasse du transpallete', '0612457896',to_date('01-10-2014','DD-MM-YYYY'),'12');
  add_cl('Thomas', 'Ster', '03 rue ALMA', '0632458996',to_date('01-12-2014','DD-MM-YYYY'),'6');
  add_cl('Therese', 'Ponsable du Matos', '17 rue du placard', '0632569878',to_date('11-02-2014','DD-MM-YYYY'),'12');
END;
/
 SELECT * from personnes;
 

INSERT INTO Personnes VALUES(seq_id_p.nextval, 'Harry', 'Cobeurre', '02 rue de la cantine', '0635968658');
INSERT INTO Employes VALUES (seq_id_empl.nextval,seq_id_chef.nextval,'Films',to_date('08:00:00','HH24:MI:SS'),to_date('18:00:00','HH24:MI:SS'),seq_id_p.CURRVAL);
INSERT INTO Chefs VALUES (seq_id_chef.CURRVAL,seq_id_empl.CURRVAL);

INSERT INTO Personnes VALUES(seq_id_p.nextval, 'Laurent', 'Gina', '03 avenue du soda', '0632457896');
INSERT INTO Employes VALUES (seq_id_empl.nextval,seq_id_chef.nextval,'Livres',to_date('08:00:00','HH24:MI:SS'),to_date('18:00:00','HH24:MI:SS'),seq_id_p.CURRVAL);
INSERT INTO Chefs VALUES (seq_id_chef.CURRVAL,seq_id_empl.CURRVAL);

INSERT INTO Personnes VALUES(seq_id_p.nextval, 'Otto', 'Matik', '01 rue du distributeur', '0647856329');
INSERT INTO Employes VALUES (seq_id_empl.nextval,seq_id_chef.nextval,'Disques',to_date('08:00:00','HH24:MI:SS'),to_date('18:00:00','HH24:MI:SS'),seq_id_p.CURRVAL);
INSERT INTO Chefs VALUES (seq_id_chef.CURRVAL,seq_id_empl.CURRVAL);


BEGIN
  add_empl('Ines','Peré', '03 rue de la cantine', '0634519765','Disques',to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));
  add_empl('Sam', 'Convient', '05 rue de la frite', '0643596784','Disques',to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));
  add_empl('Sacha', 'Touille', '02 rue des nuages', '0645798613','Films',to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));
  add_empl('Vincent', 'Time', '12 boulevard du Dolez', '0654789635','Disques',to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));
  add_empl('Thomas', 'Wak', '12 avenue des songes', '0656325269','Disques',to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));
  add_empl('Terry', 'Gollo', '14 impasse de la foret', '0635427896','Films',to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));
  add_empl('Sarah', 'Croche', '17 rue de la medecine', '0645123669','Films',to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));
  add_empl('Paul', 'Ution', '16 rue de la Faculé', '0632457898','Livres',to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));
  
END;
/




BEGIN
  add_cd('The Score', 'hip hop', to_date('1995', 'YYYY'),'Fugees', '13', '73');
  add_cd( 'Kaya', 'reggae', to_date('1978', 'YYYY'),'Bob Marley and the Wailers', '10', '36');
  add_cd('Led Zeppelin', 'rock', to_date('1969', 'YYYY'),'Led Zeppelin', '13', '44');
  add_cd('La mauvaise réputation', 'chanson française', to_date('1952', 'YYYY'),'Georges Brassens', '8', '19');
  add_cd('Birdy Nam Nam', 'electro', to_date('2005', 'YYYY'),'Birdy Nam Nam', '17', '57');
  add_cd('Tetra', 'electro', to_date('2012', 'YYYY'),'C2C', '14', '57');
  add_cd('Appetite for destruction', 'rock', to_date('1987', 'YYYY'),'Guns n Roses', '12', '53');
  add_cd('Savane', 'africain blues', to_date('1987', 'YYYY'),'Ali Farka Toure', '13', '58');
  add_cd('Londinium', 'trip hop', to_date('1996', 'YYYY'),'Archive', '14', '61');
  
  add_film('Fantastic Mr Fox', 'animation', to_date('2010', 'YYYY'),'Wes Anderson', '88');
  add_film('La famille Tenenbaum', 'comédie', to_date('2002', 'YYYY'),'Wes Anderson', '108');
  add_film('La haine', 'drame', to_date('1995', 'YYYY'), 'Mathieu Kassovitz', '95');
  add_film('Le créateur', 'comédie', to_date('2001', 'YYYY'), 'Albert Dupontel', '92');
  add_film('The Man From Earth', 'drame', to_date('2011', 'YYYY'), 'Richard Schenkman', '87');
  add_film('Les tontons flingueurs', 'drame', to_date('1963', 'YYYY'), 'Georges Lautner', '105');
  add_film('Minuit à Paris', 'comédie', to_date('2011', 'YYYY'), 'Woody Allen', '94');
  add_film('Scoop', 'comédie', to_date('2006', 'YYYY'), 'Woody Allen', '96');
  add_film('Chat noir chat blanc', 'comédie', to_date('1998', 'YYYY'), 'Emir Kusturica', '127');
  add_film('Sacré graal', 'comédie', to_date('1975', 'YYYY'), 'Monty Python', '90');
  add_film('Le sens de la vie', 'comédie', to_date('1983', 'YYYY'), 'Monty Python', '107');
  add_film('La cité de la peur', 'comédie', to_date('1994', 'YYYY'), 'Alain Berbérian', '109');
  add_film('La stratégie de l echec', 'comédie', to_date('2001', 'YYYY'), 'Dominique Farrugia', '109');
  
  add_livre('La huitième couleur', 'fantaisie', to_date('1983', 'YYYY'),'Terry Pratchett', 'Colin Smythe');
  add_livre('Le huitième sortilège', 'fantaisie', to_date('1986', 'YYYY'),'Terry Pratchett', 'Colin Smythe');
  add_livre('Le petit prince', 'conte', to_date('1943', 'YYYY'),'Antoine de Saint-Exupéry', 'Colin Smythe');
  add_livre('L aube de Fondation', 'Science fiction', to_date('1993', 'YYYY'),'Isaac Asimov', 'Presse de la cité');
  add_livre( 'V pour Vendetta', 'Comics', to_date('1993', 'YYYY'),'Alan Moore', 'Quality Comics/Warrior');
  add_livre('Germinal', 'Roman', to_date('1885', 'YYYY'),'Emile Zola', 'Gil Blas');
  add_livre('Les fleurs du mal', 'Pésie', to_date('1857', 'YYYY'),'Charles Baudelaire', 'Auguste Poulet-Malassis');
  add_livre('La communauté de l anneau', 'fantasie', to_date('1954', 'YYYY'),'J.R.R. Tolkien', 'Allen and Unwin');
  add_livre('Une étude en rouge', 'policier', to_date('1887', 'YYYY'),'Arthur Conan Doyle', 'Hachette');
END;
/



INSERT INTO EMPRUNTS VALUES('001','602',to_date('12-02-2015','DD-MM-YYYY'),'');
INSERT INTO EMPRUNTS VALUES('010','602',to_date('12-04-2015','DD-MM-YYYY'),'');
INSERT INTO EMPRUNTS VALUES('004','601',to_date('12-04-2014','DD-MM-YYYY'),'');
INSERT INTO EMPRUNTS VALUES('004','001',to_date('15-03-2015','DD-MM-YYYY'),'');

commit;

