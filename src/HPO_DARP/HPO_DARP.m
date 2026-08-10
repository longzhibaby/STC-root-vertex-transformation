    % This project uses the following third-party code: https://github.com/Wei-Fan: Use MIT license
    %  DARP based on HPO is used to solve the Area Decomposition problem
    %  Revised by longzhibaby
    %  Contributors: Chao-Wang, Wei-Dong, Yongzhuo-Gao, Huajian-Liu, Renjie-Li, Kunpen-Fan, Yixuan-Feng etc.
    %  
    %%
    %  Required Documents:
    %       divide_area_for_Darp_HPO_for_rob4.m
    %       display_area.m
    %       isconnect.m

    %%
    clc;
    clear;
    tic

    %% Paremeter 
    Iteration_number_parameter_setting = 2000;
    Random_seed_parameter_settings = 196;
    LENGTH     = 80  ;   %  must be even [The length of the environment]
    Random_environment_coverage_area_threshold = (LENGTH*LENGTH/12);

    %%
    rng(Random_seed_parameter_settings ,'twister');   %  Random seed required for random experiment environment generation
    
    

    %% Modifications required when the number of robots changes

    % Code that needs to be modified when the number of robots changes(part1)
    ROBOT_NUM  = 8   ;   %  Number of robots in the system


    %% Initialization of paremeters needed in the algorithm 

    Sum_of_B_repiared_for_start = 1;    
    min_current_M = (LENGTH*LENGTH)/4;
    parameter_of_threshold_for_sota_deviation_value = 0.02;
    Optimal_M_input = ((LENGTH*LENGTH)/(4*ROBOT_NUM));


    %%
    f1=figure(1);
    set(gcf, 'unit', 'centimeters', 'position', [1 15 13 10]);   %  The part on the screen: upside-left
    f2=figure(2);
    set(gcf, 'unit', 'centimeters', 'position', [14 15 13 10]);  %  The part on the screen: upside-middle 
    f3=figure(3);
    set(gcf, 'unit', 'centimeters', 'position', [27 15 13 10]);  %  The part on the screen: upside-right
    f4=figure(4);
    set(gcf, 'unit', 'centimeters', 'position', [1 1 13 10]);    %  The part on the screen: downside-left
    f5=figure(5); 
    set(gcf, 'unit', 'centimeters', 'position', [14 1 13 10]);   %  The part on the screen: downside-middle
    f6=figure(6); 
    set(gcf, 'unit', 'centimeters', 'position', [27 1 13 10]);   %  The part on the screen: downside-right

    % In this demo [Decomposition of test area environment based on multiple guidance]
    % The function of each fig are as follows:
    % fig1   Initial environment (Optimized obstacle environment)
    % fig2   Solution results of DARP with original parameters
    % fig3   The solution results of DARP are being updated in real time
    % fig4   The update process of DARP is being updated in real time
    % fig5   The best approximate solution currently obtained
    % fig6   Overall convergence of solution obtained by DARP

