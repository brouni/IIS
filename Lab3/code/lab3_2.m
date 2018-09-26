close all;

load("../lab_week3_data/normdist.mat");

figure; hold on;
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15)+1, 'ro');
plot(T, zeros(5)+2, 'ks');
set(gca,'YTickLabel',[]);
set(gca,'YTick',[]);
title("Set 1, Set 2, Test set");
legend("seabass", "salmon", "fish");
%===========================================================%

mu_hat_S1 = sum(S1) / length(S1);
sigma_hat_S1 = sqrt(sum((S1-mu_hat_S1).*(S1-mu_hat_S1)) / length(S1));

mu_hat_S2 = sum(S2) / length(S2);
sigma_hat_S2 = sqrt(sum((S2-mu_hat_S2).*(S2-mu_hat_S2)) / length(S2));

x_values = -40:.1:100;

pdf_S1 = normpdf(x_values, mu_hat_S1, sigma_hat_S1);
pdf_S2 = normpdf(x_values, mu_hat_S2, sigma_hat_S2);

figure; hold on;
plot(x_values, pdf_S1, 'b-');
plot(x_values, pdf_S2, 'r-');
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15), 'ro');
xlabel("length (cm)");
ylabel("posterior probability");
title("Posterior probabilities of seabass and salmon");
legend("seabass", "salmon", "fish");
%============================================================%

prior_S1 = length(S1)/(length(S1)+length(S2))
prior_S2 = length(S2)/(length(S1)+length(S2))

%============================================================%

figure; hold on;
plot(x_values, prior_S1*pdf_S1, 'b-');
plot(x_values, prior_S2*pdf_S2, 'r-');
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15), 'ro');
plot(T, zeros(5), 'ks');

%===========================2.5=================================%

% manual calculation
a = sigma_hat_S1 * sigma_hat_S1 - sigma_hat_S2 * sigma_hat_S2;
b = 2*sigma_hat_S2 * sigma_hat_S2 * mu_hat_S1 - 2 * sigma_hat_S1 *...
    sigma_hat_S1 * mu_hat_S2;
c = sigma_hat_S1 * sigma_hat_S1 * mu_hat_S2 * mu_hat_S2 - ...
    sigma_hat_S2 * sigma_hat_S2 * mu_hat_S1 * mu_hat_S1 + ...
    2 * sigma_hat_S1 * sigma_hat_S1 * sigma_hat_S2 * sigma_hat_S2 * ...
    log(prior_S1 * sigma_hat_S2 / (prior_S2 * sigma_hat_S1));

D = b*b - 4*a*c;
x1 = -b + sqrt(D) / (2*a);
x2 = -b - sqrt(D) / (2*a);

%matlab calculation
syms 'x';
expression = solve(prior_S1 * sigma_hat_S2* ...
    exp(-(x-mu_hat_S1)*(x-mu_hat_S1)/(2*sigma_hat_S1*sigma_hat_S1)) == ...
    prior_S2 * sigma_hat_S1* ...
    exp(-(x-mu_hat_S2)*(x-mu_hat_S2)/(2*sigma_hat_S2*sigma_hat_S2)) ...
    );
x = eval(expression);
x_1 = x(1);
x_2 = x(2);

%===========================2.6=================================%

figure; hold on;
plot(x_values, prior_S1*pdf_S1, 'b-');
plot(x_values, prior_S2*pdf_S2, 'r-');
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15), 'ro');
plot(T, zeros(5)+0.007, 'ks');
plot([x_1 x_1], [0 0.014], 'k-');
plot([x_2 x_2], [0 0.014], 'k-');
%posterior_S1 = 

%===========================2.7=================================%
%error rate S1
omega_1_error_a = normcdf(x_1, mu_hat_S2, sigma_hat_S2);
omega_1_error_b = 1 - normcdf(x_2, mu_hat_S2, sigma_hat_S2);
omega_1_error = omega_1_error_a + omega_1_error_b;

%error rate S2
omega_2_error = normcdf(x_2, mu_hat_S1, sigma_hat_S1) - ...
    normcdf(x_1, mu_hat_S1, sigma_hat_S1);