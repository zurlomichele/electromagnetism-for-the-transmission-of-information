# Project of "Electromagnetism for the transmission of information"



## INTRO
Obiettivo del nostro progetto intra - corso è stato la realizzazione di un programma MATLAB che simuli la propagazione della tensione e della corrente lungo una linea di trasmissione nel dominio del tempo applicando la tecnica FDTD. 

## Metodo FDTD

Il metodo FDTD (finite-difference time-domain) è una tecnica proposta da Kane Yee nel 1966 per la risoluzione numerica delle equazioni di Maxwell per i campi elettromagnetici. 
L’algoritmo di Yee è basato sull’approssimazione alle differenze finite delle derivate nello spazio e nel tempo. 
La discretizzazione spaziale prevede il posizionamento dei campi, elettrici e magnetici (E ed H), attraverso una griglia che permette facilmente il calcolo delle derivate tramite differenze finite. In particolare i campi elettrici vengono posti lungo gli spigoli delle celle aventi dimensione (∆x,∆y,∆z), mentre i campi magnetici vengono posizionati al centro della superficie sottesa alla singola cella risultando così sfasati di mezza cella.
Allo stesso modo per quanto riguarda la discretizzazione temporale, lo sfalsamento    dei campi deve essere mantenuto anche nel tempo per cui E ed H devono essere valutati a tempi diversi di una quantità pari a mezzo passo di campionamento ∆t.   
![figura 1](readme_image/fig_1.png)

L’implementazione dell’algoritmo per quanto facile e concettualmente semplice presenta dei problemi di dispersione numerica, stabilità ed errori. Questi problemi sono superabili rispettando opportune condizioni:
〖∆x〗_max,〖∆y〗_max,〖∆z〗_max  ≤ 1/20 λ_min    λ_min= vc/f_(max √(μ_rmax ε_rmax )) 
e l’altra condizione impone che l’incremento temporale ∆t adottato si mantenga entro un limite definito in funzione degli incrementi spaziali ∆x,∆y,∆z della griglia:
 

La tecnica FDTD può essere applicata ad un’ampia varietà di problemi complessi: radiazione di antenne in ambienti complessi, modellizzazione di circuiti a microonde, problemi di compatibilità elettromagnetica ecc. 
Il nostro progetto consiste nell’applicare la tecnica FDTD alle equazioni dei Telegrafisti:
 
Figura 2 equazioni dei telegrafisti
per studiare la propagazione della tensione e della corrente lungo una linea di trasmissione nel dominio del tempo.

La nostra linea di trasmissione è un cavo coassiale lungo 3m avente raggio interno a = 2.8mm, raggio esterno b = 10mm, il cui dielettrico interno ha una ε_r=2.3.
Sono stati considerati 2 tipi di segnale:

	segnale gaussiano di larghezza sigma=300ps (frequenza massima   circa 1.3GHz), ritardato di t0;
	segnale sinusoidale di frequenza 1.4 GHz.
I comportamenti della tensione e della corrente sono stati analizzati in tre diversi punti della linea (all’inizio, a metà e sul carico), andando a considerare quattro tipologie di carico:
	Resistenza adattata 
	Resistenza disadattata
	Carico induttivo
	Carico capacitivo 
	Implementazione e grafici
Entriamo ora nello specifico con una descrizione accurata dei metodi adottati e delle scelte implementative effettuate.

L’implementazione dell’algoritmo è stata fatta suddividendo il cavo in celle infinitesime di dimensione dz =(c/sqrt(epsilonr))/1.4*10^9, dove ogni cella conteneva un voltaggio e una corrente e discretizzando il tempo di analisi in funzione dei passi dz: 
dt = dz/c; 
Vettoretempo = (0:dt:tmax);
(con “c” velocità della luce e “tmax” tempo di animazione).

Le equazioni utilizzate per il seguente problema sono state :

                     

                   
che sono state implementate nel calcolatore nel seguente modo:
V(i) = V(i) + coeffC * (I(i) - I(i-1));
I(i) = I(i) + coeffL * (V(i+1) - V(i));
e inserite all’interno di due cicli for separati per rendere il processo più chiaro e semplice, dove la tensione della cella i-esima è in funzione della corrente della cella medesima e della corrente situata nella cella precedente. Allo stesso modo il calcolo della corrente.
Abbiamo valutato il comportamento della tensione e della corrente in base al segnale e ai quattro tipi di carico richiesti applicando ad ogni carico le opportune condizioni al contorno.

Da alcune analisi effettuate, vengono riportati alcuni grafici della tensione e della corrente in tre diversi punti della linea (inizio, metà e sul carico) al variare del tempo.
