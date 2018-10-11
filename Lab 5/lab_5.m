clear all;
close all;

% load data
data_x = load('w6_1x.mat');
data_x = data_x.w6_1x;
data_y = load('w6_1y.mat');
data_y = data_y.w6_1y;
data_z = load('w6_1z.mat');
data_z = data_z.w6_1z;

data = data_x; % replace with dataset of your choice.

% Initialise RNG
rng('default');

% set colour rgb values
red = [1 0 0];
green = [0 1 0];
blue = [0 0 1];
magenta = [1 0 .93];
white = [1 1 1];
colour_init_1 = (red + white*2)./3;
colour_init_2 = (green + white*2)./3;
colour_init_3 = (blue + white*2)./3;
colour_init_4 = (magenta + white*2)./3;

% Initialise variables.
[P, N] = size(data);
K = 4;
learning_rate = 0.1;
t_max = 100;

prototypes_over_time = zeros(t_max, K, N);
H_VQ_over_time = zeros(t_max+1, 1);

% Initialise prototypes
prototypes = zeros(K, N);
for i = 1:K
    prototypes(i, :) = data(randi(P), :);
end

% Compute initial H_VQ
for j = randperm(P)
    example = data(j, :);
    
    winner_distance = intmax;
    for k = 1:K
        prototype = prototypes(k, :);
        distance = pdist([example; prototype]);
        if distance < winner_distance
            winner_distance = distance;
        end
    end
    H_VQ_over_time(1) = H_VQ_over_time(1) + winner_distance/P;
end

% Permutations
for t = 1:t_max
  H_VQ = 0; % initialise quantisation error for manual sum.
  
  %  Shuffle data set and perform permutations
  for j = randperm(P)
    example = data(j, :);
    
    % initialise winner
    winner = 1;
    winner_distance = intmax; % represents infinity
    
    % get closest prototype
    for k = 1:K % take rows
      prototype = prototypes(k, :);
      distance = pdist([example; prototype]);
      if distance < winner_distance
        winner_distance = distance;
        winner = k;
      end
    end
    
    % update winner
    prototypes(winner, :) = prototypes(winner, :) + ...
      learning_rate * (example - prototypes(winner, :));
  
    % update (partial) sum of quantisation error
    H_VQ = H_VQ + winner_distance;
  end
  
  % store prototypes and quantisation error for this iteration
  prototypes_over_time(t, :, :) = prototypes;
  H_VQ_over_time(t+1) = H_VQ;
  
  % normalise H_VQ
  H_VQ_over_time(t+1) = H_VQ_over_time(t+1)/P;
end

% plot prototypes and data over time
%  note that this code is for K = 2 and K = 4
figure; hold on;

% plot data points
data_plot = plot(data(:, 1), data(:, 2), 'ksq');

% plot next iterations with an increasingly coloured line
for t = 2:t_max-1
    plot(prototypes_over_time(t, 1, 1), prototypes_over_time(t, 1, 2), ...
        'o', 'MarkerFaceColor', [t/t_max /2 + .25 0 0]);
    plot(prototypes_over_time(t, 2, 1), prototypes_over_time(t, 2, 2), ...
        'o', 'MarkerFaceColor', [0 t/t_max /2 + .25 0]);
end

% plot first iteration in a whiter form
plot(prototypes_over_time(1, 1, 1), prototypes_over_time(1, 1, 2), ...
    'o', 'MarkerFaceColor', colour_init_1);
plot(prototypes_over_time(1, 2, 1), prototypes_over_time(1, 2, 2), ...
    'o', 'MarkerFaceColor', colour_init_2);

% plot final iteration with fully coloured line
plot(prototypes_over_time(t_max, 1, 1), ...
    prototypes_over_time(t_max, 1, 2), 'o', 'MarkerFaceColor', red);
plot(prototypes_over_time(t_max, 2, 1), ...
    prototypes_over_time(t_max, 2, 2), 'o', 'MarkerFaceColor', green);

% hacky way to add extra plots for when K=4
if K == 4
  for t = 2:t_max-1
    plot(prototypes_over_time(t, 3, 1), prototypes_over_time(t, 3, 2), ...
        'o', 'MarkerFaceColor', [0 0 t/t_max /2 + .25]);
    plot(prototypes_over_time(t, 4, 1), prototypes_over_time(t, 4, 2), ...
        'o', 'MarkerFaceColor', [t/t_max/2+.38 0 t/t_max/2+.33]);
  end
  
  plot(prototypes_over_time(1, 3, 1), prototypes_over_time(1, 3, 2), ...
      'o', 'MarkerFaceColor', colour_init_3);
  plot(prototypes_over_time(1, 4, 1), prototypes_over_time(1, 4, 2), ...
      'o', 'MarkerFaceColor', colour_init_4);

  plot(prototypes_over_time(t_max, 3, 1), ...
      prototypes_over_time(t_max, 3, 2), 'o', 'MarkerFaceColor', blue);
  plot(prototypes_over_time(t_max, 4, 1), ...
      prototypes_over_time(t_max, 4, 2), 'o', 'MarkerFaceColor', magenta);
end

% title and legend
title('Prototypes over time');
legend_plots = zeros(2*K+1, 1);
legend_plots(1) = data_plot;
legend_plots(2) = plot(nan, nan, 'ro', 'MarkerFaceColor', colour_init_1);
legend_plots(3) = plot(nan, nan, 'ro', 'MarkerFaceColor', red);
legend_plots(4) = plot(nan, nan, 'go', 'MarkerFaceColor', colour_init_2);
legend_plots(5) = plot(nan, nan, 'go', 'MarkerFaceColor', green);
if K == 2
  legend(legend_plots, 'Data points', 'P_1 Init', 'P_1', ...
      'P_2 Init', 'P_2');
else
  legend_plots(6) = plot(nan, nan, 'bo', 'MarkerFaceColor', colour_init_3);
  legend_plots(7) = plot(nan, nan, 'bo', 'MarkerFaceColor', blue);
  legend_plots(8) = plot(nan, nan, 'mo', 'MarkerFaceColor', colour_init_4);
  legend_plots(9) = plot(nan, nan, 'mo', 'MarkerFaceColor', magenta);
  legend(legend_plots, 'Data points', 'P_1 Init', 'P_1', ...
      'P_2 Init', 'P_2', 'P_3 Init', 'P_3', ...
      'P_4 Init', 'P_4');
end

% plot quantisation error over time
figure; hold on;
plot(1:t_max+1, H_VQ_over_time, 'k-');
ylabel('Normalised Quantisation Error');
xlabel('Time (epoch)');
title('Normalised Quantisation Error over time');