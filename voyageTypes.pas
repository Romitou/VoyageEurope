unit voyageTypes;

interface
uses sysutils;

type TTransport = (Train, TrainAvion);
type TMois = (Janvier, Fevrier, Mars, Avril, Mai, Juin, Juillet, Aout, Septembre, Octobre, Novembre, Decembre);
type TPref = (Aventure, Culture, Gastronomie, Nature, Relaxation, VieNocturne, Shopping, Art, Education,
    BienEtre, Sport, AventureAquatique, FestivalsEtEvenements, Romantique, EnFamille, EntreAmis, Solo, Luxe, Budget, EcoResponsable,
    Immersif, Authentique, RoadTrip, VoyageEnTrain, CourtTerme, JourneeComplete, MultiJours, Relaxant, Actif, Intensif, Modere,
    Debutant,Histoire, ArtisanatLocal, Photographie, ObservationFaune, Agritourisme,
    Mystere, CinemaEtTelevision, ReligieuxEtSpirituel,Enfants, MobiliteReduite, TouteAnnee, ActiviteSaisonniere, Climatisation,
    TemperatureDouce, Guide, NonGuide,Hiver, Printemps, Ete, Automne, TouteSaison, SaisonFestivals);
type TExperience = (Economique, Ecologique, RespectDesTemperatures, RespectDesActivites);


type TActivite = record
    nom: String;
    categories: Array of TPref;
    cout: Real;
    minutes: Integer;
end;
type TActivites = Array of TActivite;

type TPays = record
    nom: String;
    capitale: String;
    activites: Array of TActivite;
    ordreAct: Array of Integer;
    nomFrontieres: TStringArray;
    nomAvions: TStringArray;
    climat: Array[TMois] of Integer;
    score: Real;
    longitude: Real;
    latitude: Real;
end;

type TEurope = Array of TPays;

type TCriteres = record
    paysDepart: TPays;
    paysArrivee: TPays;
    categories: Array of TPref;
    duree: Integer;
    periode: TMois;
    climat: Integer;
    budget: Real;
    transport: TTransport;
    coeffClimat: Real;
    coeffActivite: Real;
    coeffCout: Real;
    intervalleTemperature: Real;
    nbVoyageurs: Integer;
end;

type TMenu = record
    nom: String;
    preferences: array of TPref;
    description: String;
  end;

type TMenus = array of TMenu;

type TDeplacement = record
    paysDepart: TPays;
    paysEtape: TPays;
    distance: Real;
    cout: Real;
    minutes: Integer;
end;

type TEtape = record
    estActivite: Boolean;
    activite: TActivite;
    deplacement: TDeplacement;
end;
type TEtapes = Array of TEtape;

type TJournee = record
    jour: Integer;
    etapes: TEtapes;
end;
type TJournees = Array of TJournee;

type TVoyage = record
    itineraire: Array of TPays;
    etapes: TEtapes;
    planning: TJournees;
    coutTotal: Real;
    kmTotal: Real;
    erreur: Boolean;
    message: String;
    transport: TTransport;
    carbonImpact: Real;
end;

type TItineraireResult = record
    itineraire: Array of TPays;
    erreur: Boolean;
    message: String;
end;

// Chargement des données
type TFilePays = record
    nom: String;
    capitale: String;
    code: String;
    codeFrontieres: TStringArray;
    codeAvions: TStringArray;
    climatString: TStringArray;
    longitude: Real;
    latitude: Real;
end;
type TArrayFilePays = Array of TFilePays;

type TFileActivite = record
    nom: String;
    pays: String;
    categories: Array of TPref;
    cout: Real;
    minutes: Integer;
end;
type TArrayFileActivite = Array of TFileActivite;

implementation
end.