%%  part 1 (Figure 1) Random environment generation 
    figure(1)
    A_core = unifrnd(0,1,[LENGTH/2,LENGTH/2]);
    den = 0.35;
    A_core(A_core>den) = 1;% freee space
    A_core(A_core<den) = 0;% obstacle

    X_Value_Parameter_aWayInTheEnveronment_alongTheXAxis = fix(LENGTH/8)+1;
    Y_Value_Parameter_aWayInTheEnveronment_alongTheYAxis = fix(LENGTH/8)+1;
    X_Value_Parameter_aWayInTheEnveronment_alongTheNegXAxis = fix((LENGTH*3)/8+1);
    Y_Value_Parameter_aWayInTheEnveronment_alongTheNegYAxis = fix((LENGTH*3)/8+1);
    
    Random_Of_The_length = abs(fix(random('Normal',1,LENGTH/20)));

    for i = Y_Value_Parameter_aWayInTheEnveronment_alongTheYAxis+Random_Of_The_length
        for j = (X_Value_Parameter_aWayInTheEnveronment_alongTheXAxis+Random_Of_The_length):...
                1:(X_Value_Parameter_aWayInTheEnveronment_alongTheNegXAxis-Random_Of_The_length)
            A_core(i,j) = 1;
        end
    end
    
    for i = Y_Value_Parameter_aWayInTheEnveronment_alongTheNegYAxis+Random_Of_The_length
        for j = (X_Value_Parameter_aWayInTheEnveronment_alongTheXAxis+Random_Of_The_length):...
                1:(X_Value_Parameter_aWayInTheEnveronment_alongTheNegXAxis-Random_Of_The_length)
            A_core(i,j) = 1;
        end
    end
    
    for i = (X_Value_Parameter_aWayInTheEnveronment_alongTheXAxis+Random_Of_The_length)
        for j = (Y_Value_Parameter_aWayInTheEnveronment_alongTheYAxis+Random_Of_The_length):1:...
                (Y_Value_Parameter_aWayInTheEnveronment_alongTheNegYAxis-Random_Of_The_length)
            A_core(i,j) = 1;
        end
    end
    
    for i = (X_Value_Parameter_aWayInTheEnveronment_alongTheNegXAxis-Random_Of_The_length)
        for j = (Y_Value_Parameter_aWayInTheEnveronment_alongTheYAxis+Random_Of_The_length):1:...
                (Y_Value_Parameter_aWayInTheEnveronment_alongTheNegYAxis-Random_Of_The_length)
            A_core(i,j) = 1;
        end
    end

    B = A_core;
    %B = Map;
    B(end+1,end+1) = 0;
    
    colormap([0 0 0;1 1 1]);  % color
    pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
    set(gca,'XTick',0:5:size(A_core,2),'YTIck',0:5:size(A_core,1)); 
    axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
    xlabel('X-axis');
    ylabel('Y-axis');

    %tic

    kn = ones(2);
    A = kron(A_core,kn);


    for i = 1:LENGTH
        for j = 1:LENGTH
            k_x = i;
            k_y = j;
                if A_core(k_x,k_y) == 1
                    start_p = [k_x;k_y];

                    start_p_ini = start_p;

                    if A_core(start_p(2),start_p(1))==1
                        'good';
                    end
                    K = zeros(LENGTH/2); % Input
                    for j=1:LENGTH/2
                        for i=1:LENGTH/2
                            if A_core(j,i)==1
                                K(j,i) = 1;
                            end
                        end
                    end
                    
                    K_for_remove_unreachable_re = K;
                    
                    dir_module_1 = [0 1 0 -1;1 0 -1 0]; % up right down left / Chinese:shang you xia zuo 
                    dir_module_2 = [-1 0 1 0;0 1 0 -1]; % 
                    dir_module_3 = [1 0 -1 0;0 -1 0 1]; % 
                    dir_module_4 = [0 1 0 -1;1 0 -1 0]; %
                    dir_module_5 = [0 1 0 -1;1 0 -1 0]; %


                    % STC Function Part Begins
                    Total_num = sum(sum(K));
                    T = zeros(LENGTH/2);
                    num = 1;
                    T(start_p(2),start_p(1)) = num;
                    curr_p = ones(2,1);

                    for d=dir_module_1
                        tem_p = start_p + d;
                        if tem_p(1)<=0||tem_p(1)>LENGTH/2||tem_p(2)<=0||tem_p(2)>LENGTH/2
                            continue;
                        end
                        if K(tem_p(2),tem_p(1))==1
                            %line([tem_p(1),start_p(1)],[tem_p(2),start_p(2)],'Color','r','LineWidth',5)
                            line([tem_p(1),start_p(1)],[tem_p(2),start_p(2)],'Color','r','LineWidth',3)

                            openList_STC(1,:) = {[start_p(1),start_p(2)],[tem_p(1),tem_p(2)]};
                            curr_p = tem_p;
                            num = num + 1;
                            T(tem_p(2),tem_p(1)) = num;
                            break;
                        end
                    end

                    step_num = 0;
                    iteration_of_STC_without_increase = 0;


                    while num~=Total_num
                        % num
                        % move to free space
                        step_num = step_num +1 ;  
                        fprintf('Computing......            iteration_of_STC_without_increase = %d          ', iteration_of_STC_without_increase);
                        fprintf('Computing......  \n');
                        fprintf('step_num = %d\n' , step_num);
                        fprintf('num = %d    ' , num);
                        fprintf('MapSize = %d * ' , LENGTH);
                        fprintf('%d    ' , LENGTH);
                        fprintf('Total_num = %d\n' , Total_num);
                        fprintf('curr_p : %d' , curr_p(1,1));
                        fprintf(', %d \n' , curr_p(2,1));
                        fprintf('tem_p  : %d' , tem_p(1,1));
                        fprintf(', %d \n' , tem_p(2,1));
                        
                        move = 0;
                        for d=dir_module_1
                            tem_p = curr_p + d;
                            if tem_p(1)<=0||tem_p(1)>LENGTH/2||tem_p(2)<=0||tem_p(2)>LENGTH/2
                                continue; 
                            end
                            if K(tem_p(2),tem_p(1))==1 && T(tem_p(2),tem_p(1))==0 % bug 
                                line([tem_p(1),curr_p(1)],[tem_p(2),curr_p(2)],'Color','r','LineWidth',3)
                                

                                openList_STC( num , : ) = {[curr_p(1),curr_p(2)],[tem_p(1),tem_p(2)]};
                                curr_p = tem_p;
                                num = num + 1;
                                T(tem_p(2),tem_p(1)) = num;
                                move = 1;
                                break;
                            end
                        end
                    
                        if move==0
                            for d=dir_module_2
                                tem_p = curr_p + d;
                                if tem_p(1)<=0||tem_p(1)>LENGTH/2||tem_p(2)<=0||tem_p(2)>LENGTH/2
                                    continue; 
                                end
                                if K(tem_p(2),tem_p(1))==1 && T(tem_p(2),tem_p(1))==0
                                line([tem_p(1),curr_p(1)],[tem_p(2),curr_p(2)],'Color','r','LineWidth',3)
                                

                                openList_STC( num , : ) = {[curr_p(1),curr_p(2)],[tem_p(1),tem_p(2)]};
                                curr_p = tem_p;
                                num = num + 1;
                                T(tem_p(2),tem_p(1)) = num;
                                move = 1;
                                break;
                                end
                            end
                        end
                    
                        if move==0
                            for d=dir_module_3
                                tem_p = curr_p + d;
                                if tem_p(1)<=0||tem_p(1)>LENGTH/2||tem_p(2)<=0||tem_p(2)>LENGTH/2
                                    continue; 
                                end
                                if K(tem_p(2),tem_p(1))==1 && T(tem_p(2),tem_p(1))==0
                                line([tem_p(1),curr_p(1)],[tem_p(2),curr_p(2)],'Color','r','LineWidth',3)

                                openList_STC( num , : ) = {[curr_p(1),curr_p(2)],[tem_p(1),tem_p(2)]};
                                curr_p = tem_p;
                                num = num + 1;
                                T(tem_p(2),tem_p(1)) = num;
                                move = 1;
                                break;
                                end
                            end
                        end
                    
                        % 
                        if move==1
                            iteration_of_STC_without_increase = 0;
                            continue;
                        end
                        % back to an old cell
                
                        if move==0
                        iteration_of_STC_without_increase=iteration_of_STC_without_increase+1;
                        end

                        curr_p_index_of_T = T(curr_p(2),curr_p(1));
                        need_to_be_back_of = T(curr_p(2,1),curr_p(1,1))-1;
                        if need_to_be_back_of>0
                    
                        for i=1:(LENGTH/2)
                            tem_p = [0;0];
                            tem_p(1,1) = i;
                            for j=1:(LENGTH/2)
                                tem_p(2,1) = j;
                                if T(tem_p(2,1),tem_p(1,1)) == need_to_be_back_of
                                    curr_p = tem_p;
                                   
                                break;
                                end
                            end
                        end
                        end

                        if iteration_of_STC_without_increase == ((LENGTH/2) *(LENGTH/2))
                        iteration_of_STC_without_increase=0;
                        break
                        end
                    end
                    %STC Function ends

                        fprintf('step_num = %d\n' , step_num);
                        fprintf('num = %d    ' , num);
                        fprintf('MapSize = %d * ' , LENGTH);
                        fprintf('%d    ' , LENGTH);
                        fprintf('Total_num = %d\n' , Total_num);
                        fprintf('End  \n');
                        fprintf('  \n');
                        fprintf('  \n');
                    
                        %figure(1)
                        colormap([0 0 0;1 1 1]);  % color
                        pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
                        set(gca,'XTick',0:5:size(A_core,2),'YTIck',0:5:size(A_core,1)); 
                        axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
                        xlabel('X-axis');
                        ylabel('Y-axis');

                        for i=1:num-1  
                        line([openList_STC{i,2}(1),openList_STC{i,1}(1)],[openList_STC{i,2}(2),openList_STC{i,1}(2)],'Color','r','LineWidth',3)
                        end
                    
                        toc
                    
                        K_for_remove_unreachable = ones(LENGTH/2); % Input
                        
                        for j=1:LENGTH/2
                            for i=1:LENGTH/2
                                if K_for_remove_unreachable_re(j,i)==0
                                    K_for_remove_unreachable(j,i) = 0;
                                end
                            end
                        end
                        
                        for j=1:LENGTH/2
                            for i=1:LENGTH/2
                                if T(j,i)==0
                                    K_for_remove_unreachable(j,i) = 0;
                                end
                            end
                        end
                        
                        repaired_K = ones(LENGTH/2);
                        Total_num_for_remove_unreachable = sum(sum(K_for_remove_unreachable));
                    
                    
                        B_repiared = K_for_remove_unreachable;
                        B_repiared(end+1,end+1) = 0;
                        Sum_of_B_repiared_for_start = sum(sum(B_repiared));
                        
                        colormap([0 0 0;1 1 1]);  % color
                        pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B_repiared); % grid color
                        set(gca,'XTick',0:5:size(A_core,2),'YTIck',0:5:size(A_core,1)); 
                        axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
                        xlabel('X-axis');
                        ylabel('Y-axis');

                end

                if Sum_of_B_repiared_for_start >= Random_environment_coverage_area_threshold
                    break
                end
        end
        if Sum_of_B_repiared_for_start >= Random_environment_coverage_area_threshold
            break
        end

    end

