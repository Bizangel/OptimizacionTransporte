clear all

% Se cargan las ubicaciones 
% CC
a = [17.95,17.16,18.58,11.12,9.51]; 
b = [19.73, 9.35, 13.2, 7.79,1.04];
% Proveedores
u = [ 4.56,13.06,18.42];
v = [10.71,11.04,19.32];

%Se construye la función el objetivo, y el gradiente de xi e yi
help = [];
gradhelp_xi = [];
gradhelp_yi = [];

% Se genera la suma total de cada x_i (distancias de un x,y con respecto a todos los puntos)
for j=1:5
    f =@(x,y) (x-a(j))^2 + (y - b(j))^2;
    gradf_xi =@(x) 2*(x-a(j));
    gradf_yi =@(y) 2*(y-b(j));
    
    help = [help subs(f)];
    gradhelp_xi = [gradhelp_xi subs(gradf_xi)];
    gradhelp_yi = [gradhelp_yi subs(gradf_yi)];
end

for k=1:3
    f =@(x,y) (x-u(k))^2 + (y-v(k))^2;
    gradf_xi =@(x) 2*(x-u(k));
    gradf_yi =@(y) 2*(y-v(k));
    
    help = [help subs(f)];
    gradhelp_xi = [gradhelp_xi subs(gradf_xi)];
    gradhelp_yi = [gradhelp_yi subs(gradf_yi)];
end
%Pegar la suma de todo

f =@(x,y) 0;
grad_xi =@(x) 0;
grad_yi =@(y) 0;
for n=1:length(help)
    fun = matlabFunction(help(n));
    fun_grad_xi = matlabFunction(gradhelp_xi(n));
    fun_grad_yi = matlabFunction(gradhelp_yi(n));
    
    f =@(x,y) f(x,y) + fun(x,y);
    grad_xi =@(x) grad_xi(x) + fun_grad_xi(x);
    grad_yi =@(x) grad_xi(x) + fun_grad_xi(x);
end

%La función es la suma de las distancias de cada punto a todos los puntos
%(sin contar entre si mismo)
F =@(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5) f(x1,y1) + f(x2,y2) + f(x3,y3) + f(x4,y4) + f(x5,y5);

%Se genera el gradiente reemplazando con su respectivo punto
gradf = @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5) {
        grad_xi(x1);
        grad_yi(y1);
        grad_xi(x2);
        grad_yi(y2);
        grad_xi(x3);
        grad_yi(y3);
        grad_xi(x4);
        grad_yi(y4);
        grad_xi(x5);
        grad_yi(y5);};
   
m = 3.4205; s = -55.344;

% Las restricciones se introducen como restricciones de X <= 0

%Crear Restricciones de distancia 2km
distancia_min = 2;
res_distancia =@(xi,xj,yi,yj) -(xi-xj)^2-(yi-yj)^2 + distancia_min^2;

res = {@(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5) res_distancia(x1,x2,y1,y2) %P1 y P2
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)  res_distancia(x1,x3,y1,y3) %P1 y P3
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)  res_distancia(x1,x4,y1,y4) %P1 y P4
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)  res_distancia(x1,x5,y1,y5) %P1 y P5
       
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)  res_distancia(x2,x3,y2,y3) %P2 y P3
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)  res_distancia(x2,x4,y2,y4) %P2 y P4
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)  res_distancia(x2,x5,y2,y5) %P2 y P5
       
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)  res_distancia(x3,x4,y3,y4) %P3 y P4
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)  res_distancia(x3,x5,y3,y5) %P3 y P5
       
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)  res_distancia(x4,x5,y4,y5) %P4 y P5
       }';

%La restriccion de linea
res2 = {@(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5) m*x1 + s - y1
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5) m*x2 + s - y2
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5) m*x3 + s - y3
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5) m*x4 + s - y4
       @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5) m*x5 + s - y5}';

%Gradientes de restricciones
%Parciales de la restricción de distancia
pxi =@(xi,xj) -2*(xi-xj); %Parcial de x_i
pxj =@(xi,xj)  2*(xi-xj); %Parcial de x_j

pyi =@(yi,yj) -2*(yi-yj); %Parcial de y_i
pyj =@(yi,yj)  2*(yi-yj); %Parcial de y_j

