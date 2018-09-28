close all;

load('../lab_week3_data/normdist.mat');

%========================== 2.1 ================================%
% create plot
figure; hold on;

% create plot handles for legend items
h = zeros(3,1);
h(1) = plot(nan, nan, 'bo');
h(2) = plot(nan, nan, 'ro');
h(3) = plot(nan, nan, 'ks');

plot(S1, zeros(30), 'bo');
plot(S2, zeros(15)+1, 'ro');
plot(T, zeros(5)+2, 'ks');

% Remove unnecessary y-axis ticks.
set(gca,'YTickLabel',[]);
set(gca,'YTick',[]);
title('Set 1, Set 2, Test set');
legend(h, 'Set 1', 'Set 2', 'Test set');

%========================== 2.2 ================================%
% compute mean and standard deviation of S1 and S2
mu_hat_S1 = sum(S1) / length(S1);
sigma_hat_S1 = sqrt(sum((S1-mu_hat_S1).*(S1-mu_hat_S1)) / length(S1));

mu_hat_S2 = sum(S2) / length(S2);
sigma_hat_S2 = sqrt(sum((S2-mu_hat_S2).*(S2-mu_hat_S2)) / length(S2));

% create and plot the normal distributions
x_values = -40:.1:100;

pdf_S1 = normpdf(x_values, mu_hat_S1, sigma_hat_S1);
pdf_S2 = normpdf(x_values, mu_hat_S2, sigma_hat_S2);

figure; hold on;

% create plot handles for legend items
h = zeros(4,1);
h(1) = plot(nan, nan, 'b-');
h(2) = plot(nan, nan, 'r-');
h(3) = plot(nan, nan, 'bo');
h(4) = plot(nan, nan, 'ro');


plot(x_values, pdf_S1, 'b-');
plot(x_values, pdf_S2, 'r-');
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15), 'ro');
ylabel('class conditional probability density');
title('Class conditional probability densities of Set 1 and Set 2');
legend(h, 'CCPD S_1', 'CCPD S_1', 'S_1', 'S_2');

%========================== 2.3 ================================%
% compute a priori probabilities
prior_S1 = length(S1)/(length(S1)+length(S2))
prior_S2 = length(S2)/(length(S1)+length(S2))

%========================== 2.4 ================================%

figure; hold on;

% create plot handles for legend items
h = zeros(5,1);
h(1) = plot(nan, nan, 'b-');
h(2) = plot(nan, nan, 'r-');
h(3) = plot(nan, nan, 'bo');
h(4) = plot(nan, nan, 'ro');
h(5) = plot(nan, nan, 'ks');

% create plot
plot(x_values, prior_S1*pdf_S1, 'b-');
plot(x_values, prior_S2*pdf_S2, 'r-');
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15), 'ro');
plot(T, zeros(5)+0.007, 'ks');
ylabel('non-normalised posterior probability');
title(['Non-normalised posterior probabilities with' ...
  ' original and Test data']);
legend(h, 'NNPP S_1', 'NNPP S_2', 'S_1', 'S_2', 'T');

%========================== 2.5 ================================%

% manual calculation
a = sigma_hat_S1 * sigma_hat_S1 - sigma_hat_S2 * sigma_hat_S2;
b = 2*(sigma_hat_S2 * sigma_hat_S2 * mu_hat_S1 - ...
    sigma_hat_S1 * sigma_hat_S1 * mu_hat_S2);
c = sigma_hat_S1 * sigma_hat_S1 * mu_hat_S2 * mu_hat_S2 - ...
    sigma_hat_S2 * sigma_hat_S2 * mu_hat_S1 * mu_hat_S1 + ...
    2 * sigma_hat_S1 * sigma_hat_S1 * sigma_hat_S2 * sigma_hat_S2 * ...
    log(prior_S1 * sigma_hat_S2 / (prior_S2 * sigma_hat_S1));

D = b*b - 4*a*c;

% Assuming D is non-negative and we won't have complex answers,
% sqrt(D) is always non-negative, so x1 <= x2.
x1 = (-b - sqrt(D)) / (2*a);
x2 = (-b + sqrt(D)) / (2*a);

% matlab calculation
syms 'x';
expression = solve( ...
    prior_S1 * sigma_hat_S2* ...
    exp(-(x-mu_hat_S1)*(x-mu_hat_S1)/(2*sigma_hat_S1*sigma_hat_S1)) ...
    == ...
    prior_S2 * sigma_hat_S1* ...
    exp(-(x-mu_hat_S2)*(x-mu_hat_S2)/(2*sigma_hat_S2*sigma_hat_S2)) ...
    );
x_eval = eval(expression);
if x_eval(1) < x_eval(2)  % ensure x_1 <= x_2
  x_1 = x_eval(1);
  x_2 = x_eval(2);
else
  x_1 = x_eval(2);
  x_2 = x_eval(1);
end

%========================== 2.6 ================================%
% create plot
% create plot handles for legend items
figure; hold on;
h = zeros(6,1);
h(1) = plot(nan, nan, 'b-');
h(2) = plot(nan, nan, 'r-');
h(3) = plot(nan, nan, 'bo');
h(4) = plot(nan, nan, 'ro');
h(5) = plot(nan, nan, 'ks');
h(6) = plot(nan, nan, 'k-');

plot(x_values, prior_S1*pdf_S1, 'b-');
plot(x_values, prior_S2*pdf_S2, 'r-');
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15), 'ro');
plot(T, zeros(5)+0.007, 'ks');
plot([x_1 x_1], [0 0.014], 'k-');
plot([x_2 x_2], [0 0.014], 'k-');
ylabel('non-normalised posterior probability');
title(['Non-normalised posterior probabilities with' 10 ...
'original data, Test data, and decision criterions']);
legend(h, 'NNPP S_1', 'NNPP S_2', 'S_1', 'S_2', 'T', 'DC');

%========================== 2.7 ================================%
%error rate S1
omega_1_error_a = normcdf(x_1, mu_hat_S2, sigma_hat_S2);
omega_1_error_b = 1 - normcdf(x_2, mu_hat_S2, sigma_hat_S2);
omega_1_error = omega_1_error_a + omega_1_error_b

%error rate S2
omega_2_error = normcdf(x_2, mu_hat_S1, sigma_hat_S1) - ...
    normcdf(x_1, mu_hat_S1, sigma_hat_S1)