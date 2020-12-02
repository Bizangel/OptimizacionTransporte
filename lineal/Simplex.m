function [X_sol] = Simplex(A,b,c,max,verbose)
%Recibe un problema lineal de optimización en formato estándar
%y retorna la solución, cuando sea posible, 
% la opción máx como 1 cuando es un problema de maximización o 0 de lo
% contrario (minimización)
% la opción verbose como lógica 1 ó 0 permite imprimir el procedimiento
if max
    c = c.*-1;
    if verbose
        fprintf('Problema de maximizar, luego se minimiza el negativo del problema original\n')
    end
end

c_original = c;
A_original = A;
%Verifica las dimensiones
[x,y] = size(A);
if (length(c) ~= y || length(b) ~= x)
    error('La dimensión de los parámetros no coincide')
end
%Aplicar 1-fase
c = zeros([1 y]);

c = [c ones([1 x])];

I_artificiales = y+1:1:y+x; % 4-6 [4,5,6] artificiales
I_estructural = 1:1:y;  % 1-4

I = eye(x);
A = [A I];

%Se tratan las artificiales como básicas, y estructurales como no básicas
%Se aplica la Fase I
if verbose
    fprintf('Comienza Fase I\n')
end
[X_b,I_b_sol] = Simplex_Base(A,b,c,I_artificiales,I_estructural,0);
X_sol_basica = zeros([1 y]);
X_sol_basica(I_b_sol) = X_b;
if verbose
    fprintf('Se termina la Fase 1 Se halla solución Básica Factible:\n X=[')
    fprintf('%g  ', X_sol_basica);
    fprintf(']\n');
end
%Verificamos que las artificiales NO esten en la solución Óptima
% Y sí estan presente, verificar que sean 0 para quitarlas
for i=1:x
    x_a_i = I_artificiales(i);
    if ismember(x_a_i,I_b_sol)
        x_a_i_b = find(I_b_sol==x_a_i); %El indice de la variable en X_b
        x_a = X_b(x_a_i_b);%El valor de la variable artificial en solución 'Optima'
        if x_a == 0
            %Hallamos el reemplazo para la artificial
            for i2=1:length(I_estructural)
                x_i_estructural = I_estructural(i2);
                if ~ ismember(x_i_estructural,I_b_sol) %Se hallo el reemplazo
                    I_b_sol(x_a_i_b) = x_i_estructural; 
                    %Lo saco de las estructurales para evitar repeticiones
                    I_estructural = I_estructural(I_estructural~=x_i_estructural);
                    break
                end
            end
        else
            error('¡No hay solución óptima del problema!')
        end
    end
    %error ('No hay solución óptima del problema!')
end
%X_b es solución básica factible del problema original
%Retornamos al problema original, hallamos las no básicas basandonos en las
%básicas obtenidas (I_b_sol obtenido)
if verbose
    fprintf('Comienza Fase II\n')
    fprintf('Con base: {')
    fprintf('%g  ', I_b_sol);
    fprintf('}\n\n\n');
end
temp = (1:1:y);
I_n = temp(~ismember(temp,I_b_sol));
[X_b, I_b] = Simplex_Base(A_original,b,c_original,I_b_sol,I_n, verbose);
X_sol = zeros([y 1]);
X_sol(I_b) = X_b;
