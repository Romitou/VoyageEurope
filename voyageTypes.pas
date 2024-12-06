unit voyageTypes;

interface
uses sysutils;

type TMode = (TrainSeul, TrainEtAvion);
type TTransport = (Train, Avion);
type TMois = (Janvier, Fevrier, Mars, Avril, Mai, Juin, Juillet, Aout, Septembre, Octobre, Novembre, Decembre);
type TPref = (
    // Type d'activité
    Aventure, Culture, Gastronomie, Nature, Relaxation, VieNocturne, Shopping, Art, Education, Architecture,
    BienEtre, Sport, Aquatique, FestivalsEtEvenements, Histoire, ArtisanatLocal, Photographie, ObservationFaune,
    Mystere, CinemaEtTelevision, ReligieuxEtSpirituel, Authentique, Immersif,
    
    // Occasion
    Romantique, Famille, EntreAmis, Solo,

    // Type de séjour
    Luxe, EcoResponsable,

    // Qualification de l'activité
    Guide, Actif, Intensif, Modere);

type TExperience = (Economique, Ecologique, RespectDesTemperatures, RespectDesActivites);


type TActivite = record
        nom: String;
        categories: array of TPref;
        cout: Real;
        minutes: Integer;
        score: Real;
    end;
type TActivites = array of TActivite;

type TPays = record
        nom: String;
        capitale: String;
        activites: array of TActivite;
        ordreAct: array of Integer;
        nomFrontieres: TStringArray;
        nomAvions: TStringArray;
        climat: array[TMois] of Integer;
        score: Real;
        longitude: Real;
        latitude: Real;
    end;

type TEurope = array of TPays;

type TCriteres = record
        paysDepart: TPays;
        paysArrivee: TPays;
        categories: array of TPref;
        duree: LongInt;
        periode: TMois;
        climat: LongInt;
        budget: Real;
        modeTransport: TMode;
        coeffClimat: Real;
        coeffActivite: Real;
        coeffCout: Real;
        intervalleTemperature: Real;
        nbVoyageurs: LongInt;
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
        transport: TTransport;
        distance: Real;
        cout: Real;
        minutes: Integer;
    end;

type TEtape = record
        estActivite: Boolean;
        activite: TActivite;
        deplacement: TDeplacement;
    end;
type TEtapes = array of TEtape;

type TJournee = record
        jour: Integer;
        etapes: TEtapes;
    end;
type TJournees = array of TJournee;

type TVoyage = record
        itineraire: array of TPays;
        etapes: TEtapes;
        planning: TJournees;
        coutTotal: Real;
        kmTrain: Real;
        kmAvion: Real;
        kmTotal: Real;
        erreur: Boolean;
        message: String;
        modeTransport: TMode;
        carbonImpact: Real;
    end;

type TItineraireResult = record
        itineraire: array of TPays;
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
type TArrayFilePays = array of TFilePays;

type TFileActivite = record
        nom: String;
        pays: String;
        categories: array of TPref;
        cout: Real;
        minutes: Integer;
    end;
type TArrayFileActivite = array of TFileActivite;

implementation
end.
