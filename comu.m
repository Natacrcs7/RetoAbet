c=[0 0.7 0.4+0.55i -0.4+0.55i -0.7 -0.4-0.55i ...
    0.4-0.55i 1.4 1.05+0.55i 0.7+1.2i 1.2i ...
    -0.7+1.2i -1.05+0.55i -1.4 -1.05-0.55i ...
    -0.7-1.2i -1.2i 0.7-1.2i 1.05-0.55i]; 

a= [0.4+0.2i -0.4+0.2i -0.4i 1.05+0.2i 0.7+0.8i 0.8i ...
    -0.7+0.8i -1.05+0.2i -0.7-0.4i -0.4-1i 0.4-1i 0.7-0.4i];

% Parámetros
M = length(c);
M1 = length(a);
M2 = 4;
nss = 2000;
samples_per_symbol = 10;  
SNR = 15;
Rb = 1e9; 
L = 20e3; D = 17e-12;
lambda = 1550e-9; 
band=0.1e-9;

% Generar datos aleatorios
data = randi([0 M-1], nss, 1);
data1 = randi([0 M1-1], nss, 1);
dpsk = randi([0 M2-1], nss, 1);

% Modulación de señales
modData = genqammod(data, c);
modData1 = genqammod(data1, a);
modDPSK = dpskmod(dpsk, M2, 0);

% Agregar ruido a cada señal por separado
rx = awgn(modData, SNR, 'measured');
rx1 = awgn(modData1, SNR, 'measured');
rxDPSK = awgn(modDPSK, SNR, 'measured');

eyediagram(real(modData), samples_per_symbol);
title('Diagrama de Ojo señal HQAM-19');
eyediagram(real(modData1), samples_per_symbol);
title('Diagrama de Ojo señal HQAM-12');
eyediagram(real(modDPSK), samples_per_symbol);
title('Diagrama de Ojo señal DPSK');
%Generar el Diagrama de Ojo 
eyediagram(real(rx), samples_per_symbol);
title('Diagrama de Ojo señal HQAM-19 con ruido');
eyediagram(real(rx1), samples_per_symbol);
title('Diagrama de Ojo señal HQAM-12 con ruido');
eyediagram(real(rxDPSK), samples_per_symbol);
title('Diagrama de Ojo señal DPSK con ruido');
xlabel('Tiempo');
ylabel('Amplitud');
grid on;

% Obtener fases para la constelación 3D
fasea = angle(rxDPSK);
fasea(fasea < -1) = fasea(fasea < -1) + 2*pi;

I = []; Q = []; Phase = [];
I1 = []; Q1 = []; Phase1 = [];

for p=fasea
    I = [I; real(rx(:))]; 
    Q = [Q; imag(rx(:))]; 
    Phase = [Phase; p(:)];  
    I1 = [I1; real(modData(:))]; 
    Q1 = [Q1; imag(modData(:))]; 
    Phase1 = [Phase1; p(:)]; 
end

% Para los 12 símbolos en fases 2.9 y 1.05
for p = fasea
    I = [I; real(rx1(:))];  
    Q = [Q; imag(rx1(:))]; 
    Phase = [Phase; p(:)]; 
    I1 = [I1; real(modData1(:))]; 
    Q1 = [Q1; imag(modData1(:))];  
    Phase1 = [Phase1;p(:)]; 
end

% Visualización en 3D
figure;
scatter3(I, Q, Phase, 10 , 'b', 'filled');
hold on
scatter3(I1, Q1, Phase1,'r', '*', 'LineWidth', 1.5);
title('Constelación 3D HQAM-DPSK con Ruido AWGN');
xlabel('Intensidad I (Parte Real)');
ylabel('Intensidad Q (Parte Imaginaria)');
zlabel('Fase (radianes)');
grid on;

% Visualización 2D
figure;
scatter(real(rx), imag(rx), 10 , 'b', 'filled');  % Conjunto de datos con ruido, fase 19
hold on;
scatter(real(rx1), imag(rx1), 10, 'b', 'filled');  % Conjunto de datos con ruido, fase 12
% Agregar los puntos de la constelación ideal en rojo, con mayor tamaño y grosor
scatter(real(modData), imag(modData), 10, 'r', '*', 'LineWidth', 1.5);  % Constelación ideal de 19 símbolos
scatter(real(modData1), imag(modData1), 10, 'r', '*', 'LineWidth', 1.5);  % Constelación ideal de 12 símbolos
% Configuración de la gráfica
title('Constelación 2D HQAM');
xlabel('Intensidad I (Parte Real)');
ylabel('Intensidad Q (Parte Imaginaria)');
grid on;








