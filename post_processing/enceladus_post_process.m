function enceladus_post_process(folder_list)
    figure;
    hold on;
    legends = {};
    for i=1:length(folder_list)
        filn = strcat('../',folder_list{i},'/run_results.mat');
        load(filn,'Period','time_rec','phi_rec','width_rec');
        [phi_day,time_day] = accum_last_days(Period,time_rec,smooth(phi_rec.*width_rec*520000,100),5);
        plot(time_day,smooth(phi_day,100),'linewidth',2); % 
        tmp = folder_list{i};
        tmp = tmp(1:end-4);
        tmp = tmp(1:6);
        tmp = strrep(tmp,'r','Width Ratio');
        legends{end+1} = strrep(tmp,'_','=');
        ii = i;
    end
    xlabel('Time (Day)');
    ylabel('Mass Flux (kg s^{-1})');
    legend(legends,'Location','bestoutside');
    hold off;
    saveas(gcf,strcat(folder_list{1},'.png'));
end