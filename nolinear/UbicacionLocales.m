%Script para verificar la ubicación de los locales

% CC
a = [17.95,17.16,18.58,11.12,9.51]; 
b = [19.73, 9.35, 13.2, 7.79,1.04];
% Proveedores
u = [ 4.56,13.06,18.42];
v = [10.71,11.04,19.32];

x = a;
y = b;

x0 = u;
y0 = v;

%Se gráfica encima de la imagen de referencia
temp = imread('BogMilk_Notext.png');
image(temp);
hold on
string = {1,2,3,4,5};
%Se gráfican los proveedores
x0 = x0/0.02732834187248; % factor de escala usado para llevar a km en comparación a la imagen
y0 = y0/0.02732834187248;
y0 = 896 - y0; %Invertir el eje y
scatter(x0,y0,65,'red','filled');

%Poner label a cada punto
a = [1:3]'; b = num2str(a); c = cellstr(b);
dx = 0; dy = 20; 
text(x0+dx, y0+dy, c);

%Se grafican los CC
x = x/0.02732834187248; % factor de escala usado para llevar a km en comparación a la imagen
y = y/0.02732834187248;
y = 896 - y; %Invertir el eje y
scatter(x,y,65,'blue','filled');

a = [1:5]'; b = num2str(a); c = cellstr(b);
dx = 0; dy = 20; 
text(x+dx, y+dy, c);


% Requires R2020a or later
set(gca,'visible','off') %Quitar los ejes 
set(gca,'xtick',[]) %Quitar los ticks de los ejes
set(gca,'LooseInset',get(gca,'TightInset')); %Quitar el borde blanco

%Extender para obtener mejor vista

hold off
