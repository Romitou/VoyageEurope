unit types;

interface
uses sysutils;

type TMois = (Janvier, Fevrier, Mars, Avril, Mai, Juin, Juillet, Aout, Septembre, Octobre, Novembre, Decembre);
type TPref = (Aventure, Culture, Gastronomie, Nature, Relaxation, VieNocturne, Shopping, 
    BienEtre, Sport, AventureAquatique, FestivalsEtEvenements,Romantique, EnFamille, EntreAmis, Solo, Luxe, Budget, EcoResponsable, 
    Immersif, Authentique, RoadTrip, VoyageEnTrain,CourtTerme, JourneeComplete, MultiJours, Relaxant, Actif, Intensif, Modere, 
    Debutant,Histoire, ArtisanatLocal, Photographie, ObservationFaune, Agritourisme, 
    Mystere, CinemaEtTelevision, ReligieuxEtSpirituel,Enfants, MobiliteReduite, TouteAnnee, ActiviteSaisonniere, Climatisation, 
    TemperatureDouce, Guide, NonGuide,Hiver, Printemps, Ete, Automne, TouteSaison, SaisonFestivals);


type TActivite = record
    nom: String;
    categories: Array of TPref;
    cout: Real;
end;
type TActivites = Array of TActivite;

type TPays = record
    nom: String;
    capitale: String;
    activites: Array of TActivite;
    nomFrontieres: TStringArray;
    climat: Array[TMois] of Integer;
    longitude: Real;
    latitude: Real;
end;

type TEurope = Array of TPays;

type TCriteres = record
    paysDepart: TPays;
    paysArrivee: TPays;
    categorie: Array of TPref;
    duree: Integer;
    periode: TMois;
    climat: Real;
end;

type TEtape = record
    jour: Integer;
    activite: Array of TActivite;
end;

type TVoyage = record
    itineraire: Array of TPays;
    planning: Array of TEtape;
    coutTotal: Real;
    kmTotal: Real;
end;

// Chargement des données
type TFilePays = record
    nom: String;
    capitale: String;
    code: String;
    codeFrontieres: TStringArray;
    climat: Array[TMois] of Integer;
    longitude: Real;
    latitude: Real;
end;
type TArrayFilePays = Array of TFilePays;

type TFileActivite = record
    nom: String;
    pays: String;
    categories: Array of TPref;
    cout: Real;
end;
type TArrayFileActivite = Array of TFileActivite;

// Dijkstra

type TDijkstraResult = record
    error: Boolean;
    message: String;
    startPays: String;
    endPays: String;
    distance: Integer;
    chemin: TStringArray;
end; 

implementation
end.
