%PROGETTO DI ELETTROMAGNETISMO PER LA TRASMISSIONE DELL'INFORMAZIONE%
%%%%%%%%%%%%%%% GRUPPO 1: SILLA LUCIA - ZURLO MICHELE %%%%%%%%%%%%%%%

%{
Realizzare un programma (con Matlab o qualsiasi altro linguaggio di programmazione) che simuli la propagazione 
della tensione e della corrente lungo una linea di trasmissione nel dominio del tempo applicando la tecnica FDTD.
Se possibile creare una animazione dell'andamento della tensione e della corrente lungo la linea.%

Considerare un cavo coassiale con le seguenti caratteristiche:
lunghezza: 3m; 
raggio interno a = 2.8mm;
raggio esterno b = 10mm; 
epsr dielettrico interno = 2.3.

Preparare una relazione in cui viene descritto il metodo e le scelte implementative.
Riportare i grafici della tensione e della corrente in tre diversi punti della linea (inizio, metà e sul carico)
al variare del tempo.

La relazione e il file sorgente realizzato dovranno essere consegnati nella piattaforma Moodle.

Considerare due tipologie di segnali con un generatore la cui resistenza interna è adattata alla linea:

1) Segnale gaussiano di larghezza sigma = 300ps (frequenza massima circa 1.3GHz), ritardato di t0. 
Il valore dovrà essere scelto in modo tale che il segnale lungo la linea non risulti distorto.
2) Segnale sinusoidale di frequenza: 1.4 GHz

 Considerare quattro tipologie di carichi:

1)      Resistenza adattata
2)      Resistenza disadattata
3)      Carico capacitivo
4)      Carico induttivo
%}

%%% constant and physical characteristics of the coaxial cable (in meters) %%%

eps_R = 2.3; % relative dielectric constant
eps_ZERO = 8.454*10^-12; % dielectric constant in vacuum
eps = eps_R * eps_ZERO; % dielectric constant
mu_ZERO = 4 * pi * 10^-7; % magnetic permeability in vacuum
c = (sqrt(eps_ZERO * mu_ZERO))^-1; % light speed
vf = c / sqrt(eps_R); % phase velocity
sigma = 300 * 10^-12; % gaussian signal width
frequency_factor = 1; %gaussian frequency factor

a = 2.8*10^-3; % inner radius
b = 10*10^-3; % outer radius
l = 3; % length of the coaxial cable
C = (2 * pi * eps * l) / (log(b/a)); % capacity
Z0 = (60 / (sqrt(eps_R))) * log(b / a); % characteristic impedance of the line
L = Z0^2 * C; % inductance
Zg = Z0; % generator impedance


%%% section for selecting the type of signal %%%
prompt = '1 = sinusoidal signal;  2 = gaussian signal. Please select the type of signal: ';
inp1 = input(prompt,'s');

if strcmp(inp1,'1')
   
    x = 1;
    
elseif strcmp(inp1,'2') 
    
    x=2;
end


%%% section for selecting the type of load %%%
prompt = '1 = adapted resistance; 2 = unmatched resistance; 3 = capacitive load; 4 = inductive load. Please select the type of load: ';
inp2 = input(prompt,'s');

if strcmp(inp2,'1')
     y = 1;     
    
elseif strcmp(inp2,'2')
        
     y = 2;
        

elseif strcmp(inp2,'3')
        
     y = 3;
        
elseif strcmp(inp2,'4')
    
     y = 4;
        
end

while 1
    
    if (x == 1)
        
        
        f = 1.4*10^9; % f_max of the sine wave generator
        omega = 2 * pi * f; % pulsation of the sinusoidal signal
                
    else 
        
        f = 1.3*10^9 * frequency_factor; % f_max of the gaussian generator
        step = 150; % time spacing between two gaussians
                
    end
      
    lamb_min = vf / f; % minimum wavelength
    
    %%% spatial and temporal discretization of the domain %%%

    dz = lamb_min / 21; % spatial discretization step
    SA = (0:dz:l); % spatial array
    number_of_sstep = length(SA); % number of spatial steps

    max_time = 0.0000001; % animation duration
    dt = dz / c; % time discretization step
    TA = (0:dt:max_time); % time array
    number_of_tstep = length(TA); % number of time steps

    %%% initialization %%%

    I = zeros(1, number_of_sstep); % initialization of the current along the line
    V = zeros(1, number_of_sstep); % iinitialization of the voltage along the line
    t0 = 0; % initialization of t0
    
   
    coefficient_L = -dt/(L*dz);
    coefficient_C = -dt/(C*dz);

    
        for k = 1:number_of_tstep
        if (x == 1)
       
            V(1) = sin(omega*TA(k)); % sinusoidal signal
            
        elseif (x == 2)

            if mod(k,step) == 0
                t0 = step + t0;
            end
            
            V(1) = (1/ (0.1 * sqrt(2 * pi))) * exp(-(1/2)*((TA(k) - (t0 + 50)*dt)/sigma)^2); % gaussian signal

        end

        I(1) = V(1) / Zg; % current on the generator
        
        

        for i=2:number_of_sstep-1 % updates the voltage V
          V(i) =  V(i) + coefficient_C * (I(i) - I(i-1));
          
          
        end


        for i=2:number_of_sstep-1 % updates the current I
           I(i) = I(i) + coefficient_L * (V(i+1) - V(i));
           
          
        end
        
        I(number_of_sstep) = I(number_of_sstep-1); % boundary conditions for the wave propagating to the right

        if (y == 1)
            R = Z0; % resistance on the adapted resistive load
            V(number_of_sstep) = R * I(number_of_sstep); % voltage on the adapted resistive load
        elseif (y == 2)
            R = 10; % resistance unmatched resistive load
            V(number_of_sstep) = R*I(number_of_sstep); % voltage on the unmatched resistive load
        elseif (y == 3)
           L_load = 1*10^(-6); % inductance of the inductive load
           V(number_of_sstep) = (L_load/dt) * (I(number_of_sstep) - I(number_of_sstep-1)); % voltage on the inductive load
        elseif (y == 4)
           C_load = 3 * 10^(-3); % capacitive load capacity
           temp = dz / C_load; % multiplicative coefficient
           V(number_of_sstep) = V(number_of_sstep) + temp * I(number_of_sstep); % voltage on the capacitive load
        end
        
    %%% section for graphics and animation management %%%
        hold off
        plot(SA, V,'-b')
        hold on
        plot(SA, I,'-m')
        legend('Voltage (V)','Current ( I )')
        grid on
        xlabel(k)
        ylim([-6.0 6.0])
        if mod(k, 100) == 0 % animation speed
        drawnow
        end

      

    end
    
  
end


% SILLA LUCIA - ZURLO MICHELE %