function [folder_list] = file_array_generator(lines,param_names,param_values,foldern_prefix,hpc)
    folder_list = {};
    if length(param_names)==0 % Reach the final layer of recursion, write the scripts
        mkdir(foldern_prefix);
        cd(foldern_prefix);
        tmp = split(foldern_prefix,'/');
        filn = tmp{end};        
        if hpc==1
            fid = fopen(strcat(filn,'.sub'),'w');
        else
            fid = fopen(strcat(filn,'.sh'),'w');
        end
        for i=1:length(lines)
            fprintf(fid,lines{i});
        end
        fclose(fid);
        cd('../..');
        folder_list = {foldern_prefix};
    else
        for i=1:length(param_values{1})
            tmp = lines;
            for j=1:length(lines)
                tmp{j} = strrep(lines{j},param_names{1},num2str(param_values{1}(i)));
            end
            tmp_folder_list = file_array_generator(tmp,param_names(2:end),param_values(2:end),strcat(foldern_prefix,'_',num2str(i)),hpc);
            folder_list = [folder_list tmp_folder_list];
        end
    end
end