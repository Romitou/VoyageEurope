TypesDuProjet
type TMois =(Janvier, Fevrier, Mars, Avril, Mai, Juin, Juillet, Aout, Septembre, Octobre, Novemebre, Decembre);
type TPref =(sport, monument, musee, lieuUnique, divers);
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
type TCriteres = record
paysDepart: TPays;
paysArrivee: TPays;
categorie: Array of TPref;
mois: TMois;
end;
type TEtape = record
jour: Integer;
activite: TActivite;
end;
type TVoyage = record
intineraire: Array of TPays;
planning: Array oif TEtape;
coutTotal: Integer;
kmTotal: Integer;
end;