%Debe seguir el mismo orden x1,y1,x2...
A = @(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5) { 
   pxi(x1),pyi(y1),pxj(x2),pyj(y2),0,0,0,0,0,0; %P1 Y P2
   pxi(x1),pyi(y1),0,0,pxj(x3),pyj(y3),0,0,0,0; %P1 Y P3
   pxi(x1),pyi(y1),0,0,0,0,pxj(x4),pyj(y4),0,0; %P1 Y P4
   pxi(x1),pyi(y1),0,0,0,0,0,0,pxj(x5),pyj(y5); %P1 Y P5
   
   0,0,pxi(x2),pyi(y2),pxj(x3),pyj(y3),0,0,0,0; %P2 Y P3
   0,0,pxi(x2),pyi(y2),0,0,pxj(x4),pyj(y4),0,0; %P2 Y P4
   0,0,pxi(x2),pyi(y2),0,0,0,0,pxj(x5),pyj(y5); %P2 Y P5
   
   0,0,0,0,pxi(x3),pyi(y3),pxj(x4),pyj(y4),0,0; %P3 Y P4
   0,0,0,0,pxi(x3),pyi(y3),0,0,pxj(x5),pyj(y5); %P3 Y P5
   
   0,0,0,0,0,0,pxi(x4),pyi(y4),pxj(x5),pyj(y5); %P4 Y P5
   
   %gradiente de Restricción de linea 
   m,-1,0, 0,0, 0,0, 0,0, 0;
    0, 0,m,-1,0, 0,0, 0,0, 0;
    0, 0,0, 0,m,-1,0, 0,0, 0;
    0, 0,0, 0,0, 0,m,-1,0, 0;
    0, 0,0, 0,0, 0,0, 0,m,-1;
    
 };

%Se comienza con un punto factible (se ve gráficamente al final)
%Vector fila
	   % X    % Y
X = [  11.1, 13.47,...
      19.05, 17.44,...
      17.71,  10.9,...
      15.19,  6.12,...
       6.18,  4.78];

% Si se corre con el minimo local obtenido, se obtiene el mismo punto
% X = [12.6437,14.0070,...
%     16.0399 ,15.4356,...
%     15.4675 ,13.0823,...
%     14.3909 ,11.3622,...
%     10.5419 ,10.8801];


x0 = num2cell(X);
%Verificación de factibilidad y de restricciones activas
for i=1:length(res)
    if res{i}(x0{:}) < 0
        fprintf('OK! \n');
    elseif abs(res{i}(x0{:})) < 0.1
        fprintf('CERCA A UNA RESTRICCIÓN E \n');
    else
        fprintf('NO OKAY \n')
        res{i}
        res{i}(x0{:})
    end
end

Activas = [];
step_search = 0.001; %Avance de busqueda en el alpha de método de gradiente de proyectado
e = 0.001; %Error a ser usado para varios calculos

res = [res res2]; %Unimos las dos restricciones

xmin = gradienteProyectado(F,gradf,res,A,x0,Activas, step_search, e); %Se calcula el mínimo
xmin
F(x0{:})
F(xmin{:})
%Se gráfica encima de la imagen de referencia
y = imread('BogMilk_Notext.png');
image(y);
hold on
string = {1,2,3,4,5};
%Se gráfica el punto factible inicial
x0_graph = cell2mat(x0);
x0 = x0_graph(1:2:10)/0.02732834187248; % factor de escala usado para llevar a km en comparación a la imagen
y0 = x0_graph(2:2:10)/0.02732834187248;
y0 = 896 - y0; %Invertir el eje y
scatter(x0,y0,65,'red','filled');

%Poner label a cada punto
a = [1:5]'; b = num2str(a); c = cellstr(b);
dx = 0; dy = 20; 
text(x0+dx, y0+dy, c);

%Se gráfica el punto solución hallado como mínimo
x_graph = cell2mat(xmin);
x = x_graph(1:2:10)/0.02732834187248; % factor de escala usado para llevar a km en comparación a la imagen
y = x_graph(2:2:10)/0.02732834187248;
y = 896 - y; %Invertir el eje y
scatter(x,y,65,'green','filled');

a = [1:5]'; b = num2str(a); c = cellstr(b);
dx = 0; dy = 20; 
text(x+dx, y+dy, c);

ax = gca;
% Requires R2020a or later
set(gca,'visible','off') %Quitar los ejes 
set(gca,'xtick',[]) %Quitar los ticks de los ejes
set(gca,'LooseInset',get(gca,'TightInset')); %Quitar el borde blanco
exportgraphics(ax,'solved.png','Resolution',800)

%Extender para obtener mejor vista

hold off
