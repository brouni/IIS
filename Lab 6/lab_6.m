% clear previous set data and close all figures
clear all;
close all;

%=========================== Initialisation ===========================%
% load data
d = load('data_lvq.mat');
d = d.w5_1;
[rows, cols] = size(d);
data = ones(rows, cols+1);
data(:, 1:cols) = d;
for i = 1:50  % add label to data
  data(i, cols+1) = 0;
end

t_max = 200;
learning_rate = 0.002;

% Initialise RNG
rng('default');

% initialise prototypes
NR_OF_CLASSES = 2;
K = 2; % prototypes per class

prototypes = zeros(NR_OF_CLASSES * K, cols+1);

temp_order_class_1 = randperm(50, K);
temp_order_class_2 = randperm(rows-50, K)+50;
for i = 1:K  % get K random data points per class to assign to prototypes
  prototypes(i, :) = data(temp_order_class_1(i), :);
  prototypes(i+K, :) = data(temp_order_class_2(i), :);
end

prototypes_over_time = zeros(t_max, NR_OF_CLASSES * K, cols+1);
E_over_time = zeros(t_max+1,1);

%========================= Actual computation =========================%

% Compute initial E
E_over_time(1) = 0;
for i = 1:rows
  winner = 1;
  winner_distance = intmax;
  
  for j = 1:NR_OF_CLASSES*K
    distance = pdist([prototypes(j, 1:2); data(i, 1:2)]);
    if distance < winner_distance
      winner_distance = distance;
      winner = j;
    end
  end
  
  E_over_time(1) = E_over_time(1) +  ...
      (prototypes(winner, cols+1) ~= data(i, cols+1));
end


% Permutations
for t = 1:t_max
  
  %  Shuffle data set and perform permutations
  for j = randperm(rows)
    example = data(j, :);
    
    % initialise winner
    winner = 1;
    winner_distance = intmax; % represents infinity
    
    % get closest prototype
    for k = 1:NR_OF_CLASSES * K % take rows
      prototype = prototypes(k, :);
      distance = pdist([example(1:cols); prototype(1:cols)]);
      if distance < winner_distance
        winner_distance = distance;
        winner = k;
      end
    end
    
    % update winner
    sign = 1;
    if prototypes(winner, cols+1) ~= example(cols+1)
      sign = -1;
    end
    
    prototypes(winner, 1:cols) = prototypes(winner, 1:cols) + ...
      sign * learning_rate * ...
      (example(1:cols) - prototypes(winner, 1:cols));
  end
  
  %Compute E
  E = 0;
  for i = 1:rows
    winner = 1;
    winner_distance = intmax;
    
    for j = 1:NR_OF_CLASSES*K
      distance = pdist([prototypes(j, 1:2); data(i, 1:2)]);
      if distance < winner_distance
        winner_distance = distance;
        winner = j;
      end
    end
    
    E = E + (prototypes(winner, cols+1) ~= data(i, cols+1));
  end
  
  % store prototypes and misclassification error for this iteration
  prototypes_over_time(t, :, :) = prototypes;
  E_over_time(t+1) = E;
end

% normalise and convert E_over_time to percentage
E_over_time = E_over_time./rows.*100;


%=============================== Plots ===============================%
figure; hold on;

plot(data(1:50, 1), data(1:50, 2), 'ko', 'MarkerFaceColor', [0 0 0], ...
  'DisplayName', 'Class_1');
plot(data(51:rows, 1), data(51:rows, 2), 'ko', ...
  'MarkerFaceColor', [1 1 1], 'DisplayName', 'Class_2');
i = 0;
for t = 1:t_max
  for c = 0:NR_OF_CLASSES-1
    for k = 0:K-1
      % Make sure only the final prototypes are used in the legend
      if t == t_max && k == K-1
        handle_visibility = 'on';
      else
        handle_visibility = 'off';
      end
      
      row_nr = c*K + k + 1;
      plot(prototypes_over_time(t, row_nr, 1), ...
        prototypes_over_time(t, row_nr, 2), 'o', 'MarkerFaceColor', ...
        %{
        Dynamically set gradient colour, depending on t and prototype class
        %}
        [(prototypes_over_time(t, row_nr,3) == 0) * (t/t_max/2 + .25), ...
         (prototypes_over_time(t, row_nr,3) ~= 0) * (t/t_max/2 + .25), ...
        0], 'HandleVisibility', handle_visibility, ...
        'DisplayName', strcat('P_', num2str(c+1))');
    end
  end
end
title('Prototypes over time');
lgd = legend('show');
hold off;

figure; hold on;
plot(1:t_max+1, E_over_time, 'k-');
plot(1, 10, 'w');  % Scaling for readibility purposes.
plot(1, 30, 'w');
xlabel('Time (epochs)');
ylabel('Misclassification rate (%)');
title('Misclassification rate over time');
hold off;