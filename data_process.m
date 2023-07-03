function [data] = data_process(alldata,country_num)
% Counting the first day of local cases
    data_temp = alldata(:,country_num);
    [length,~] = size(data_temp);
    for i = 1:length
        if data_temp(i,1) ~= 0
            break
        end
    end
    data = data_temp(i:length,1)';
    % n-day moving average
%     data = move_ave(data,7);
end

