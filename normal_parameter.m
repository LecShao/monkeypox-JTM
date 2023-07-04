function [out] = normal_parameter(mean,lower_95)
    std = (mean - lower_95)/1.95;
    out = normrnd(mean,std,[1,1000]);
end

