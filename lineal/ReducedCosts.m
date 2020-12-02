function [c_r, z0] = ReducedCosts(C,A,b,I_b,I_n)
c_j = C(I_n); %Coeficientes de no básicas
c_b = C(I_b); %Coeficientes de básicas
B = A(:,I_b);
N = A(:,I_n);
z0 = c_b*(B\b);

c_r = c_j - c_b/B*N;