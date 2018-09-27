close all;

load('../lab_week3_data/lab3_1.mat')

%========================== 1.1 ================================%
% compute posterior probabilities
% occurences of sea bass vs salmon is 3:1
a_priori_seabass = .75;
a_priori_salmon = .25;

evidence = p_seabass * a_priori_seabass + p_salmon * a_priori_salmon;

posterior_seabass = p_seabass * a_priori_seabass ./ evidence;
posterior_salmon = p_salmon * a_priori_salmon ./ evidence;

% plot figure
figure; hold on;
plot(l, posterior_seabass, 'r-');
plot(l, posterior_salmon, 'b-');
xlabel('length (cm)');
ylabel('posterior probability');
title('Posterior probabilities of sea bass and salmon');
legend('seabass', 'salmon');

%========================== 1.2 ================================%
% get posterior probabilities for lengths 8 and 20
l_8_index = 71;
l_20_index = 191;
pos_sb_8 = posterior_seabass(l_8_index)
pos_sal_8 = posterior_salmon(l_8_index)
pos_sb_20 = posterior_seabass(l_20_index)
pos_sal_20 = posterior_salmon(l_20_index)


% plot figure
figure; hold on;
x_vals_8 = zeros(21)+8;
x_vals_20 = zeros(21)+20;
y_vals = 0:.05:1;

plot(l, posterior_seabass, 'r-');
plot(l, posterior_salmon, 'b-');
plot(x_vals_8, y_vals, 'k-');
plot(x_vals_20, y_vals, 'k--');

xlabel('length (cm)');
ylabel('posterior probability');
title('Posterior probabilities of sea bass and salmon');
legend('sea bass', 'salmon', 'fish');
