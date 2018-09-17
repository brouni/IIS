close all;

figure(1);hold on;
person_lengths = measurements(:,1);
hair_lengths = measurements(:,2);
plot(person_lengths, hair_lengths, 'k.')

%get top half of the sorted length array
%get top half of the sorted hair_l array

m_l = median(person_lengths);
m_h = median(hair_lengths);
plot(m_l, m_h, 'r.')