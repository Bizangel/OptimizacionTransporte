function [x_min] = gradienteProyectado(f,gradf,res,A,x0,Activas, step_search, e)
% Función que aplica el método del gradiente proyectado para encontrar un
% mínimo local de una función
% Input
% -----
% f: función multivariable a minimizar (function handle de matlab), debe
% recibir como argumentos n valores y retornar 1.
%
% gradf: Gradiente de la función f a minimizar (function handle de
% matlabs), debe recbir como argumentos n valores y retornar un cell array
% númerico de n valores. Las componentes deben corresponder a las entradas
% de la función f.
%
% res: Conjunto de m restricciones sobre la función a minimizar. Debe ser un
% cell array de function handles de matlab, donde cada función recibe n parámetros y retorna un único valor 
% Las restricciones deben ser de la forma f(x1,x2,...)<= 0
%
% A: Gradientes de las restricciones sobre la función a minimizar. Debe ser
% un function handle que retorna un cell array de n x m. Correspondiendo
% cada fila al gradiente de cada restricción.
%
% x0: Punto inicial factible, debe ser un cell array número de n entradas
% 
% Activas: Conjunto de restricciones activas en el punto inicial, debe ser
% un array que contenga el indice de las restricciones activas según el
% cell array de restricciones dado.
%
% step_search: Parámetro de salto de busqueda a ser usado para buscar el alpha que
% máx que permite moverme en una dirección factible sin salirme de la región factible.
%
% e: Error a ser usado para varios cálculos (Cota de finalización, busqueda lineal del método aureo,
% rango de verificación de restricciones activas e inactivas)
% Ver pruebaGradienteProyectado.m como referencia  
    %Se comienza con un X anterior 'dummy' para comenzar el while.
    x_anterior = num2cell(cell2mat(x0)'+ 15*e)'; %Asegurar siempre comienze el while en la primera iteración
    xk = x0; %Se comienza como el xk, como el punto inicial dado
    
    while norm(cell2mat(xk)' - cell2mat(x_anterior)') > e

    if ~isempty(Activas) %Si hay restricciones activas, hallar la proyección, y así la dirección de movimiento
    
        A_k = A(xk{:}); %en el punto
        A_k = cell2mat(A_k); % La matriz
        A_k = A_k(Activas,:); %Tomar solo las filas de las restricciones activas


        P = eye(length(A_k)) - A_k'/(A_k*A_k')*A_k;
        gradf_xk = cell2mat(gradf(xk{:}));
        d_k = -P*gradf_xk;
    else %Si no hay restricciones activas, moverse en la dirección opuesta del gradiente todo lo posible
        d_k = -cell2mat(gradf(xk{:}));
    end

    if norm(d_k) < 0.0001 %Suficiente pequeño para considerarlo como 0
        u = -(A_k*A_k')\A_k*gradf_xk; %Hallar el vector de mu's asociado
        if all(u > 0) %Todos son positivos es un mínimo local
            x_min = xk;
            return
        else %Tomar el más negativo y sacar la restricción asociadas de las activas
            u_min = min(u);
            u_min_index = find(u==u_min);
            if length(u_min_index) > 1
                u_min_index = min(u_min_index); %El mínimo indice, en caso se repitan minimos
            end
            %A quitar del espacio de trabajo
            Activas = Activas(Activas~=u_min_index); %Se quita de las activas
        end
        
    else %Dirección distinta de 0, determinamos que tanto nos podemos mover en esa dirección sin salir de la región factible
        xk_eval = cell2mat(xk)'; 
        alpha = step_search;
        while 1 %En un while se itera hasta que alpha supere 1 ó nos salgamos de la región factible
            if(alpha > 1)
                alpha = 1;
                break
            end
            xcheck = xk_eval + d_k*alpha;
            xcheck = num2cell(xcheck); %Para poder reemplazar
            afuera = 0;
            for i=1:length(res)
                if ismember(Activas,i) %Si es una activa, ignorar (bajo la suposición que estamos moviendonos en nuestro espacio de trabajo activo)
                    continue
                end
                check = res{i};
                if check(xcheck{:}) > 0 % Si hay alguna restricción que violemos, entonces nos salimos y ese es el alpha máximo.
                    afuera = 1;
                    break
                end
            end
            
            if afuera %Si violamos una restricción, tomamos el alpha hasta ahí.
                alpha = alpha - step_search;
                break
            end
            alpha = alpha + step_search; %En caso no se viole nada, se sigue aumentando alpha hasta parar
        end
        
        %Se plantea una busqueda de linea para hallar el mínimo de la
        %función en el intervalo del punto y la cuanto nos vamos a ver en
        %la dirección.
        
        a = sym('a');
        amin = xk_eval+a*d_k;
        amin = num2cell(amin); 
        f(amin{:});
        fmin = @(a) subs(f(amin{:})); %Se obtiene una función de a para minimizar
        
        a = MetodoAureo(fmin,0,alpha,e,0); % Se aplica el método aureo para hallar el minimo
        
        x_anterior = xk;
        xk = xk_eval + d_k*a; %Nos movemos en la dirección d_k con el a que nos minimiza la función objetivo.
        xk = num2cell(xk');
        
        %Actualizamos nuestras restricciones activas, dependiendo de en
        %que punto caigamos
        for i=1:length(res)
            if abs(res{i}(xk{:})) < 4*e %Considerar como activa
                if any(ismember(Activas,i))
                    continue
                else
                    Activas = [Activas i];
                end
            else
                if any(ismember(Activas,i)) %Sacarlo
                    Activas = Activas(Activas~=i);
                end
            end
        end
        
    end
    %Una vez acabado, tomar el minimo como el último xk hallado.
    x_min = xk;
    
    end
    
end
    

