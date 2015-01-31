
DROP TABLE Prets;
DROP TABLE Clients;
DROP TABLE Disques;
DROP TABLE Films;
DROP TABLE Livres;
DROP TABLE Medias;
DROP TABLE Employes;

CREATE TABLE Clients(
            id_cl NUMBER(2),
            nom VARCHAR2(20),
            prenom VARCHAR2(20),
            adresse VARCHAR2(20),
            tel NUMBER(10),
            CONSTRAINT clients_pk PRIMARY KEY (id_cl));


CREATE TABLE Employes(
            id_empl NUMBER(2),
            nom VARCHAR2(20),
            prenom VARCHAR2(20),
            adresse VARCHAR2(20),
            CONSTRAINT employes_pk PRIMARY KEY (id_empl));
            
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
          duree NUMBER(2),
          CONSTRAINT films_pk PRIMARY KEY (id_f));
          
CREATE TABLE Disques(
          id_d NUMBER(3),
          groupe VARCHAR2(20),
          nb_pistes NUMBER(2),
          duree NUMBER(2),
          CONSTRAINT disques_pk PRIMARY KEY (id_d));
          
CREATE TABLE Prets(
          id_m NUMBER(3),
          id_cl NUMBER(2),
          date_emp date,
          date_ret date,
          CONSTRAINT prets_pk PRIMARY KEY (id_m, date_emp, date_ret),
          CONSTRAINT prets_fk1 FOREIGN KEY (id_m) REFERENCES Medias(id_m),
          CONSTRAINT prets_fk2 FOREIGN KEY (id_cl) REFERENCES Clients(id_cl));
          
          
