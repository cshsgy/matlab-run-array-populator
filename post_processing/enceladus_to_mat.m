function data_to_store = enceladus_to_mat(folder_name)
    % reads from the stored data file and stores the required quantities
    % stores: metadata (L,Wmin,WR), the mass flux, time
    data_to_store = {};
    tmp = strrep(folder_name,'/','');
    tmp = str2double(tmp(end));
    load(strcat(folder_name,'/run_results.mat'),'width_rec','phi_rec','time_rec');
    data_to_store{end+1} = [5000*2^tmp min(width_rec) max(width_rec)/min(width_rec)];
    [phi,t] = accum_last_days(118800,time_rec,phi_rec,15)
    data_to_store{end+1} = phi;
    data_to_store{end+1} = t;
end