%%  part 2 (Figure 2) DARP initial with Original Iteration Method
    figure(2);
    tic 
    
    itp = Iteration_number_parameter_setting;  % the min value is "2" and must be even
    ini_iteration_count_for_initial_point = itp * ROBOT_NUM;  % the step number of the initial point alteration
    init_pos_candidate_point_matrix = unifrnd(1,LENGTH,[ROBOT_NUM,ini_iteration_count_for_initial_point]);

    init_grid_for_iteration = round(init_pos_candidate_point_matrix/2); % Initial random start point
    % "round" can get the nearest smaller integer 

    % Initial Algorithm parameters used
    % The basic data structure of each parameter should be determined here
    M_input_P = 0;
    max_K = 0;
    MAP = K_for_remove_unreachable ; % Environment input

    core = MAP;
    Core_flag = core;


    piont_1_for_DARP_initial=[init_grid_for_iteration(1,ROBOT_NUM*3-1),init_grid_for_iteration(1,ROBOT_NUM*3)];
    piont_2_for_DARP_initial=[init_grid_for_iteration(2,ROBOT_NUM*3-1),init_grid_for_iteration(2,ROBOT_NUM*3)];
    piont_3_for_DARP_initial=[init_grid_for_iteration(3,ROBOT_NUM*3-1),init_grid_for_iteration(3,ROBOT_NUM*3)];
    piont_4_for_DARP_initial=[init_grid_for_iteration(4,ROBOT_NUM*3-1),init_grid_for_iteration(4,ROBOT_NUM*3)];
    piont_5_for_DARP_initial=[init_grid_for_iteration(5,ROBOT_NUM*3-1),init_grid_for_iteration(5,ROBOT_NUM*3)];
    piont_6_for_DARP_initial=[init_grid_for_iteration(6,ROBOT_NUM*3-1),init_grid_for_iteration(6,ROBOT_NUM*3)];
    piont_7_for_DARP_initial=[init_grid_for_iteration(7,ROBOT_NUM*3-1),init_grid_for_iteration(7,ROBOT_NUM*3)];
    piont_8_for_DARP_initial=[init_grid_for_iteration(8,ROBOT_NUM*3-1),init_grid_for_iteration(8,ROBOT_NUM*3)];


    init_grid_for_DARP_initial(1,:)=piont_1_for_DARP_initial;
    init_grid_for_DARP_initial(2,:)=piont_2_for_DARP_initial;
    init_grid_for_DARP_initial(3,:)=piont_3_for_DARP_initial;
    init_grid_for_DARP_initial(4,:)=piont_4_for_DARP_initial;
    init_grid_for_DARP_initial(5,:)=piont_5_for_DARP_initial;
    init_grid_for_DARP_initial(6,:)=piont_6_for_DARP_initial;
    init_grid_for_DARP_initial(7,:)=piont_7_for_DARP_initial;
    init_grid_for_DARP_initial(8,:)=piont_8_for_DARP_initial;
    init_pos= init_grid_for_DARP_initial;


    parameter_of_threshold_for_DARP_initial = 0;
    parameter_of_iterations_for_DARP_initial = 0;
    parameter_of_transfer_for_DARP_initial = 0;


    % The corresponding functions need to be modified at the same time 
    A_rst = divide_area_for_Darp_HPO_for_robn_for_DARP_initial( Core_flag, ...
        init_pos, ROBOT_NUM,parameter_of_threshold_for_DARP_initial,...
        parameter_of_iterations_for_DARP_initial,parameter_of_transfer_for_DARP_initial);
    


    figure(2);

    handle2 = display_area(A_rst,ROBOT_NUM,2); % Explicitly display the current environment
    for i=1:ROBOT_NUM  % Explicit robots position
        rectangle(gca,'Position',[init_pos(i,1)-0.25,init_pos(i,2)-0.25,0.5,0.5],'Curvature',1,'FaceColor',[1 0 0],'EdgeColor','k');
    end



