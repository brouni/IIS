close all;

load('../lab_week2_data/lab1_1.mat');

%======================================================================%

% set edges for histogram
edges = min(min(length_men),min(length_women)):1:max(max(length_men), ...
            max(length_women));

% set data for histogram
h1 = histcounts(length_men,edges);
h2 = histcounts(length_women,edges);

% plot histograms
figure;
bar(edges(1:end-1),[h1; h2]');
grid on;

xlabel("body length (cm)");
ylabel("nr. of occurrences (sample size = 200)");
title("Body length of men and women");
legend("men", "women");

%======================================================================%

% find misclassifications for men and women for dc=170,
%  where the difference between women and men is defined as follows:
%  women < dc <= men
%  dc : decision criterion
%  mc : misclassifications

dc = 170;
% output values
mc_men_170 = sum(h1(1:dc - edges(1)))
mc_women_170 = sum(h2(dc - edges(1)+1:end))

%======================================================================%

% find optimal decision criterion
optimal_dc = edges(1); % initialise with the first value
optimal_mc = intmax; % represents infinity

for i = 1:length(edges)
    dc = edges(i);
    mc_men = sum(h1(1:dc - edges(1)));
    mc_women = sum(h2(dc - edges(1)+1:end));
    mc_sum = mc_men + mc_women;
    
    if mc_sum < optimal_mc(1)
        optimal_mc = mc_sum;
        optimal_dc = dc;
        
    % If more optimal dc's exist, add them to our list/vector.
    elseif mc_sum == optimal_mc(1)
        optimal_dc = cat(2, optimal_dc, dc);
    end
end

% print optimal decision criterion
optimal_dc
optimal_mc