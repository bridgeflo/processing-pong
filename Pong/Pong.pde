// Pong, mit der Maus zu spielen

// Konstanten (Variablen, deren Werte waehrend der Programmlaufzeit nicht veraendert werden,
// zur Kennzeichnung tragen diese Namen aus Grossbuchstaben):
float MIN = 4;       // Mindestgeschwindigkeit des Balls bei Beginn
float MAX = 6;       // Hoechstgeschwindigkeit des Balls bei Beginn
float BALLG = 10;    // Balldurchmesser in Pixel
float SCHLAGL = 40;  // Laenge des Schlaegers
// Unsauberkeit der Ballrichtung beim Abprallen:
// PI/36 entpricht +/-5 Grad Abweichung
float ABW = PI / 36;

// globale Variablen (stehen allen Funktionen zur Verfuegung):

// Position und Geschwindigkeit des Balls:
float ballx;  // Ballposition x
float bally;  // Ballposition y
float balldx; // Ballversatz horizontal
float balldy; // Ballversatz vertikal
float richt;  // Richtung des Balls im Bogenmass, Werte zwischen PI und -PI
float tempo;  // Geschwindigkeit in Pixel pro Frame

// Position des Schlaegers:
float schlagy;
float schlagx;

// Toleranz des Schlaegers, um ein "Durchtunneln" des Balls
// bei hoeheren Geschwindigkeiten zu verhindern:
float tol;

// Punktezaehler
int score = 0;

// Laeuft gerade ein Spiel?
boolean spielLaeuft;

// Schriftart
PFont schrift;

void setup() {
  // der Ball soll auch auf schnellen Rechnern noch zu kriegen sein
  frameRate(25);
  size(480, 320);
  // Position des Schlaegers:
  schlagx = width - 30;
  schlagy = height / 2;
  // die Positionsangaben für Formen sollen sich auf die Zentren beziehen
  ellipseMode(CENTER);
  rectMode(CENTER);
  // Schrift laden
  schrift = loadFont("Tahoma-20.vlw");
  spielLaeuft = false;
  smooth();
}

void draw (){
  // Hintergrund schwaerzen
  background(0);
  // Mauszeiger verstecken
  noCursor();
  // die Maus steuert den Schlaeger
  schlagy = mouseY;
  // Schlaeger in weiss zeichnen
  fill(255);
  rect(schlagx, schlagy, 10, SCHLAGL);
  // Score links oben ins Feld schreiben
  fill (255);
  textFont(schrift);
  text("Score: " + score, 10, 24);

  // Ist ein neues Spiel gewuenscht?
  if(keyPressed) {
    if (key == 'n' || key == 'N') {
      newGame();
    }
  }

  // falls das Spiel gerade laeuft:
  if (spielLaeuft){
    // Ball bewegen
    balldx = cos(richt) * tempo;
    balldy = sin(richt) * tempo;
    ballx = ballx + balldx;
    bally = bally - balldy;
    // Toleranz an die aktuelle Geschwindigkeit anpassen:
    tol = ceil(max(tol, balldx));

    // Bei Kollision mit der Wand links...
    if (ballx - BALLG / 2 <= 0 && (richt > PI / 2 || richt < -PI / 2)){
      // ... die Richtung umdrehen, indem man die alte von PI abzieht
      // und vor das Ganze das Vorzeichen von 'richt' schreibt, was
      // die Multiplikation mit (richt/abs(richt)) besorgt.
      richt = (richt / abs(richt)) * PI - richt;
    }

    // Bei Kollision mit der Wand unten und oben...
    if ((bally + BALLG / 2 >= height && richt < 0)
      || (bally - BALLG / 2 <= 0 && richt > 0)){
      // ... die Richtung per Vorzeichenwechsel umdrehen und,
      // damit es spannend bleibt, ein bisschen an der Richtung drehen.
      richt = -richt + random(-ABW, ABW);
    }

    // Abfrage der Kollision mit dem Schlaeger:
    // Der rechte Rand des Balls liegt auf der linken Schlaegerkante oder rechts davon
    // und gleichzeitig noch innerhalb des Toleranzbereichs
    // und ausserdem befindet sich der Ball zwischen dem oberen und dem unteren Rand des Schlaegers
    // und er bewegt sich nach rechts...
    if (ballx + BALLG / 2 >= schlagx - 5
        && ballx + BALLG / 2 < schlagx - 5 + tol
        && bally > schlagy - SCHLAGL / 2
        && bally < schlagy + SCHLAGL / 2
        && (richt < PI / 2 && richt > -PI / 2) ){
      // ... dann dreht sich die Richtung, indem man die alte von PI abzieht
      // und vor das Ganze das Vorzeichen von 'richt' schreibt, was
      // die Multiplikation mit (richt/abs(richt)) besorgt
      richt = (richt / abs(richt)) * PI - richt + random(-ABW, ABW);
      // damit es spannend bleibt, wird wieder ein bisschen an der Richtung gedreht
      // und es gibt Punkte
      score++;
      // und der Ball wird schneller.
      tempo = tempo * 1.1;
    }
    else if (ballx > width){
      // wenn der Spieler den Ball nicht kriegt, stoppt das Spiel
      spielLaeuft = false;
    }

    // Ball zeichnen
    ellipse(ballx, bally, BALLG, BALLG);

  } // Ende der Anweisungen, falls das Spiel laeuft
  else {
    // ansonsten wird Schrift eingeblendet
    fill (255);
    textFont(schrift);
    text("Neues Spiel: Taste 'n' drücken", 10, height - 15);
  }
}

// startet ein neues Spiel: der Score ist null und es gibt einen neuen Einwurf
void newGame(){
  // Position und Geschwindigkeit des Balls
  ballx = BALLG;
  bally = random(0,height);
  tempo = random(MIN, MAX);
  richt = random(-PI / 4, PI / 4);
  score = 0;
  tol = tempo;
  spielLaeuft = true;
}
