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

function calculDuneDistance(lat1, lon1, lat2, lon2: Real): Real;
{Fonction permettant de calculer la distance séparant deux points de latitude et longitude connues.}
const r = 6371; //km
const p = (Pi / 180);
var a: Real;
begin
    a := (1 / 2) - ((Cos((lat2 - lat1) * p)) / 2) + Cos(lat1 * p) * Cos(lat2 * p) * ((1 - Cos((lon2 - lon1) * p)) / 2);
    calculDuneDistance := 2 * r * ArcSin(Sqrt(a));
end;

procedure calculDistanceTotal(var voyage: TVoyage);
{Cette procédure calcul la distance totale parcourue durant le voyage proposé à l'utilisateur.}
var i: Integer; j, distance: Real;
begin
    distance := 0;
    for i := 0 to length(voyage.itineraire) - 2 do
    begin
        j := calculDuneDistance(voyage.itineraire[i].latitude, voyage.itineraire[i].longitude, voyage.itineraire[i + 1].latitude, voyage.itineraire[i + 1].longitude);
        distance := distance + j;
    end;
    voyage.kmTotal := distance;
end;

procedure coutTotal(var voyage: TVoyage; criteres : TCriteres);
{Procédure calculant le coût total du voyage, en prenant en compte le coût des transports et le coût des activités.}
var i: Integer; cout, coutEtape: Real;
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
    //Prise en compte de l'hébergement dans le cas économique ou non
    if criteres.coeffCout = COEFF_COUT_FINAL then
        cout:= cout + length(voyage.planning)*HOTEL_BUDGET
    else
        cout:= cout + length(voyage.planning)*HOTEL_NORMAL;

    voyage.coutTotal := cout*criteres.nbVoyageurs;
end;

function calculCoutTransport(deplacement: TDeplacement): Real;
{Cette fonction calcule le coût total des trajets effectués durant le voyage, selon les transports utilsées (train, ou bien train et avion).}
begin
    if deplacement.transport = Train then
        calculCoutTransport := 3 * power(deplacement.distance, 0.5)
    else
        calculCoutTransport := 0.04 * power(deplacement.distance, 1.5);
    deplacement.cout := calculCoutTransport;
end;

function calculDureeTransport(distance: Real; transport: TTransport): Integer;
{Cette fonction calcul la durée d'un trajet. Cette dernière sera alors affichée dans le terminal avec son trajet associé.}
var vitesse: Integer;
begin
    if transport = Train then
    begin
        if distance < 200 then
            vitesse := 120
        else
            vitesse := 250;
        calculDureeTransport := round((distance / vitesse) * 60);
    end
    else
        calculDureeTransport := round((distance / 800) * 60);
end;

procedure calculDistanceTransports(var voyage: TVoyage);
{Procédure permettant de calculer à la fois la dicstanec parcourue en train et la distance
parcourue en avion au cours du voyage, utile pour le calcul du coût carbone}
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

procedure coutCarbone(var voyage: TVoyage);
{Cette procédure calcul le coût carbone du voyage (kg de CO2 émis). Celui-ci sera affiché dans le terminal en fin de programme.}
begin
    calculDistanceTransports(voyage);
    voyage.carbonImpact := emissionCO2Avion * voyage.kmAvion + emissionCO2Train * voyage.kmTrain;
end;
end.
