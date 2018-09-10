t_values = [0.5,0.2,0.1,0.05,0.02,0.01];
mean_var_per_t = zeros(length(t_values), 2);
for i = 1:length(t_values)
    t = t_values(i);
    
    mean_var = tsp(50,100,t);
    mean_var_per_t(i,1) = mean_var(1);
    mean_var_per_t(i,2) = mean_var(2);
    
    fprintf("mean of last 50 values with Temperature = %g: %g.\n", t, mean_var(1));
    fprintf("variance of last 50 values with Temperature = %g: %g.\n", t, mean_var(2));
end

%plot mean over T, as well as variance

figure(3); plot(0,0); hold on;
eb = errorbar(mean_var_per_t(:, 1), t_values, sqrt(mean_var_per_t(:, 2)), 'bo-');
title("Mean of length and standard deviation over temperature",   ... 
             'fontsize',16);
xlabel('Mean <l>','fontsize',16);
ylabel('Temperature','fontsize',16);