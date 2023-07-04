function [out_data] = move_ave(data,number)
    l = length(data);
    for i = 1:l-number+1
        out_data(i) = sum(data(i:i+number-1))/number;
    end
    for i = l-number+2:l
        out_data(i) = sum(data(i:l))/(l-i+1);
    end
end

