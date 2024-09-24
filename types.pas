unit types;

interface

type TMois = (Janvier, Fevrier, Mars, Avril, Mai, Juin, Juillet, Aout, Septembre, Octobre, Novemebre, Decembre);
type TPref = (sport, monument, musee, lieuUnique, divers);

type TActivite = record
    nom: String;
    categorie: Array of TPref;
    cout: Real;
end;

type TPays = record
    nom: String;
    capitale: String;
    activites: Array of TActivite;
    nomFrontieres: Array of String;
    climat: Array[TMois] of Integer;
end;

type TEurope = Array of TPays;

type TCriteres = record
    paysDepart: TPays;
    paysArrivee: TPays;
    categorie: Array of TPref;
    duree: Integer;
    periode: TMois;
end;

type TEtape = record
    jour: Integer;
    activite: TActivite;
end;

type TVoyage = record
    intineraire: Array of TPays;
    planning: Array of TEtape;
    coutTotal: Integer;
    kmTotal: Integer;
end;

implementation
end.
