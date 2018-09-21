function person_data = load_iris_scan_data(person_nr)

folder_name = '../lab_week2_data/';
data_name1 = 'person';
data_name2 = '.mat';

% convert person_nr to int
if isnumeric(person_nr)
    person_nr = int64(person_nr);
elseif ischar(person_nr)
    person_nr = int64(str2double(['int32(' person_nr ')']));
end

% convert person_nr back to char, plus add padding
str_person_nr = int2str(person_nr);
if person_nr < 10
    str_person_nr = strcat('0', str_person_nr);
end


person_data = load(strcat(strcat(strcat(folder_name, data_name1),...
    str_person_nr), data_name2));

end