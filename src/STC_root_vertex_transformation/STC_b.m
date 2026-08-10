% This project uses the following third-party code: 
% https://github.com/Wei-Fan
% Use MIT license
% Thanks to Weifan_Zhang for the excellent code implementation.

clc;
clear;
LENGTH = 80; 

 f1=figure(1);
 set(gcf, 'unit', 'centimeters', 'position', [1 15 13 10],'Name','Optimization in progress'); 
 f2=figure(2);
 set(gcf, 'unit', 'centimeters', 'position', [14 15 13 10],'Name','min'); 
 f3=figure(3);
 set(gcf, 'unit', 'centimeters', 'position', [27 15 13 10],'Name','max');
 f4=figure(4);
 set(gcf, 'unit', 'centimeters', 'position', [1 1 13 10]);   
 f5=figure(5);  
 set(gcf, 'unit', 'centimeters', 'position', [14 1 13 10]);  
 f6=figure(6);
 set(gcf, 'unit', 'centimeters', 'position', [27 1 13 10]);   

%--------------------------------------------------------------------------------------------------------------------
figure(1)


rng(30,'twister');
A_core = unifrnd(0,1,[LENGTH/2,LENGTH/2]);
den = 0.05;
A_core(A_core>den) = 1;
A_core(A_core<den) = 0;

MAP = OB_grid_map_12_for_paper1_80 ;

A_core = MAP;

B = A_core;
B(end+1,end+1) = 0;

colormap([0 0 0;1 1 1]);  % color
pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
set(gca,'XTick',0:10:size(A_core,2),'YTIck',0:10:size(A_core,1)); 
axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.

%---------------------------------------------------------------------------------------------------------------------
tic

kn = ones(2);
A = kron(A_core,kn);

without_turn_num_data_(1 ,:) = {[1,1],[1,1],[1,1],[1,1]};
without_turn_num_min = 0;
without_turn_num_max = 0;
whole_step_num = 1;
The_STC_Whole_Step_num =0;
The_STC_Whole_Step_num_permitted_range = 1000;
y_of_figure4=[1,1];
y_of_figure5=[1,1];
y_of_figure6=[1,1];

K = zeros(LENGTH/2); % Input
for j=1:LENGTH/2
    for i=1:LENGTH/2
        if A_core(j,i)==1
            K(j,i) = 1;
        end
    end
end



dir_module_0 = [0 1 0 -1;1 0 -1 0];
dir_module_1 = [0 1 0 -1;1 0 -1 0];
dir_module_2 = [-1 0 1 0;0 1 0 -1];
dir_module_3 = [1 0 -1 0;0 -1 0 1];
dir_module_4 = [0 -1 0 1;1 0 -1 0];
dir_module_5 = [0 1 0 -1;1 0 -1 0];

Total_num = sum(sum(K));
search_mode = 0;
without_turn_num = 1;


for i_2 = 1:4
    search_mode = i_2;
    if search_mode == 1
        dir_module = dir_module_1;
    end
    if search_mode == 2
        dir_module = dir_module_2;
    end
    if search_mode == 3
        dir_module = dir_module_3;
    end
    if search_mode == 4
        dir_module = dir_module_4;
    end

threshold_value = 0; 

for i_1 = 1:LENGTH/2
    for j_1 = 1:1:LENGTH/2
        start_p_x_reforce = j_1;
        start_p_y_reforce = i_1;
        start_p = [start_p_x_reforce;start_p_y_reforce];
        %
        if K(start_p_x_reforce,start_p_y_reforce) == 1 && (threshold_value <= 20 )
        whole_step_num = whole_step_num + 1;

T = zeros(LENGTH/2);
num = 1;
T(start_p(2),start_p(1)) = num;
curr_p = ones(2,1);
for d=dir_module
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
display_num_ = 0;
display_num_for_pic_1 =0;

