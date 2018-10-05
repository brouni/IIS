close all;
load('lab_4_data/dataAEX.mat');
load('lab_4_data/labelsAEX.mat');


aex_linkage = linkage(data,'average');
dendrogram(aex_linkage,'Labels', labels,'Orientation','right');
ylabel('Dutch stock index abreviations');
xlabel('Cluster distances');
title('Cluster distances by Dutch stock indexes');
    
% aex_linkage

