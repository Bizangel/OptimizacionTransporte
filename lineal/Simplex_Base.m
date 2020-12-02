function [X_b,I_b] = Simplex_Base(A,b,c,I_b,I_n,verbose)
%Recibe una solución básica factible en forma de I_b e I_n
%Retorna La solución y las variables asociadas a la misma
z0 = 0;
while 1 
    z_anterior = z0;
    
    [c_r,z0] = ReducedCosts(c,A,b,I_b,I_n);
    
    if min(c_r) >= 0
        break;
    end
    [entra,sale] = FindBase(c_r,I_b,I_n,A,b);
    [I_b,I_n] = SwitchBase(entra,sale,I_b,I_n);

    if verbose
        fprintf('Sale x_%d y Entra x_%d\n',[sale,entra]);
        fprintf('La base actual es: {')
        fprintf('%g  ', I_b);
        fprintf('}\n');
        fprintf('La base mejora en un valor de: %g\n',z_anterior - z0);
        fprintf('Valor de la función objetivo: %g\n\n\n',z0);
    end
end
B = A(:,I_b);
X_b = B\b;