while num~=Total_num
    % move to free space
    
    step_num = step_num +1 ;

    display_num_ = display_num_ +1;%
    display_num_for_pic_1 = display_num_for_pic_1 + 1;

    if display_num_ == 1000
        display_num_ = 0 ;
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
 
    end
    
    move = 0;
    for d=dir_module
        tem_p = curr_p + d;
        if tem_p(1)<=0||tem_p(1)>LENGTH/2||tem_p(2)<=0||tem_p(2)>LENGTH/2
            continue; 
        end
        if K(tem_p(2),tem_p(1))==1 && T(tem_p(2),tem_p(1))==0 
            %line([tem_p(1),curr_p(1)],[tem_p(2),curr_p(2)],'Color','r','LineWidth',3)
            openList_STC( num , : ) = {[curr_p(1),curr_p(2)],[tem_p(1),tem_p(2)]};
            curr_p = tem_p;
            num = num + 1;
            T(tem_p(2),tem_p(1)) = num;
            move = 1;
            break;
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
       %fprintf('backtracking......  \n');
   

    need_to_be_back_of = T(curr_p(2,1),curr_p(1,1))-1;
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
   % end


    end

    if iteration_of_STC_without_increase == ((LENGTH/2) *(LENGTH/2))
       iteration_of_STC_without_increase=0;
       break
    end





end


    fprintf('step_num = %d\n' , step_num);
    fprintf('num = %d    ' , num);
    fprintf('MapSize = %d * ' , LENGTH);
    fprintf('%d    ' , LENGTH);
    fprintf('Total_num = %d\n' , Total_num);
    fprintf('    whole_step_num = %d\n' , whole_step_num);
    %fprintf('End  \n');
    %fprintf('  \n');
    %fprintf('  \n');
    fprintf('max_number = %d            ' , without_turn_num_max);
    %fprintf('  \n');
    fprintf('min_number = %d    ' , without_turn_num_min);
    fprintf('search mode   = %d    ' , search_mode);



