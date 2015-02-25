DROP SEQUENCE seq_id_cl;

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

CREATE TABLE Personnes(
            id_p NUMBER(3),
            nom VARCHAR2(20),
            prenom VARCHAR2(20),
            adresse VARCHAR2(50),
            tel NUMBER(10),
            CONSTRAINT Personnes_pk PRIMARY KEY (id_p));
            


CREATE TABLE Clients(
            id_cl NUMBER(3),
            date_ab DATE,
            duree_ab NUMBER(2),
            CONSTRAINT clients_pk PRIMARY KEY (id_cl),
            CONSTRAINT clients_fk FOREIGN KEY (id_cl) REFERENCES Personnes(id_p));


            

CREATE TABLE Employes(
            id_empl NUMBER(3),
            id_chef NUMBER(2),
            heure_emb DATE,
            heure_deb DATE,
            CONSTRAINT employes_pk PRIMARY KEY (id_empl),
            CONSTRAINT Employes_fk FOREIGN KEY (id_empl) REFERENCES Personnes(id_p));
            
CREATE TABLE Chefs(
            id_chef NUMBER(2),
            rayon VARCHAR(20),
            CONSTRAINT chefs_pk PRIMARY KEY (id_chef),
            CONSTRAINT chefs_fk FOREIGN KEY (id_chef) REFERENCES Employes(id_empl));
            
            
CREATE TABLE Medias(
            ref_m NUMBER(3),
            titre VARCHAR2(40),
            genre VARCHAR2(20),
            annee DATE,
            CONSTRAINT medias_pk PRIMARY KEY (ref_m));
            
            
CREATE TABLE Emprunts(
            id_cl NUMBER(2),
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
            CONSTRAINT emprunts_fk FOREIGN KEY (ref_m) REFERENCES Medias(ref_m));
            
            
CREATE TABLE Livres(
          ref_l NUMBER(3),
          auteur VARCHAR2(20),
          editeur VARCHAR2(20),
          CONSTRAINT livres_pk PRIMARY KEY (ref_l),
          CONSTRAINT livres_fk FOREIGN KEY (ref_l) REFERENCES Medias(ref_m));
           
CREATE TABLE Films(
          ref_f NUMBER(3),
          realisateur VARCHAR2(20),
          duree NUMBER(3),
          CONSTRAINT films_pk PRIMARY KEY (ref_f),
          CONSTRAINT films_fk FOREIGN KEY (ref_f) REFERENCES Medias(ref_m));
          
CREATE TABLE Disques(
          ref_d NUMBER(3),
          groupe VARCHAR2(30),
          nb_pistes NUMBER(2),
          duree NUMBER(2),
          CONSTRAINT disques_pk PRIMARY KEY (ref_d),
          CONSTRAINT disques_fk FOREIGN KEY (ref_d) REFERENCES Medias(ref_m));
          

CREATE SEQUENCE seq_id_cl
START WITH 1
INCREMENT BY 1
NOCYCLE
MAXVALUE 700;

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Eddy', 'Tudor', '15 rue de la couette', '0548384756');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('24-01-2015','DD-MM-YYYY'),'12');

INSERT INTO Personnes VALUES(seq_id_cl.nextval, 'Jean-Régis', 'Treux', '19 boulevard de la cassette', '0645346756');
INSERT INTO Clients VALUES (seq_id_cl.CURRVAL,to_date('16-11-2014','DD-MM-YYYY'),'6');


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


INSERT INTO Disques VALUES('001','Fugees', '13', '73');
INSERT INTO Disques VALUES('002','Bob Marley and the Wailers', '10', '36');
INSERT INTO Disques VALUES('003','Led Zeppelin', '13', '44');
INSERT INTO Disques VALUES('004','Georges Brassens', '8', '19');
INSERT INTO Disques VALUES('005','Birdy Nam Nam', '17', '57');
INSERT INTO Disques VALUES('006','C2C', '14', '57');
INSERT INTO Disques VALUES('007','Guns n Roses', '12', '53');
INSERT INTO Disques VALUES('008','Ali Farka Toure', '13', '58');
INSERT INTO Disques VALUES('009','Archive', '14', '61');



          