%%  part 3 (Figure 3) DARP with HPO (Updated in November 14, 2024)
    figure(3);


    init_pos_list_for_backup = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

    init_pos_list_for_backup_for_compare = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    repeat_flag = 0;

    optimal_M_value_ref = (Sum_of_B_repiared_for_start/ROBOT_NUM);
    deviation_value_ref = ((LENGTH*LENGTH)/4-optimal_M_value_ref)/optimal_M_value_ref;

for itp_al = 1:1:(itp)


    piont_1=[init_grid_for_iteration(1,ROBOT_NUM*itp_al-1),init_grid_for_iteration(1,ROBOT_NUM*itp_al)];
    piont_2=[init_grid_for_iteration(2,ROBOT_NUM*itp_al-1),init_grid_for_iteration(2,ROBOT_NUM*itp_al)];
    piont_3=[init_grid_for_iteration(3,ROBOT_NUM*itp_al-1),init_grid_for_iteration(3,ROBOT_NUM*itp_al)];
    piont_4=[init_grid_for_iteration(4,ROBOT_NUM*itp_al-1),init_grid_for_iteration(4,ROBOT_NUM*itp_al)];
    piont_5=[init_grid_for_iteration(5,ROBOT_NUM*itp_al-1),init_grid_for_iteration(5,ROBOT_NUM*itp_al)];
    piont_6=[init_grid_for_iteration(6,ROBOT_NUM*itp_al-1),init_grid_for_iteration(6,ROBOT_NUM*itp_al)];
    piont_7=[init_grid_for_iteration(7,ROBOT_NUM*itp_al-1),init_grid_for_iteration(7,ROBOT_NUM*itp_al)];
    piont_8=[init_grid_for_iteration(8,ROBOT_NUM*itp_al-1),init_grid_for_iteration(8,ROBOT_NUM*itp_al)];

    init_grid(1,:)=piont_1;
    init_grid(2,:)=piont_2;
    init_grid(3,:)=piont_3;
    init_grid(4,:)=piont_4;
    init_grid(5,:)=piont_5;
    init_grid(6,:)=piont_6;
    init_grid(7,:)=piont_7;
    init_grid(8,:)=piont_8;
    init_pos= init_grid;
    

    init_pos_parameter_part_1 = piont_1(1);
    init_pos_parameter_part_2 = piont_1(2);
    init_pos_parameter_part_3 = piont_2(1);
    init_pos_parameter_part_4 = piont_2(2);
    init_pos_parameter_part_5 = piont_3(1);
    init_pos_parameter_part_6 = piont_3(2);
    init_pos_parameter_part_7 = piont_4(1);
    init_pos_parameter_part_8 = piont_4(2);
    init_pos_parameter_part_9 = piont_5(1);
    init_pos_parameter_part_10 = piont_5(2);
    init_pos_parameter_part_11 = piont_6(1);
    init_pos_parameter_part_12 = piont_6(2);
    init_pos_parameter_part_13 = piont_7(1);
    init_pos_parameter_part_14 = piont_7(2);
    init_pos_parameter_part_15 = piont_8(1);
    init_pos_parameter_part_16 = piont_8(2);


    repeat_flag = 0;


    init_pos_list_for_backup_for_compare = [init_pos_parameter_part_1,init_pos_parameter_part_2,...
    init_pos_parameter_part_3,init_pos_parameter_part_4...
    ,init_pos_parameter_part_5,init_pos_parameter_part_6,...
    init_pos_parameter_part_7,init_pos_parameter_part_8,...
    init_pos_parameter_part_9,init_pos_parameter_part_10,...
    init_pos_parameter_part_11,init_pos_parameter_part_12,...
    init_pos_parameter_part_13,init_pos_parameter_part_14,...
    init_pos_parameter_part_15,init_pos_parameter_part_16];

    repeat_root_func_pare_of_compare_list_size = size(init_pos_list_for_backup,1);


    for i = 1:1:repeat_root_func_pare_of_compare_list_size
        parameter_to_be_compare = init_pos_list_for_backup(i,:);
        parameter_to_be_compare_1 = parameter_to_be_compare(1);
        parameter_to_be_compare_2 = parameter_to_be_compare(2);
        parameter_to_be_compare_3 = parameter_to_be_compare(3);
        parameter_to_be_compare_4 = parameter_to_be_compare(4);
        parameter_to_be_compare_5 = parameter_to_be_compare(5);
        parameter_to_be_compare_6 = parameter_to_be_compare(6);
        parameter_to_be_compare_7 = parameter_to_be_compare(7);
        parameter_to_be_compare_8 = parameter_to_be_compare(8);
        parameter_to_be_compare_9 = parameter_to_be_compare(9);
        parameter_to_be_compare_10 = parameter_to_be_compare(10);
        parameter_to_be_compare_11 = parameter_to_be_compare(11);
        parameter_to_be_compare_12 = parameter_to_be_compare(12);
        parameter_to_be_compare_13 = parameter_to_be_compare(13);
        parameter_to_be_compare_14 = parameter_to_be_compare(14);
        parameter_to_be_compare_15 = parameter_to_be_compare(15);
        parameter_to_be_compare_16 = parameter_to_be_compare(16);


        if (init_pos_parameter_part_1 == parameter_to_be_compare_1) && (init_pos_parameter_part_2 == parameter_to_be_compare_2) &&...
            (init_pos_parameter_part_3 == parameter_to_be_compare_3) && ...
            (init_pos_parameter_part_4 == parameter_to_be_compare_4) && (init_pos_parameter_part_5 == parameter_to_be_compare_5) &&...
            (init_pos_parameter_part_6 == parameter_to_be_compare_6) && ...
            (init_pos_parameter_part_7 == parameter_to_be_compare_7) && (init_pos_parameter_part_8 == parameter_to_be_compare_8) &&...
            (init_pos_parameter_part_9 == parameter_to_be_compare_9) && (init_pos_parameter_part_10 == parameter_to_be_compare_10) &&...
            (init_pos_parameter_part_11 == parameter_to_be_compare_11) && (init_pos_parameter_part_12 == parameter_to_be_compare_12) &&...
            (init_pos_parameter_part_13 == parameter_to_be_compare_13) && (init_pos_parameter_part_14 == parameter_to_be_compare_14) &&...
            (init_pos_parameter_part_15 == parameter_to_be_compare_15) && (init_pos_parameter_part_16 == parameter_to_be_compare_16) 
            repeat_flag = 1;
        end
    end

    if repeat_flag == 1
        continue
    end

    init_pos_list_for_backup(end+1,:) = [init_pos_parameter_part_1,init_pos_parameter_part_2,...
    init_pos_parameter_part_3,init_pos_parameter_part_4,...
    init_pos_parameter_part_5,init_pos_parameter_part_6,...
    init_pos_parameter_part_7,init_pos_parameter_part_8,...
    init_pos_parameter_part_9,init_pos_parameter_part_10,...
    init_pos_parameter_part_11,init_pos_parameter_part_12,...
    init_pos_parameter_part_13,init_pos_parameter_part_14,...
    init_pos_parameter_part_15,init_pos_parameter_part_16];


    
    parameter_of_threshold = 0.02;
    parameter_of_iterations = 0;
    parameter_of_transfer = 0;
    parameter_of_current_maximum_deviation_value = deviation_value_ref;
    parameter_of_iterations_for_divide = 0;
    parameter_of_iterations_for_divide = itp_al ; 
    parameter_of_M_used_for_monitoring = 0;
    parameter_of_M_used_for_monitoring = min_current_M;


    parameter_0001 = Sum_of_B_repiared_for_start;
    parameter_0002 = Optimal_M_input;

    

    A_rst = divide_area_for_Darp_HPO_for_rob8( Core_flag,init_grid,ROBOT_NUM,...
    parameter_of_threshold,parameter_of_iterations,parameter_of_transfer,...
    parameter_of_current_maximum_deviation_value,...
    parameter_of_iterations_for_divide,parameter_of_M_used_for_monitoring,...
    parameter_0001,parameter_0002);
    

    figure(3);

    handle2 = display_area(A_rst,ROBOT_NUM,2); % Explicitly display the current environment

    % initial parameter for Calculate the result of the distribution
    
        STC_MAP_REF = A_rst;  % Assign the reference map to the segmented map
        Size_for_statistics = LENGTH/2;
        

        K_for_rob_1 = ones(Size_for_statistics);
        K_for_rob_2 = ones(Size_for_statistics);
        K_for_rob_3 = ones(Size_for_statistics);
        K_for_rob_4 = ones(Size_for_statistics);
        K_for_rob_5 = ones(Size_for_statistics);
        K_for_rob_6 = ones(Size_for_statistics);
        K_for_rob_7 = ones(Size_for_statistics);
        K_for_rob_8 = ones(Size_for_statistics);

    

    for j=1:Size_for_statistics
        for i=1:Size_for_statistics
            if STC_MAP_REF(j,i)==1
                K_for_rob_1(j,i) = 1;
            end
            if STC_MAP_REF(j,i)~=1
                K_for_rob_1(j,i) = 0;
            end
        end
    end
    
    for j=1:Size_for_statistics
        for i=1:Size_for_statistics
            if STC_MAP_REF(j,i)==2
                K_for_rob_2(j,i) = 1;
            end
            if STC_MAP_REF(j,i)~=2
                K_for_rob_2(j,i) = 0;
            end
        end
    end
    
    for j=1:Size_for_statistics
        for i=1:Size_for_statistics
            if STC_MAP_REF(j,i)==3
                K_for_rob_3(j,i) = 1;
            end
            if STC_MAP_REF(j,i)~=3
                K_for_rob_3(j,i) = 0;
            end
        end
    end

    for j=1:Size_for_statistics
        for i=1:Size_for_statistics
            if STC_MAP_REF(j,i)==4
                K_for_rob_4(j,i) = 1;
            end
            if STC_MAP_REF(j,i)~=4
                K_for_rob_4(j,i) = 0;
            end
        end
    end

    for j=1:Size_for_statistics
        for i=1:Size_for_statistics
            if STC_MAP_REF(j,i)==5
                K_for_rob_5(j,i) = 1;
            end
            if STC_MAP_REF(j,i)~=5
                K_for_rob_5(j,i) = 0;
            end
        end
    end

    for j=1:Size_for_statistics
        for i=1:Size_for_statistics
            if STC_MAP_REF(j,i)==6
                K_for_rob_6(j,i) = 1;
            end
            if STC_MAP_REF(j,i)~=6
                K_for_rob_6(j,i) = 0;
            end
        end
    end

    for j=1:Size_for_statistics
        for i=1:Size_for_statistics
            if STC_MAP_REF(j,i)==7
                K_for_rob_7(j,i) = 1;
            end
            if STC_MAP_REF(j,i)~=7
                K_for_rob_7(j,i) = 0;
            end
        end
    end

    for j=1:Size_for_statistics
        for i=1:Size_for_statistics
            if STC_MAP_REF(j,i)==8
                K_for_rob_8(j,i) = 1;
            end
            if STC_MAP_REF(j,i)~=8
                K_for_rob_8(j,i) = 0;
            end
        end
    end


    SUM_K1 = sum(sum(K_for_rob_1)) ;
    SUM_K2 = sum(sum(K_for_rob_2)) ;
    SUM_K3 = sum(sum(K_for_rob_3)) ;
    SUM_K4 = sum(sum(K_for_rob_4)) ;
    SUM_K5 = sum(sum(K_for_rob_5)) ;
    SUM_K6 = sum(sum(K_for_rob_6)) ;
    SUM_K7 = sum(sum(K_for_rob_7)) ;
    SUM_K8 = sum(sum(K_for_rob_8)) ;

    

    Optimal_M_input = (SUM_K1+SUM_K2+SUM_K3+SUM_K4+SUM_K5+SUM_K6+SUM_K7+SUM_K8)/ROBOT_NUM;
    
    System_work = [SUM_K1;SUM_K2;SUM_K3;SUM_K4;SUM_K5;SUM_K6;SUM_K7;SUM_K8] ; 
    
    Size_of_system = size(System_work,1);

    calculation_time = toc ; 

    if Size_of_system >= ROBOT_NUM

        max_K = max(System_work);                     % The maximum number of grids map to the current solution
        M_input = max_K;
        M_input_P(end+1,:) = M_input;
        fprintf('Max_M = %d' , max_K);
        fprintf('......');
        times = toc;
        fprintf('time = %d' , calculation_time);
        fprintf('\n');
        
        x_of_M_list=1:1:size(M_input_P,1);
        y_of_M_list=M_input_P;
    end

    Num_of_min_current_M_ref = 0;
    if itp_al >= 2
        Num_of_min_current_M_ref = size(M_input_P);
        for i=1:1:(Num_of_min_current_M_ref-1)
            Num_of_min_current_M(i,:) = M_input_P(i+1,:);
        end
        min_current_M = min(Num_of_min_current_M);    % The current optimal solution
        fprintf('...The algorithm is running...The algorithm is running...');
        fprintf('\n');
        fprintf('Min_M = %d' , min_current_M);
        fprintf('\n');
    end

    %%  part 4 (Figure 4) The update process of DARP is being updated in real time
    %   This part of the picture is updated in Function 'divide_area_for_Darp_HPO_for_rob3' 
    figure(4)


    %%  part 5 (Figure 5) The best approximate solution currently obtained
    %   Only consider the minimum value assigned by DARP to a certain maximum operating area(Grid-map-number)

    figure(5)
    max_K_current = max_K;

    if itp_al >= 2 % 
        if max_K_current <= min_current_M % 
            figure(5)
            handle2 = display_area(A_rst,ROBOT_NUM,2); % Explicitly display the current environment

            optimalSolutionMatrix = A_rst;
            optimalSolutionRoots = init_pos;
            optimalSolutionDecomposition = [SUM_K1;SUM_K2;SUM_K3;SUM_K4;SUM_K5] ;

            reference_map_1 = K_for_rob_1;
            reference_map_2 = K_for_rob_2;
            reference_map_3 = K_for_rob_3;
            reference_map_4 = K_for_rob_4;
            reference_map_5 = K_for_rob_5;
            reference_map_6 = K_for_rob_6;
            reference_map_7 = K_for_rob_7;
            reference_map_8 = K_for_rob_8;
        end
    end


    %%  part 6 (Figure 6) Overall convergence of solution obtained by DARP
    %   
    figure(6)

    if itp_al >= 2 % 

        x_of_M_input = size(Num_of_min_current_M,1);
        y_of_M_input = Num_of_min_current_M;

        x_of_M_input_list = 1:1:x_of_M_input;
        y_of_M_input_list = y_of_M_input;
        figure(6)
        set(gca,'XTick',1:10:size(x_of_M_input,1),'YTIck',1:10:size(x_of_M_input,1)); % set coordinate
        axis image xy;
        xlabel('Iteration steps');
        ylabel('Maximum area');

        plot(x_of_M_input_list,y_of_M_input_list);

    end
end

final_calculation_time = toc; 