function [Pd_Gen_time] = Gen_Gamma(mean_Gamma,std_Gamma,sz)
% Generate gamma distribution with mean and standard deviation
% The input: mean and standard deviation of the Gamma, sz is the size of generation time
% list
% The output: a Gammy, a list of generation time with size of 1*sz
b = std_Gamma^2/mean_Gamma;
a = mean_Gamma/b;
Pd_Gen_time = zeros(1,sz);
for t_i = 1:sz
    Pd_Gen_time(t_i) = gamcdf(t_i,a,b) - gamcdf((t_i-1),a,b); 
end
end

