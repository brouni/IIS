
% Compute Hamming distance between iris scans of the same person.
rand_file_num = randi(20);
random_row_nr1 = randi(20);
random_row_nr2 = randi(20);

data1 = load_iris_scan_data(rand_file_num);

hamming_distance_same = sum(bitxor(data1(random_row_nr1,:), ...
    data1(random_row_nr2,:)))

% Compute Hamming distance between iris scans of differing persons.
person_number = 1;
data1 = load_iris_scan_data(person_number);
person_number = 2;
data2 = load_iris_scan_data(person_number);
hamming_distance_different = sum(bitxor(data1(1,:), data2(1,:)))

%======================================================================%

set_S = zeros(1,1000);
set_D = zeros(1,1000);

% Compute set S
for i = 1:1000
    rand_file_num = randi(20);
    loaded_person_data = load_iris_scan_data(rand_file_num);
    random_row_nr1 = randi(20);
    random_row_nr2 = randi(20);
    
    row1 = loaded_person_data(random_row_nr1,:);
    row2 = loaded_person_data(random_row_nr2,:);
    norm_hd = sum(bitxor(row1, row2))/30;
    set_S(i) = norm_hd;
end


% Compute set D
for i = 1:1000
    rand_file_num1 = randi(20);
    rand_file_num2 = randi(20);
    random_row_nr1 = randi(20);
    random_row_nr2 = randi(20);
    
    % rand perm
    while rand_file_num1 == rand_file_num2
        rand_file_num2 = randi(20);
    end
    
    % select person with random number
    loaded_person_data1 = load_iris_scan_data(rand_file_num1);
    loaded_person_data2 = load_iris_scan_data(rand_file_num2);
    
    % read random row of random person
    row1 = loaded_person_data1(random_row_nr1, :);
    row2 = loaded_person_data2(random_row_nr2, :);
    norm_hd = sum(bitxor(row1, row2))/30;
    
    set_D(i) = norm_hd;
end

%======================================================================%

%calculate mean and standard deviation
mean_S = mean(set_S);
mean_D = mean(set_D);
std_S = std(set_S);
std_D = std(set_D);

% generate figure and histograms. 
% histfit uses and calculates mean and std. deviation of the sets itself.
close all;
figure; hold on;

% obtain bin-counts (= length of edges vector) for smoother histogram
%  and normal distribution plot creation.
[hc_s, edges_s] = histcounts(set_S);
[hc_d, edges_d] = histcounts(set_D);

h_s = histfit(set_S, length(edges_s)-1);
h_d = histfit(set_D, length(edges_d)-1);
h_s(2).Color = [1 0 0]; % set normal dist. colour to red
h_d(2).Color = [0 0 1]; % set normal dist. colour to blue
alpha(.5);
xlabel("Hamming Distance (normalised)");
ylabel("Nr. of occurrences (sample size = 1000)");
title("Normalised Hamming distances of compared iris scans");
legend("set S", "Normal distribution set S", ...
    "set D", "Normal distribution set D");