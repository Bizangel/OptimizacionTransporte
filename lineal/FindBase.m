function [entra,sale] = FindBase(c_r,I_b,I_n,A,b)
%Determina quien sale y quien entra
%Entra Indice de la variable que entra, e indice de la variable que sale

% Regla de Bland
costo_asociado_entra = min(c_r);
entra_i = find(c_r==costo_asociado_entra);

if length(entra_i) > 1 %Si hay más de un mínimo, tomar el primero
    entra_i = min(entra_i);
end

entra = I_n(entra_i);

B = A(:,I_b);
b_gorrito = B\b;
y_entra =  B\A(:,entra);
if all(y_entra < 0)
    error('No hay solución óptima finita!')
end

rango_a = length(I_b);

E = inf([1 rango_a]);
for i=1:rango_a
    if y_entra(i) > 0
        E(i) = (b_gorrito(i)/y_entra(i));
    end
end
epsilon = min(E);
sale_i = find(E==epsilon);
sale = I_b(sale_i);
%Empate en la prueba de la razón
if length(sale) > 1
    sale = min(sale); %El de i de menor valor
end
% I_n
% c_r
% I_b
% fprintf('Sale x_%d y Entra x_%d\n',[sale,entra]);
