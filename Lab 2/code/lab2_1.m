close all;

dc = 170;

%set edges for histogram
edges = min(min(length_men),min(length_women)):1:max(max(length_men),max(length_women));

%set data for histogram
h1 = histcounts(length_men,edges);
h2 = histcounts(length_women,edges);

%plot histograms
figure(1)
bar(edges(1:end-1),[h1; h2]')
grid on;

%find optimal decision criterion
%dc = decision criterion
%mc = misclassifications
optimal_dc = edges(1); %initialise with the first value
optimal_mc = intmax; %represents infinity

for i = 1:length(edges)
    dc = edges(i);
    miss_man = sum(h1(1:dc - edges(1)));
    miss_woman = sum(h2(dc - edges(1)+1:end));
    mc_sum = miss_man + miss_woman;
    
    if mc_sum < optimal_mc
        optimal_mc = mc_sum;
        optimal_dc = dc;
    elseif mc_sum == optimal_mc
        optimal_dc = cat(2, optimal_dc, dc);
    end
end

%print optimal decision criterion
optimal_dc
optimal_mc