toc

    without_turn_num  = 0;
    for turn_num_cir = (1:size(openList_STC,1)-1)
        if openList_STC{turn_num_cir,2}(1)-openList_STC{turn_num_cir,1}(1) == openList_STC{turn_num_cir+1,2}(1)-openList_STC{turn_num_cir+1,1}(1)...
                && openList_STC{turn_num_cir,2}(2)-openList_STC{turn_num_cir,1}(2) == openList_STC{turn_num_cir+1,2}(2)-openList_STC{turn_num_cir+1,1}(2) 
        without_turn_num = without_turn_num+1;
        end
    end

    if whole_step_num  == 2 
        openList_STC_min_turn = openList_STC;
        openList_STC_max_turn = openList_STC;
        without_turn_num_max = without_turn_num;
        without_turn_num_min = without_turn_num;
        figure(1)
        colormap([0 0 0;1 1 1]);  % color
        pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
        set(gca,'XTick',0:10:size(A_core,2),'YTIck',0:10:size(A_core,1)); 
        axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
        xlabel('X');
        ylabel('Y');
    
        for i=1:num-1  
            line([openList_STC{i,2}(1),openList_STC{i,1}(1)],[openList_STC{i,2}(2),openList_STC{i,1}(2)],'Color','r','LineWidth',3)
        end

        figure(2)
        colormap([0 0 0;1 1 1]);  % color
        pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
        set(gca,'XTick',0:10:size(A_core,2),'YTIck',0:10:size(A_core,1)); 
        axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
        xlabel('X');
        ylabel('Y');
    
        for i=1:num-1  
            line([openList_STC{i,2}(1),openList_STC{i,1}(1)],[openList_STC{i,2}(2),openList_STC{i,1}(2)],'Color','r','LineWidth',3)
        end

        figure(3)
        colormap([0 0 0;1 1 1]);  % color
        pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
        set(gca,'XTick',0:10:size(A_core,2),'YTIck',0:10:size(A_core,1)); 
        axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
        xlabel('X');
        ylabel('Y');
    
        for i=1:num-1  
            line([openList_STC{i,2}(1),openList_STC{i,1}(1)],[openList_STC{i,2}(2),openList_STC{i,1}(2)],'Color','r','LineWidth',3)
        end
    end

    if without_turn_num > without_turn_num_max
        without_turn_num_max = without_turn_num;
        openList_STC_max_turn = openList_STC;

        figure(2)
        colormap([0 0 0;1 1 1]);  % color
        pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
        set(gca,'XTick',0:10:size(A_core,2),'YTIck',0:10:size(A_core,1)); 
        axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
        xlabel('X');
        ylabel('Y');
        for i=1:num-1  
              line([openList_STC_max_turn{i,2}(1),openList_STC_max_turn{i,1}(1)],[openList_STC_max_turn{i,2}(2),openList_STC_max_turn{i,1}(2)],'Color','r','LineWidth',3)
        end
    end

    if without_turn_num < without_turn_num_min
        without_turn_num_min = without_turn_num;
        openList_STC_min_turn = openList_STC;
    
        figure(3)
        colormap([0 0 0;1 1 1]);  % color
        pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
        set(gca,'XTick',0:10:size(A_core,2),'YTIck',0:10:size(A_core,1)); 
        axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
        xlabel('X');
        ylabel('Y');
        for i=1:num-1  
              line([openList_STC_min_turn{i,2}(1),openList_STC_min_turn{i,1}(1)],[openList_STC_min_turn{i,2}(2),openList_STC_min_turn{i,1}(2)],'Color','r','LineWidth',3)
        end
    
    end


    figure(1)
    colormap([0 0 0;1 1 1]);  % color
    pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
    set(gca,'XTick',0:10:size(A_core,2),'YTIck',0:10:size(A_core,1)); 
    axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
    xlabel('X');
    ylabel('Y');
    
    for i=1:num-1  
    line([openList_STC{i,2}(1),openList_STC{i,1}(1)],[openList_STC{i,2}(2),openList_STC{i,1}(2)],'Color','r','LineWidth',3)
    end

    figure(4)
    x_of_figure4 = 1:1:whole_step_num;
    y_of_figure4_ref = without_turn_num_max;
    y_of_figure4(1,whole_step_num) = y_of_figure4_ref;
    plot(x_of_figure4,y_of_figure4);

    figure(5)
    x_of_figure5 = 1:1:whole_step_num;
    y_of_figure5_ref = without_turn_num_min;
    y_of_figure5(1,whole_step_num) = y_of_figure5_ref;
    plot(x_of_figure5,y_of_figure5);

    figure(6)
    x_of_figure6 = 1:1:whole_step_num;
    y_of_figure6_ref = without_turn_num_min;
    plot(x_of_figure4,y_of_figure4,x_of_figure4,y_of_figure5);
        end
    without_turn_num_data_(whole_step_num ,:) = {[without_turn_num_max,1],[without_turn_num_min,1],[without_turn_num,1],[start_p(2),start_p(1)]};
    %
    threshold_value_without_turn_num_max = without_turn_num_max ;
    threshold_value_without_turn_num_min = without_turn_num_min ;
    threshold_value_without_turn_num = without_turn_num ;
    if whole_step_num <= 15
        threshold_value = 1;
    end
    if whole_step_num >= 15
        para_1 = 1;
        para_2 = 1;
        para_1_ref = 1;
        para_2_ref = 1;
        para_3_ref = 1;
        beta_para = 0;
        for i = (whole_step_num-10):whole_step_num
            without_turn_num_data_{i,1}(1) = para_1_ref;%max
            without_turn_num_data_{i,2}(1) = para_2_ref;%min
            without_turn_num = para_3_ref;%cur
            if para_1_ref >= para_3_ref
                beta_para = beta_para+1 ;
            end
        end
        threshold_value = beta_para; 
    end


    end

end


end

    fprintf('step_num = %d\n' , step_num);
    fprintf('num = %d    ' , num);
    fprintf('MapSize = %d * ' , LENGTH);
    fprintf('%d    ' , LENGTH);
    fprintf('Total_num = %d\n' , Total_num);
    fprintf('    whole_step_num = %d\n' , whole_step_num);
    fprintf('End  \n');
    %fprintf('  \n');
    %fprintf('  \n');
    fprintf('minturnnumber = %d            ' , without_turn_num_max);
    %fprintf('  \n');
    fprintf('maxturnnumber = %d    ' , without_turn_num_min);
    
