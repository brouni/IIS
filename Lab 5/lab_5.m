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
learning_rate = 0.1;
t_max = 1000;

% Initialise prototypes
prototypes = zeros(K, N);
for i = 1:K
    prototypes(i, :) = data(randi(P), :);
end

% Permutations
%  Shuffle data set
