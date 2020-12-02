%Se obtiene la matriz de costos
C = CalcularCostos();
% El vector de demanda D
% Santafe - Andino - Unicentro - Salitre PLaza - Centro Mayor
D = [1040,814,1269,620,943];

%El vector de oferta
B = [2500,900,1700];

Capacidad_Almacenamiento = 100; %La capacidad de cada almacen

fprintf('Excedente: %d \n', sum(B) - sum(D)); %Excedente a enviar a bodegas

%Se organizan las variables de la siguiente forma:
%x11,x12,x13,x14,x15,x16,x17,x18,x19,x1_10,x21,x22,... Para un total de 30,
% De esta manera, se crea el vector c de costos
c = reshape(C,1,30);
% Extendemos nuestro b a partir de la oferta y la demanda
b = [B'; D'];

%Regla 1
%x11,x12,x13,x14,x15,x16,x17,x18,x19,x1_10 <= b_1 ...
% 3 restricciones, 30 variables
R1 = zeros([3 30]);

%La variable xij se le asigna la posición
% (i-1)*5+j en la matriz, (dado se "lineariza", en vez de estar en una matriz)
for i=1:3
    for j=1:10
        R1(i,(i-1)*10+j) = 1;
    end
end

%Regla 2
%x11 + x21 + x31 = d_1
% 5 restricciones, 15 variables
R2 = zeros([5 30]);
for j=1:5
    for i=1:3
        R2(j,(i-1)*10+j) = 1;
    end
end

%Capacidad máxima de almacenamiento de cada bodega
%x16 + x26 + x36 <= 100...
R3 = zeros([5 30]);
for j=1:5
    for i=1:3
        R3(j,(i-1)*10+(j)+5) = 1;
    end
end

%De aquí tenemos que añadir 5 variables de holguras, para obtener
%restricciones de igualdad
c = [c zeros([1 5])]; %extendemos c con zeros, las de holgura
R3 = [R3 eye(5)];
%De esta manera, obtenemos nuestra matriz A de restricciones
%Uniendo la regla 1 y regla 2 y regla 3
A = [R1;R2];
%extendemos A con zeros correspondiente a las variables de holguras
A = [A zeros([8 5])];
A = [A;R3]; % Ya podemos extender A con la regla 3, incluyendo las variables de holguras


%Extendemos b con la restriccion de capacidad de cada almacenamiento
b = [b ;(zeros([5 1]) + Capacidad_Almacenamiento)];

%Tenemos que Ax = b, formato estandar
xmin = Simplex(A,b,c,0,0);
%xmin = linprog(c,[],[],A,b,zeros([1 35]),inf([1 35]));


xmin = xmin(1:30); %Quitamos las variables de holgura
xmin = reshape(xmin,10,3); %Expresamos de forma matricial

xmin


