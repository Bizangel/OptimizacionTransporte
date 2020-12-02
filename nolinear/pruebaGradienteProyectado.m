clear all

%Función objetivo junto a gradf
f = @(x,y) x^2 + y^2;
gradf = @(x,y) {2*x;
                2*y};
            
% %Restriccion nice
res = {@(x,y) -x^2-y+1,@(x,y) x+y+1}; % Restricciones X <= 0
%Gradientes de Restricciones

A = @(x,y) {-2*x,-1;
            1 ,1 };
x0 = {-2,-3};


%Restricción Redundante
% res = {@(x,y) -x^2-y+1,@(x,y) -x+y-1}; % Restricciones X <= 0
% A = @(x,y) {-2*x,-1;
%              -1 ,1 };
% x0 = {2,-3};

%Determinar el conjunto activo para comenzar
m = length(res);
Activas = [];
for i=1:m
    if res{i}(x0{:}) == 0
        Activas = [Activas i];
    end
end

step_search = 0.001;
error = 0.001;
x = gradienteProyectado(f,gradf,res,A,x0,Activas,step_search,error);
x
f(x{:})