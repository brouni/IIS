folder_name = '../lab_week2_data/';
data_name1 = 'person';
data_name2 = '.mat';
persons = ['01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; ...
    '11'; '12'; '13'; '14'; '15'; '16'; '17'; '18'; '19'; '20'];

person_number = 1;

loaded_person_data = load(strcat(strcat(strcat(folder_name, data_name1), persons(person_number,:)), data_name2));

data1 = loaded_person_data.iriscode;


person_number = 2;

loaded_person_data = load(strcat(strcat(strcat(folder_name, data_name1), persons(person_number,:)), data_name2));

data2 = loaded_person_data.iriscode;

hamming_distance = sum(bitxor(data1(1,:), data2(1,:)));

randi_file_num = randi(20);
loaded_person_data = load(strcat(strcat(strcat(folder_name, data_name1), persons(randi_file_num,:)), data_name2));
random_row_nr1 = randi(20);
random_row_nr2 = randi(20);

data1 = loaded_person_data.iriscode;

hamming_distance = sum(bitxor(data1(random_row_nr1,:), data1(random_row_nr2,:)));
hd_norm = hamming_distance/30;

set_S = zeros(1,1000);
set_D = zeros(1,1000);


%%load all files to avoid loading files 1000 times
%data_matrix = zeros(20,20,30);
%for i = 1:20
%   temp = load(strcat(strcat(strcat(folder_name, data_name1), persons(i,:)), data_name2));
%   data_matrix(i,:,:) = temp.iriscode;
%end

%Compute set S
for i = 1:1000
    rand_file_num = randi(20);
    loaded_person_data = load(strcat(strcat(strcat(folder_name, data_name1), persons(rand_file_num,:)), data_name2));
    random_row_nr1 = randi(20);
    random_row_nr2 = randi(20);
    
    row1 = loaded_person_data.iriscode(random_row_nr1,:);
    row2 = loaded_person_data.iriscode(random_row_nr2,:);
    norm_hd = sum(bitxor(row1, row2))/30;
    set_S(i) = norm_hd;
end

%Compute set D
for i = 1:1000
    rand_file_num1 = randi(20);
    rand_file_num2 = randi(20);
    random_row_nr1 = randi(20);
    random_row_nr2 = randi(20);
    
    while rand_file_num1 == rand_file_num2
        rand_file_num2 = randi(20);
    end
    
    loaded_person_data1 = load(strcat(strcat(strcat(folder_name, data_name1), persons(rand_file_num1,:)), data_name2));
    loaded_person_data2 = load(strcat(strcat(strcat(folder_name, data_name1), persons(rand_file_num2,:)), data_name2));
    
    row1 = loaded_person_data1.iriscode(random_row_nr1);
    row2 = loaded_person_data2.iriscode(random_row_nr2);
    norm_hd = sum(bitxor(row1, row2))/30;
    set_D(i) = norm_hd;
    
end

close all;
figure; hold on;
hhistogram(set_S);
histogram(set_D);
