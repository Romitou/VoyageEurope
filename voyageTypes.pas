{ Unité contenant les types de données utilisés dans le projet }
unit voyageTypes;

interface
uses sysutils;

// Mode de transport (train seul ou train et avion)
type TMode = (TrainSeul, TrainEtAvion);

// Type de transport (train ou avion)
type TTransport = (Train, Avion);

// Mois de l'année
type TMois = (Janvier, Fevrier, Mars, Avril, Mai, Juin, Juillet, Aout, Septembre, Octobre, Novembre, Decembre);

// Préférences de l'utilisateur pour les activités
type TPref = (
    // Type d'activité
    Aventure, Culture, Gastronomie, Nature, Relaxation, VieNocturne, Shopping, Art, Education, Architecture,
    BienEtre, Sport, Aquatique, FestivalsEtEvenements, Histoire, ArtisanatLocal, Photographie, ObservationFaune,
    Mystere, CinemaEtTelevision, ReligieuxEtSpirituel, Authentique, Immersif,
    
    // Occasion
    Romantique, Famille, EntreAmis, Solo,

    // Type de séjour
    Luxe,

    // Qualification de l'activité
    Guide, Actif, Intensif, Modere);

// Expérience de voyage (économique, écologique, respect des températures, respect des activités)
type TExperience = (Economique, Ecologique, RespectDesTemperatures, RespectDesActivites);

// Activité touristique
type TActivite = record
        nom: String;
        categories: array of TPref;
        cout: Real;
        minutes: Integer;
        score: Real;
    end;

// Liste d'activités
type TActivites = array of TActivite;

// Pays européen
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

// Liste de pays européens
type TEurope = array of TPays;

// Critères de recherche du voyage
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

// Type de menu
type TMenu = record
        nom: String;
        preferences: array of TPref;
        description: String;
    end;

// Liste de menus
type TMenus = array of TMenu;

// Déplacement entre deux pays
type TDeplacement = record
        paysDepart: TPays;
        paysEtape: TPays;
        transport: TTransport;
        distance: Real;
        cout: Real;
        minutes: Integer;
    end;

// Étape du voyage
type TEtape = record
        estActivite: Boolean;
        activite: TActivite;
        deplacement: TDeplacement;
    end;

// Liste d'étapes
type TEtapes = array of TEtape;

// Journée du voyage
type TJournee = record
        jour: Integer;
        etapes: TEtapes;
    end;

// Liste de journées
type TJournees = array of TJournee;

// Voyage généré par le programme
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

// Résultat de la recherche d'itinéraire avec Dijsktra
type TItineraireResult = record
        itineraire: array of TPays;
        erreur: Boolean;
        message: String;
    end;

// Représentation d'un pays dans un fichier
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

// Liste de pays dans un fichier
type TArrayFilePays = array of TFilePays;

// Représentation d'une activité dans un fichier
type TFileActivite = record
        nom: String;
        pays: String;
        categories: array of TPref;
        cout: Real;
        minutes: Integer;
    end;

// Liste d'activités dans un fichier
type TArrayFileActivite = array of TFileActivite;

implementation
end.
