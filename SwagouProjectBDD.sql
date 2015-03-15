/*DROP SEQUENCE seq_id_cl;
DROP SEQUENCE seq_id_empl;
*/

DROP TABLE Disques;
DROP TABLE Films;
DROP TABLE Livres;
DROP TABLE Emprunts2;
DROP TABLE Emprunts;
DROP TABLE Medias;
DROP TABLE Chefs;
DROP TABLE Employes;
DROP TABLE Clients;
DROP TABLE Personnes;

CREATE TABLE Clients(
            id_cl NUMBER(3),
            date_ab DATE,
            duree_ab NUMBER(2),
            id_p NUMBER(3),
            CONSTRAINT clients_pk PRIMARY KEY (id_cl));
            
CREATE TABLE Personnes(
            id_p NUMBER(3),
            nom VARCHAR2(20),
            prenom VARCHAR2(20),
            adresse VARCHAR2(50),
            tel NUMBER(10),
            CONSTRAINT Personnes_pk PRIMARY KEY (id_p));
            
CREATE TABLE Employes(
            id_empl NUMBER(3),
            id_chef NUMBER(3),
            rayon VARCHAR2(30),
            heure_emb DATE,
            heure_deb DATE,
            CONSTRAINT employes_pk PRIMARY KEY (id_empl));
            
CREATE TABLE Chefs(
            id_chef NUMBER(3),
            id_empl NUMBER(3),
            CONSTRAINT chefs_pk PRIMARY KEY (id_chef),
            CONSTRAINT chefs_fk FOREIGN KEY (id_empl) REFERENCES Employes(id_empl));
            
            
CREATE TABLE Medias(
            ref_m NUMBER(3),
            type_m VARCHAR2(20),
            titre VARCHAR2(40),
            genre VARCHAR2(20),
            annee DATE,
            editeur VARCHAR2(40),
            groupe VARCHAR2(40),
            realisateur VARCHAR2(40),
            CONSTRAINT medias_pk PRIMARY KEY (ref_m));
            
            
CREATE TABLE Emprunts(
            id_cl NUMBER(3),
            ref_m NUMBER(3),
            date_emp DATE,
            date_ret_reelle DATE,
            CONSTRAINT emprunts_pk PRIMARY KEY (id_cl, ref_m, date_emp),
            CONSTRAINT emprunts_fk1 FOREIGN KEY (id_cl) REFERENCES Clients(id_cl),
            CONSTRAINT emprunts_fk2 FOREIGN KEY (ref_m) REFERENCES Medias(ref_m));
            
CREATE TABLE Emprunts2(
            ref_m NUMBER(3),
            date_emp DATE,
            date_ret_prevue DATE,
            CONSTRAINT emprunts2_pk PRIMARY KEY (ref_m, date_emp),
            CONSTRAINT emprunts2_fk1 FOREIGN KEY (ref_m) REFERENCES Medias(ref_m));
            
            
CREATE TABLE Livres(
          titre VARCHAR2(30),
          auteur VARCHAR2(30),
          editeur VARCHAR2(30),
          CONSTRAINT livres_pk PRIMARY KEY (titre, editeur));
           
CREATE TABLE Films(
          titre VARCHAR2(30),
          realisateur VARCHAR2(20),
          duree_f NUMBER(3),
          CONSTRAINT films_pk PRIMARY KEY (titre, realisateur));
          
CREATE TABLE Disques(
          titre NUMBER(3),
          groupe VARCHAR2(30),
          nb_pistes NUMBER(2),
          duree_d NUMBER(2),
          CONSTRAINT disques_pk PRIMARY KEY (titre, groupe));
          

          
          
