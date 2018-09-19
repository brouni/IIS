close all;

load('../lab_week2_data/lab1_2.mat');

figure; hold on;
person_lengths = measurements(:,1);
hair_lengths = measurements(:,2);
plot(person_lengths, hair_lengths, 'k.')

% plot the median point of all data, in order to make an educated guess
%  of the decision boundary
m_l = median(person_lengths);
m_h = median(hair_lengths);
plot(m_l, m_h, 'r.');
xlabel("body length (cm)");
ylabel("hair length (cm)");
title("Hair- and body lengths of men and women");