clear all;
clc;

%% load data
all_data = readmatrix('data/all_daily_confirmed_case_624.xlsx','Range','B2:J50');
country_list = {'Portugal','Canada','Germany','United States','England','France','Spain','Netherlands','ALL'};
mean_gen = 9.8;
std_gen = 4;
for country_num = 1:9
    ydata = data_process(all_data,country_num);
    xdata = 1:1:length(ydata);
    % x(1) = r, x(2) = p
    fun = @(x,xdata)x(1)*(((x(1)*(1-x(2))) * xdata + ydata(1,1).^(1-x(2))).^(x(2)/(1-x(2))));
    % set L-M algorithm
    options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt');
    lb = [0,0];
    ub = [10,0.99999];
    n_f = 1;
    R_mat = zeros(n_f,length(ydata));
    for i=1:n_f
%         x0 = [0+10*rand(1),0.79*rand(1)];
        x0 = [0.6,0.6];
        [x,resnorm,residual,exitflag,output,lambda,J] = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options);
        disp(x);

        % Obtain the 95CI of parameter
        conf = nlparci(x,residual,'jacobian',J);
        r_1000 = normal_parameter(x(1),conf(1,1));
        p_1000 = normal_parameter(x(2),conf(2,1));
        for k =1:length(p_1000)
            if p_1000(k)>=1
                p_1000(k) = 0.999999;
            end
        end
        Pd_Gen_time = Gen_Gamma(mean_gen,std_gen,length(ydata));
        R = zeros(1000,length(Pd_Gen_time));
        Re = zeros(1,length(Pd_Gen_time));
        for k=1:length(r_1000)
            para = [r_1000(k),p_1000(k)];
            for t_i = 2:length(Pd_Gen_time)
                sum = 0;
                for j = 1:t_i-1
                    sum = sum + fun(para,j) * Pd_Gen_time(1,t_i-j);
                end
                R(k,t_i) = fun(para,t_i)/sum;
            end
            Re(1,k) = real(R(k,length(Pd_Gen_time)));
        end
        % caclulate mean and 95CI
        Re_mean = mean(Re);
        Re_std = std(Re);
        lower_95_CI_Re = Re_mean - 1.96*Re_std;
        upper_95_CI_Re = Re_mean + 1.96*Re_std;
        % caclulate median and 95CrI
        Re_median = median(Re);
        Re_sort = sort(Re);
        lower_95_CrI_Re = Re_sort(50);
        upper_95_CrI_Re = Re_sort(950);
        % save the results
        Re_last = zeros(2,3);
        Re_last(1,1) = Re_mean;
        Re_last(1,2) = lower_95_CI_Re;
        Re_last(1,3) = upper_95_CI_Re;
        Re_last(2,1) = Re_median;
        Re_last(2,2) = lower_95_CrI_Re;
        Re_last(2,3) = upper_95_CrI_Re;
    end
    Re_save_all{country_num} = Re_last;
end