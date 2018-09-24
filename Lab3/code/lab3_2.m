close all;

load("../lab_week3_data/normdist.mat");

figure; hold on;
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15)+1, 'ro');
plot(T, zeros(5)+2, 'ks');

%===========================================================%

S1 = sort(S1);
S2 = sort(S2);

mu_hat_S1 = sum(S1) / length(S1);
sigma_hat_S1 = sqrt(sum((S1-mu_hat_S1).*(S1-mu_hat_S1)) / length(S1));

mu_hat_S2 = sum(S2) / length(S2);
sigma_hat_S2 = sqrt(sum((S2-mu_hat_S2).*(S2-mu_hat_S2)) / length(S2));

pdf_S1 = normpdf(S1, mu_hat_S1, sigma_hat_S1);
pdf_S2 = normpdf(S2, mu_hat_S2, sigma_hat_S2);

figure; hold on;
plot(S1, pdf_S1, 'b-');
plot(S2, pdf_S2, 'r-');
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15), 'ro');
%plot(T, zeros(5)+2, 'ks');

%============================================================%

prior_S1 = length(S1)/(length(S1)+length(S2))
prior_S2 = length(S2)/(length(S1)+length(S2))

%============================================================%

figure; hold on;
plot(S1, prior_S1*pdf_S1, 'b-');
plot(S2, prior_S2*pdf_S2, 'r-');
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15), 'ro');
plot(T, zeros(5), 'ks');

%============================================================%

a = sigma_hat_S1 * sigma_hat_S1 - sigma_hat_S2*sigma_hat_S2;
b = 2*sigma_hat_S2*sigma_hat_S2*mu_hat_S1 - 2*sigma_hat_S1*sigma_hat_S1*mu_hat_S2;
c = mu_hat_S2*mu_hat_S2 - mu_hat_S1*mu_hat_S1 + ...
    2 * sigma_hat_S1 * sigma_hat_S1 * sigma_hat_S2 * sigma_hat_S2 * ...
    log((prior_S1 * sigma_hat_S2) / (prior_S2 * sigma_hat_S1));
D = b*b - 4*a*c

x1 = -b + sqrt(D) / (2*a)
x2 = -b - sqrt(D) / (2*a)

syms 'x';

expression = solve(prior_S1 * sigma_hat_S2* ...
    exp(-(x-mu_hat_S1)*(x-mu_hat_S1)/(2*sigma_hat_S1*sigma_hat_S1)) == ...
    prior_S2 * sigma_hat_S1* ...
    exp(-(x-mu_hat_S2)*(x-mu_hat_S2)/(2*sigma_hat_S2*sigma_hat_S2)) ...
    );
x = eval(expression);
x_1 = x(1);
x_2 = x(2);



figure; hold on;
plot(S1, prior_S1*pdf_S1, 'b-');
plot(S2, prior_S2*pdf_S2, 'r-');
plot(S1, zeros(30), 'bo');
plot(S2, zeros(15), 'ro');
plot(T, zeros(5), 'ks');
plot([x_1 x_1], [0 0.014], 'k-');
plot([x_2 x_2], [0 0.014], 'k-');
%posterior_S1 = 