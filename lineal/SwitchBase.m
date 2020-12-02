function [new_I_b,new_I_n] = SwitchBase(entra,sale,I_b,I_n)

pull_i = find(I_b==sale);
enter_i = find(I_n == entra);

I_b(pull_i) = entra;
I_n(enter_i) = sale;
new_I_b = sort(I_b);
new_I_n = sort(I_n);
