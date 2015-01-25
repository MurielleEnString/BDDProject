Spool TP1.log

DROP TABLE Services;
DROP TABLE Prets;
DROP TABLE Disques;
DROP TABLE Films;
DROP TABLE Livres;
DROP TABLE Medias;
DROP TABLE Employe;




CREATE TABLE Employe(
            id_empl NUMBER(2),
            nom VARCHAR2(20),
            prenom VARCHAR2(20),
            adresse VARCHAR2(20),
            CONSTRAINT employe_pk PRIMARY KEY (id_empl));
            
CREATE TABLE Medias(
            id_m NUMBER(3),
            titre VARCHAR2(20),
            genre VARCHAR2(20),
            CONSTRAINT medias_pk PRIMARY KEY (id_m));
            
            
CREATE TABLE Livres(
          id_l NUMBER(3),
          auteur VARCHAR2(20),
          editeur VARCHAR2(20),
          CONSTRAINT livres_pk PRIMARY KEY (id_l));
           
CREATE TABLE Films(
          id_f NUMBER(3),
          realisateur VARCHAR2(20),
          CONSTRAINT films_pk PRIMARY KEY (id_f));
          
CREATE TABLE Disques(
          id_d NUMBER(3),
          groupe VARCHAR2(20),
          nb_pistes NUMBER(2),
          duree NUMBER(2),
          CONSTRAINT disques_pk PRIMARY KEY (id_d));
          
CREATE TABLE Prets(
          id_m NUMBER(3),
          date_emp date,
          date_ret date,
          CONSTRAINT prets_pk PRIMARY KEY (id_m, date_emp, date_ret),
          CONSTRAINT prets_fk FOREIGN KEY (id_m) REFERENCES Medias(id_m));
          
CREATE TABLE Services (
          id_serv  NUMBER(2),
          nom_serv VARCHAR2(20),
          id_dir  NUMBER(2),
          CONSTRAINT service_pk PRIMARY KEY (id_serv));
          
Spool off