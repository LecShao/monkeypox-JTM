function [out] = normal_parameter(mean,lower_95)
%NORMAL_PARAMETER 此处显示有关此函数的摘要
%   此处显示详细说明
    std = (mean - lower_95)/1.95;
    out = normrnd(mean,std,[1,1000]);
end

