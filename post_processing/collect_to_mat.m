function collect_to_mat(folder, fileto)
    tmp = dir(folder);
    all_list = {};
    for i=1:length(tmp)
        if contains(tmp(i).name,'run_')
            all_list{end+1} = enceladus_to_mat(strcat(folder,'/',tmp(i).name));
        end
    end
    save(fileto,'all_list');
end