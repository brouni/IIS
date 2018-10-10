clear all;

% load data
data_x = load('w6_1x.mat');
data_x = data_x.w6_1x;
data_y = load('w6_1y.mat');
data_y = data_y.w6_1y;
data_z = load('w6_1z.mat');
data_z = data_z.w6_1z;

data = data_x; % replace with dataset of your choice.

% Initialise variables.
[P, N] = size(data);
K = 2;
learning_rate = 0.1; % eta
t_max = 1000;

% Initialise prototypes
prototypes = zeros(K, N);
for i = 1:K
    prototypes(i, :) = data(randi(P), :);
end

% Permutations
for i = 1:t_max
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
    prototype(winner) = prototype(winner) + ...
      learning_rate * (example - prototype(winner));
  
    % update (partial) sum of quantisation error
    H_VQ = H_VQ + winner_distance;
  end
  
  % TODO: plot data and prototype positions, perhaps outside of this loop
  
  % TODO: plot quantisation error H_VQ, perhaps outside of this loop
end