/*          
CREATE OR REPLACE TRIGGER ajout_emprunts2
  AFTER INSERT
  ON EMPRUNTS
  FOR EACH ROW
BEGIN
  IF :NEW.ref_m<'600' THEN
    INSERT INTO EMPRUNTS2 VALUES(:NEW.ref_m,:NEW.date_emp,:NEW.date_emp+21);
  ELSE
    INSERT INTO EMPRUNTS2 VALUES(:NEW.ref_m,:NEW.date_emp,ADD_MONTHS(:NEW.date_emp,1));
  END IF;
END;
/

CREATE OR REPLACE TRIGGER VERIF_ABONNEMENT 
BEFORE INSERT ON EMPRUNTS
FOR EACH ROW
DECLARE
	abonnement_expiré_exception EXCEPTION;
  duree_abonement_exception EXCEPTION;
  date_abo DATE;
  duree_abo NUMBER;
  
BEGIN
  
  SELECT DATE_AB INTO date_abo FROM CLIENTS WHERE CLIENTS.ID_CL = :NEW.ID_CL;
  SELECT DUREE_AB INTO duree_abo FROM CLIENTS WHERE CLIENTS.ID_CL = :NEW.ID_CL;
  

  if :NEW.DATE_EMP > ADD_MONTHS(date_abo,duree_abo) then
    raise abonnement_expiré_exception;
  end if;

EXCEPTION

  WHEN abonnement_expiré_exception THEN
		RAISE_APPLICATION_ERROR(-20001, 'Erreur : Labonement du client a expiré.');
  WHEN duree_abonement_exception THEN
		RAISE_APPLICATION_ERROR(-20002, 'Erreur : la durée de labonement nest pas correct.');

  
END; 
/         

CREATE SEQUENCE seq_id_cl
START WITH 1
INCREMENT BY 1
NOCYCLE
MAXVALUE 700;

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Eddy', 'Tudor', '15 rue de la couette', '0548384756');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('24-01-2015','DD-MM-YYYY'),'12');

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Jean-Régis', 'Treux', '19 boulevard de la cassette', '0645346756');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('16-11-2014','DD-MM-YYYY'),'6');
INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Jean', 'Bon-Beurre', '17 rue du sandwich', '0685721514');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('16-10-2014','DD-MM-YYYY'),'12');

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Valery', 'Iettes', '13 rue du gras', '0612967584');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('16-10-2014','DD-MM-YYYY'),'6');

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Vladimir', 'Vaisselle', '17 rue du nettayant', '0678965236');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('16-10-2014','DD-MM-YYYY'),'6');

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Theo', 'Remme', '08 avenue de Pythagore', '0645728589');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('15-11-2014','DD-MM-YYYY'),'6');

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Sebastien', 'Moi-ca', '13 rue du maintien', '0632568975');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('08-09-2014','DD-MM-YYYY'),'12');

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Manu', 'Tension', '8 impasse du transpallete', '0612457896');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('01-10-2014','DD-MM-YYYY'),'12');

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Thomas', 'Ster', '03 rue ALMA', '0632458996');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('01-12-2014','DD-MM-YYYY'),'6');

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Therese', 'Ponsable du Matos', '17 rue du placard', '0632569878');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('11-02-2014','DD-MM-YYYY'),'12');



CREATE SEQUENCE seq_id_empl
START WITH 950
INCREMENT BY 1
NOCYCLE
MAXVALUE 999;


INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Harry', 'Cobeurre', '02 rue de la cantine', '0635968658');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,seq_id_empl.CURRVAL,to_date('08:00:00','HH24:MI:SS'),to_date('18:00:00','HH24:MI:SS'));
INSERT INTO Chefs VALUES (seq_id_empl.CURRVAL,'Livres');

INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Laurent', 'Gina', '03 avenue du soda', '0632457896');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,seq_id_empl.CURRVAL,to_date('08:00:00','HH24:MI:SS'),to_date('18:00:00','HH24:MI:SS'));
INSERT INTO Chefs VALUES (seq_id_empl.CURRVAL,'Films');

INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Otto', 'Matik', '01 rue du distributeur', '0647856329');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,seq_id_empl.CURRVAL,to_date('08:00:00','HH24:MI:SS'),to_date('18:00:00','HH24:MI:SS'));
INSERT INTO Chefs VALUES (seq_id_empl.CURRVAL,'Disques');



INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Ines', 'Peré', '03 rue de la cantine', '0634519765');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,101,to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));            

INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Sam', 'Convient', '05 rue de la frite', '0643596784');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,101,to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS')); 

INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Sacha', 'Touille', '02 rue des nuages', '0645798613');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,101,to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS')); 




INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Vincent', 'Time', '12 boulevard du Dolez', '0654789635');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,102,to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));            

INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Thomas', 'Wak', '12 avenue des songes', '0656325269');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,102,to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS')); 

INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Terry', 'Gollo', '14 impasse de la foret', '0635427896');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,102,to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));  




INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Sarah', 'Croche', '17 rue de la medecine', '0645123669');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,103,to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));            

INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Sam', 'Convient', '14 rue du poney', '0635687899');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,103,to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS')); 

INSERT INTO Personnes VALUES(seq_id_empl.nextval, 'Paul', 'Ution', '16 rue de la Faculé', '0632457898');
INSERT INTO Employes VALUES (seq_id_empl.CURRVAL,103,to_date('09:00:00','HH24:MI:SS'),to_date('17:00:00','HH24:MI:SS'));  

INSERT INTO Medias VALUES('001', 'The Score', 'hip hop', to_date('1995', 'YYYY'));
INSERT INTO Medias VALUES('002', 'Kaya', 'reggae', to_date('1978', 'YYYY'));
INSERT INTO Medias VALUES('003', 'Led Zeppelin', 'rock', to_date('1969', 'YYYY'));
INSERT INTO Medias VALUES('004', 'La mauvaise réputation', 'chanson française', to_date('1952', 'YYYY'));
INSERT INTO Medias VALUES('005', 'Birdy Nam Nam', 'electro', to_date('2005', 'YYYY'));
INSERT INTO Medias VALUES('006', 'Tetra', 'electro', to_date('2012', 'YYYY'));
INSERT INTO Medias VALUES('007', 'Appetite for destruction', 'rock', to_date('1987', 'YYYY'));
INSERT INTO Medias VALUES('008', 'Savane', 'africain blues', to_date('1987', 'YYYY'));
INSERT INTO Medias VALUES('009', 'Londinium', 'trip hop', to_date('1996', 'YYYY'));
INSERT INTO Medias VALUES('300', 'Fantastic Mr Fox', 'animation', to_date('2010', 'YYYY'));
INSERT INTO Medias VALUES('301', 'La famille Tenenbaum', 'comédie', to_date('2002', 'YYYY'));
INSERT INTO Medias VALUES('302', 'La haine', 'drame', to_date('1995', 'YYYY'));
INSERT INTO Medias VALUES('303', 'Le créateur', 'comédie', to_date('2001', 'YYYY'));
INSERT INTO Medias VALUES('304', 'The Man From Earth', 'drame', to_date('2011', 'YYYY'));
INSERT INTO Medias VALUES('305', 'Les tontons flingueurs', 'drame', to_date('1963', 'YYYY'));
INSERT INTO Medias VALUES('306', 'Minuit à Paris', 'comédie', to_date('2011', 'YYYY'));
INSERT INTO Medias VALUES('307', 'Scoop', 'comédie', to_date('2006', 'YYYY'));
INSERT INTO Medias VALUES('308', 'Chat noir chat blanc', 'comédie', to_date('1998', 'YYYY'));
INSERT INTO Medias VALUES('309', 'Sacré graal', 'comédie', to_date('1975', 'YYYY'));
INSERT INTO Medias VALUES('310', 'Le sens de la vie', 'comédie', to_date('1983', 'YYYY'));
INSERT INTO Medias VALUES('311', 'La cité de la peur', 'comédie', to_date('1994', 'YYYY'));
INSERT INTO Medias VALUES('312', 'La stratégie de l echec', 'comédie', to_date('2001', 'YYYY'));
INSERT INTO Medias VALUES('600', 'La huitième couleur', 'fantaisie', to_date('1983', 'YYYY'));
INSERT INTO Medias VALUES('601', 'Le huitième sortilège', 'fantaisie', to_date('1986', 'YYYY'));
INSERT INTO Medias VALUES('602', 'Le petit prince', 'conte', to_date('1943', 'YYYY'));
INSERT INTO Medias VALUES('603', 'L aube de Fondation', 'Science fiction', to_date('1993', 'YYYY'));
INSERT INTO Medias VALUES('604', 'V pour Vendetta', 'Comics', to_date('1993', 'YYYY'));
INSERT INTO Medias VALUES('605', 'Germinal', 'Roman', to_date('1885', 'YYYY'));
INSERT INTO Medias VALUES('606', 'Les fleurs du mal', 'Pésie', to_date('1857', 'YYYY'));
INSERT INTO Medias VALUES('607', 'La communauté de l anneau', 'fantasie', to_date('1954', 'YYYY'));
INSERT INTO Medias VALUES('608', 'Une étude en rouge', 'policier', to_date('1887', 'YYYY'));


INSERT INTO Films VALUES('300', 'Wes Anderson', '88');
INSERT INTO Films VALUES('301', 'Wes Anderson', '108');
INSERT INTO Films VALUES('302', 'Mathieu Kassovitz', '95');
INSERT INTO Films VALUES('303', 'Albert Dupontel', '92');
INSERT INTO Films VALUES('304', 'Richard Schenkman', '87');
INSERT INTO Films VALUES('305', 'Georges Lautner', '105');
INSERT INTO Films VALUES('306', 'Woody Allen', '94');
INSERT INTO Films VALUES('307', 'Woody Allen', '96');
INSERT INTO Films VALUES('308', 'Emir Kusturica', '127');
INSERT INTO Films VALUES('309', 'Monty Python', '90');
INSERT INTO Films VALUES('310', 'Monty Python', '107');
INSERT INTO Films VALUES('311', 'Alain Berbérian', '109');
INSERT INTO Films VALUES('312', 'Dominique Farrugia', '109');


INSERT INTO Disques VALUES('001','Fugees', '13', '73');
INSERT INTO Disques VALUES('002','Bob Marley and the Wailers', '10', '36');
INSERT INTO Disques VALUES('003','Led Zeppelin', '13', '44');
INSERT INTO Disques VALUES('004','Georges Brassens', '8', '19');
INSERT INTO Disques VALUES('005','Birdy Nam Nam', '17', '57');
INSERT INTO Disques VALUES('006','C2C', '14', '57');
INSERT INTO Disques VALUES('007','Guns n Roses', '12', '53');
INSERT INTO Disques VALUES('008','Ali Farka Toure', '13', '58');
INSERT INTO Disques VALUES('009','Archive', '14', '61');

INSERT INTO Livres VALUES('600','Terry Pratchett', 'Colin Smythe');
INSERT INTO Livres VALUES('601','Terry Pratchett', 'Colin Smythe');
INSERT INTO Livres VALUES('602','Antoine de Saint-Exupéry', 'Colin Smythe');
INSERT INTO Livres VALUES('603','Isaac Asimov', 'Presse de la cité');
INSERT INTO Livres VALUES('604','Alan Moore', 'Quality Comics/Warrior');
INSERT INTO Livres VALUES('605','Emile Zola', 'Gil Blas');
INSERT INTO Livres VALUES('606','Charles Baudelaire', 'Auguste Poulet-Malassis');
INSERT INTO Livres VALUES('607','J.R.R. Tolkien', 'Allen and Unwin');
INSERT INTO Livres VALUES('608','Arthur Conan Doyle', 'Hachette');


INSERT INTO EMPRUNTS VALUES('001','602',to_date('12-02-2015','DD-MM-YYYY'),'');
INSERT INTO EMPRUNTS VALUES('010','602',to_date('12-04-2015','DD-MM-YYYY'),'');
*/
