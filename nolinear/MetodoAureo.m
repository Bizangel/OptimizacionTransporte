function [a_k,b_k] = MetodoAureo(f,a,b,error,verbose)
%Recibe función f de una variable quasi-convexa, y la minimiza haciendo uso
%del método aureo, suponiendo que presenta un minimo local en el interval
% (a,b) dados como parámetros. 
% Modo verbose permite el display de las iteraciones. Bool: 0/1

I = error; %La longitud del intervalo final, es decir el error
ALPHA = 0.618; %Constante Aurea

a_k = a; b_k = b; %Se establecen los intervalos iniciales
k = 0; % Se comienza desde k = 0

%Se calculan lambda_k y u_k haciendo uso de la constante aurea
lambda_k = a_k + (1-ALPHA)*(b_k - a_k); 
u_k = a_k + ALPHA*(b_k - a_k);

%Paso 1
while 1
    longitud = b_k - a_k;
    if longitud < I %El método termina cuando encontremos un intervalo con el cual estemos a gusto
        return;
    else
        if f(lambda_k) > f(u_k) %Paso 2
            %Se realiza paso 2, en el cual se acota la parte izquierda
            %Y se calcula un nuevo u_k
            a_k = lambda_k;
            lambda_k = u_k;
            u_k = a_k + ALPHA*(b_k - a_k);
            k = k+1;
        else %Paso 3
            %Se realiza paso 3, en el cual se acota la parte derecha
            %Y se calcula un nuevo lambda_k
            b_k = u_k;
            u_k = lambda_k;
            lambda_k = a_k + (1-ALPHA)*(b_k-a_k);
            k = k+1;
        end
    end
    
    if verbose
        nueva_longitud = b_k - a_k;
        factor_reduccion = nueva_longitud/longitud;
        if k == 1
            fprintf('\n\n Iteraciones: \n');
            fprintf('k \t a_k \t \t b_k  \t\t lambda_k \t u_k \t f(lambda_k) \t f(u_k)\t f de reduccion\n')
        end
        
        fprintf('%d \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t%.4f \n',k,a_k,b_k,lambda_k,u_k, f(lambda_k),f(u_k),factor_reduccion);
    end
end

end



