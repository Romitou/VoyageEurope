unit voyageTypes;

interface
uses sysutils;

type TMois = (Janvier, Fevrier, Mars, Avril, Mai, Juin, Juillet, Aout, Septembre, Octobre, Novembre, Decembre);
type TPref = (Aventure, Culture, Gastronomie, Nature, Relaxation, VieNocturne, Shopping, Art, Education,
    BienEtre, Sport, AventureAquatique, FestivalsEtEvenements, Romantique, EnFamille, EntreAmis, Solo, Luxe, Budget, EcoResponsable, 
    Immersif, Authentique, RoadTrip, VoyageEnTrain, CourtTerme, JourneeComplete, MultiJours, Relaxant, Actif, Intensif, Modere, 
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
    climat: Real;
end;

type TEtape = record
    jour: Integer;
    activite: Array of TActivite;
    paysEtape: TPays;
end;

type TEtapes = Array of TEtape;

type TVoyage = record
    itineraire: Array of TPays;
    planning: TEtapes;
    coutTotal: Real;
    kmTotal: Real;
    erreur: Boolean;
    message: String;
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
end;
type TArrayFileActivite = Array of TFileActivite;

implementation
end.
