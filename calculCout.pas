{ Calcul des différents coûts (carbone, monétaire, durée) des déplacements effectués durant le voyage }
unit calculCout;

interface
uses constantes, math, voyageTypes;

function calculDureeTransport(distance: Real; transport: TTransport): Integer;
function calculCoutTransport(deplacement: TDeplacement): Real;
function calculDuneDistance(lat1, lon1, lat2, lon2: Real): Real;
procedure calculDistanceTotal(var voyage: TVoyage);
procedure coutTotal(var voyage: TVoyage; criteres : TCriteres);
procedure calculDistanceTransports(var voyage: TVoyage);
procedure coutCarbone(var voyage: TVoyage);

implementation

{ Fonction permettant de calculer la distance séparant deux points de latitude et longitude connues. Source : https://stackoverflow.com/a/21623206/14141878
    @param(lat1 Latitude du premier point)
    @param(lon1 Longitude du premier point)
    @param(lat2 Latitude du second point)
    @param(lon2 Longitude du second point)
    @return(Distance en kilomètres entre les deux points)
}
function calculDuneDistance(lat1, lon1, lat2, lon2: Real): Real;
const RAYON_TERRE = 6371; // en kilomètres
    p = (Pi / 180);
var a: Real;
begin
    a := (1 / 2) - ((Cos((lat2 - lat1) * p)) / 2) + Cos(lat1 * p) * Cos(lat2 * p) * ((1 - Cos((lon2 - lon1) * p)) / 2);
    calculDuneDistance := 2 * RAYON_TERRE * ArcSin(Sqrt(a));
end;

{ Cette procédure calcule la distance totale parcourue durant le voyage proposé à l'utilisateur
    @param(voyage Voyage généré par le programme)
}

procedure calculDistanceTotal(var voyage: TVoyage);
var i: Integer;
    j, distance: Real;
begin
    distance := 0;

    // On s'arrête à l'avant-dernier point pour ne pas dépasser le tableau (i + 1)
    for i := 0 to length(voyage.itineraire) - 2 do
    begin
        j := calculDuneDistance(
            voyage.itineraire[i].latitude,
            voyage.itineraire[i].longitude,
            voyage.itineraire[i + 1].latitude,
            voyage.itineraire[i + 1].longitude);
        // DEBUG : writeln(j)
        distance := distance + j;
    end;
    voyage.kmTotal := distance;
end;

{ Procédure calculant le coût total du voyage, en prenant en compte le coût des transports et le coût des activités. 
    @param(voyage Voyage généré par le programme)
    @param(criteres Critères de recherche du voyage)
}
procedure coutTotal(var voyage: TVoyage; criteres : TCriteres);
var i: Integer;
    cout, coutEtape: Real;
begin
    cout := 0;
    for i := 0 to length(voyage.etapes) - 1 do
    begin
        if voyage.etapes[i].estActivite then
            coutEtape := voyage.etapes[i].activite.cout
        else
            coutEtape := calculCoutTransport(voyage.etapes[i].deplacement);
        cout := cout + coutEtape;
    end;

    // Prise en compte de l'hébergement dans le cas économique ou non
    if criteres.coeffCout = COEFF_COUT_FINAL then
        cout:= cout + length(voyage.planning)*HOTEL_BUDGET
    else
        cout:= cout + length(voyage.planning)*HOTEL_NORMAL;

    voyage.coutTotal := cout*criteres.nbVoyageurs;
end;

{ Cette fonction calcule le coût total des déplacements effectués durant le voyage, selon les transports utilsées (train, ou bien train et avion).
Les détails des coefficients utilisés pour le calcul du coût sont disponibles en commentaire.
    @param(deplacement Déplacement effectué)
    @return(Coût du déplacement)
}
function calculCoutTransport(deplacement: TDeplacement): Real;
begin
    if deplacement.transport = Train then
        // Sachant que pour 100 km : 40€ et pour 900 km : 120€ alors on résout l'équation a * 100**b = 40 et a * 900**b = 120
        // On trouve a = 4 et b = 0.5
        calculCoutTransport := 4 * power(deplacement.distance, 0.5)
    else
        // Sachant que pour 800 km : 90€ et pour 9500 km : 800€ alors on résout l'équation a * 800**b = 90 et a * 9500**b = 800
        // On trouve a = 0.24 et b = 0.88
        calculCoutTransport := 0.24 * power(deplacement.distance, 0.88);
    deplacement.cout := calculCoutTransport;
end;

{ Cette fonction calcule la durée d'un déplacement. Cette dernière sera alors utilisée dans le terminal avec son déplacement associé. 
    @param(distance Distance du déplacement)
    @param(transport Moyen de transport utilisé)
    @return(Durée du déplacement)
}
function calculDureeTransport(distance: Real; transport: TTransport): Integer;
var vitesse: Integer;
begin
    if transport = Train then
    begin
        // Vitesse moyenne d'un train : 120 km/h
        // Vitesse moyenne d'un train à grande vitesse : 250 km/h
        if distance < 200 then
            vitesse := 120
        else
            vitesse := 250;
        calculDureeTransport := round((distance / vitesse) * 60);
    end
    else
        // Vitesse moyenne d'un avion : 800 km/h
        calculDureeTransport := round((distance / 800) * 60);
end;

{ Procédure permettant de calculer à la fois la dicstanec parcourue en train et la distance
parcourue en avion au cours du voyage, utile pour le calcul du coût carbone du voyage.
    @param(voyage Voyage généré par le programme)
}
procedure calculDistanceTransports(var voyage: TVoyage);
var i: Integer; distanceTrain, distanceAvion: Real;
begin
    distanceTrain := 0;
    distanceAvion := 0;

    for i := 0 to length(voyage.etapes) - 1 do
        if voyage.etapes[i].deplacement.transport = Train then
            distanceTrain := distanceTrain + voyage.etapes[i].deplacement.distance
        else
            distanceAvion := distanceAvion + voyage.etapes[i].deplacement.distance;

    voyage.kmTrain := distanceTrain;
    voyage.kmAvion := distanceAvion;
end;

{ Cette procédure calcul le coût carbone du voyage (kg de CO2 émis). Celui-ci sera affiché dans le terminal en fin de programme. 
    @param(voyage Voyage généré par le programme)
}
procedure coutCarbone(var voyage: TVoyage);
begin
    calculDistanceTransports(voyage);
    voyage.carbonImpact := EMISSION_CO2_AVION * voyage.kmAvion + EMISSION_CO2_TRAIN * voyage.kmTrain;
end;
end.
