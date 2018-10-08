close all;
load('lab_4_data/dataAEX.mat');
load('lab_4_data/labelsAEX.mat');

aex_linkage = linkage(data);
dendrogram(aex_linkage,'Labels', labels,'Orientation','right');
ylabel('Dutch stock index abreviations');
xlabel('Cluster distances');
title('Cluster distances by Dutch stock indices');

non_aex_linkage = linkage(data(1:18, :))
figure;
dendrogram(non_aex_linkage, 'Labels', labels(1:18), ...
    'Orientation', 'right');
ylabel('Dutch stock index abreviations');
xlabel('Cluster distances');
title('Cluster distances by Dutch stock indices (without AEX)');
