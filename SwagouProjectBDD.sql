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
            id_p NUMBER(2),
            nom VARCHAR2(20),
            prenom VARCHAR2(20),
            adresse VARCHAR2(20),
            tel NUMBER(10),
            CONSTRAINT Personnes_pk PRIMARY KEY (id_p));
            


CREATE TABLE Clients(
            id_cl NUMBER(2),
            date_ab DATE,
            duree_ab NUMBER(2),
            CONSTRAINT clients_pk PRIMARY KEY (id_cl),
            CONSTRAINT clients_fk FOREIGN KEY (id_cl) REFERENCES Personnes(id_p));


            

CREATE TABLE Employes(
            id_empl NUMBER(2),
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
            titre VARCHAR2(20),
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
          duree NUMBER(2),
          CONSTRAINT films_pk PRIMARY KEY (ref_f),
          CONSTRAINT films_fk FOREIGN KEY (ref_f) REFERENCES Medias(ref_m));
          
CREATE TABLE Disques(
          ref_d NUMBER(3),
          groupe VARCHAR2(20),
          nb_pistes NUMBER(2),
          duree NUMBER(2),
          CONSTRAINT disques_pk PRIMARY KEY (ref_d),
          CONSTRAINT disques_fk FOREIGN KEY (ref_d) REFERENCES Medias(ref_m));
          

          
          
