function [C] = CalcularCostos()
%Calcula la matriz de costos del problema lineal, basandosé en los datos y
%posiciones del problema no lineal

%Ubicaciones 
%CC
%    C1     C2     C3    C4   C5
a = [17.95,17.16,18.58,11.12,9.51]; 
b = [19.73, 9.35, 13.2, 7.79,1.04];
% Proveedores
%      P1   P2    P3
u = [ 4.56,13.06,18.42];
v = [10.71,11.04,19.32];


%Calcular la matriz de costos de enviar de proveedores a centros
%comerciales directamente
C_CC = zeros([5 3]);
for i=1:3 %Proveedores
    for j=1:5 %CC
       C_CC(j,i) = sqrt((u(i)-a(j))^2 + (v(i)-b(j))^2); 
    end
end

%Ubicación de las bodegas, como solución óptima obtenida del problema
%nolineal
X = [12.6437,14.0070,...
    16.0399 ,15.4356,...
    15.4675 ,13.0823,...
    14.3909 ,11.3622,...
    10.5419 ,10.8801];

x = X(1:2:10);
y = X(2:2:10);

%Calcular la matriz de costos de enviar de proveedores a bodegas propia de
%la empresa
C_bodegas = zeros([5 3]);
for i=1:3 %Proveedores
    for j=1:5 %Almacenamientos
       C_bodegas(j,i) = sqrt((u(i)-x(j))^2 + (v(i)-y(j))^2); 
    end
end

C = [C_CC; C_bodegas];
