collate_axis = 2; % the axis to collate, like run_1_1_1 and run_1_1_2 then we have axis 3

% Process the files in batch after HPC run
fold = '../run_array/';
filn = dir(fold);

tmp = split(filn(3).name,'_');
tmp = tmp(2:end); % remove 'run'
val_matrix = zeros(length(tmp),length(filn)-2);
flags = ones(length(filn)-2,1);
for i = 1:length(filn)-2
    ttmp = split(filn(i+2).name,'_');
    for j = 1:length(tmp)
        val_matrix(j,i) = str2num(ttmp{j+1});
    end
end

while sum(flags)>0
    file_list_set = {};
    for i=1:length(flags)
        if flags(i)==1
            break;
        end
    end
    ref = i;
    for i=ref:length(flags)
        if flags(i)==0
            continue;
        end
        if sum(val_matrix([1:collate_axis-1 collate_axis+1:length(tmp)],i)...
            ==val_matrix([1:collate_axis-1 collate_axis+1:length(tmp)],ref))...
            ==length(val_matrix([1:collate_axis-1 collate_axis+1:length(tmp)],i))
            file_list_set{end+1} = strcat(fold,filn(i+2).name);
            flags(i) = 0;
        end
    end
    enceladus_post_process(file_list_set);
end

