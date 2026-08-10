% This project uses the following third-party code: 
% https://github.com/Wei-Fan
% Use MIT license
% Thanks to Weifan_Zhang for the excellent code implementation.

clc;
clear;
LENGTH = 80; 

 f1=figure(1);
 set(gcf, 'unit', 'centimeters', 'position', [1 5 13 10],'Name','1');  % 
 f2=figure(2);
 set(gcf, 'unit', 'centimeters', 'position', [14 5 13 10],'Name','2'); 
 f3=figure(3);
 set(gcf, 'unit', 'centimeters', 'position', [27 5 13 10],'Name','STC solution');


%--------------------------------------------------------------------------------------------------------------------
f1=figure(1);
figure(1)
rng(30,'twister');
A_core = unifrnd(0,1,[LENGTH/2,LENGTH/2]);
den = 0.15;
A_core(A_core>den) = 1;% freee space
A_core(A_core<den) = 0;% obstacle

Map = OB_grid_map_01_for_paper1_80;



B = A_core;
B(end+1,end+1) = 0;

colormap([0 0 0;1 1 1]);  % color
pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
set(gca,'XTick',1:10:size(A_core,2),'YTIck',1:10:size(A_core,1)); 
axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.

%---------------------------------------------------------------------------------------------------------------------
tic

kn = ones(2);
A = kron(A_core,kn);


start_p = round(unifrnd(1,LENGTH/2,[2,1]));
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

dir_module_1 = [0 1 0 -1;1 0 -1 0];% 
dir_module_2 = [-1 0 1 0;0 1 0 -1];% 
dir_module_3 = [1 0 -1 0;0 -1 0 1];% 
dir_module_4 = [0 1 0 -1;1 0 -1 0];%
dir_module_5 = [0 1 0 -1;1 0 -1 0];%

Total_num = sum(sum(K));
T = zeros(LENGTH/2);
num = 1;
T(start_p(2),start_p(1)) = num;
curr_p = zeros(2,1);
for d=dir_module_1
    tem_p = start_p + d;
    if tem_p(1)<=0||tem_p(1)>LENGTH/2||tem_p(2)<=0||tem_p(2)>LENGTH/2
        continue;
    end
    if K(tem_p(2),tem_p(1))==1
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
        if K(tem_p(2),tem_p(1))==1 && T(tem_p(2),tem_p(1))==0 % bug 鎵?鍦?
            line([tem_p(1),curr_p(1)],[tem_p(2),curr_p(2)],'Color','r','LineWidth',3)
            
            % openList_STC( num , : ) = {[tem_p(1),start_p(1)],[tem_p(2),start_p(2)]};
            % openList_STC(1,:) = {[start_p(1),start_p(2)],[tem_p(1),tem_p(2)]};
            
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
    for i=1:(LENGTH/2)
        tem_p = [0;0];
        tem_p(1,1) = i;
        for j=1:(LENGTH/2)
             tem_p(2,1) = j;
             %if tem_p(1)<=0||tem_p(1)>LENGTH/2||tem_p(2)<=0||tem_p(2)>LENGTH/2
             %    continue;
             %end
            % if T(tem_p(2,1),tem_p(1,1)) == T(curr_p(2,1),curr_p(1,1))-1
             if T(tem_p(2,1),tem_p(1,1)) == need_to_be_back_of
                 curr_p = tem_p;
                 % openList_STC( num , : ) = {[curr_p(1),curr_p(2)],[tem_p(1),tem_p(2)]};
             break;
             end
        end
    end

   
    if iteration_of_STC_without_increase == ((LENGTH/2) *(LENGTH/2))
       iteration_of_STC_without_increase = 0;
       break

       %iteration_of_STC_without_increase=iteration_of_STC_without_increase+1;
    end





end





    fprintf('step_num = %d\n' , step_num);
    fprintf('num = %d    ' , num);
    fprintf('MapSize = %d * ' , LENGTH);
    fprintf('%d    ' , LENGTH);
    fprintf('Total_num = %d\n' , Total_num);
    fprintf('End  \n');
    fprintf('  \n');
    fprintf('  \n');

    figure(1)
    colormap([0 0 0;1 1 1]);  % color
    pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
    set(gca,'XTick',1:10:size(A_core,2),'YTIck',1:10:size(A_core,1)); 
    axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
    % openList_rob1_cost(i,:) = [g_rob1, h_rob1, f_rob1];
    xlabel('X');
    ylabel('Y');
    
    for i=1:num-1  
        %line([tem_p(1),curr_p(1)],[tem_p(2),curr_p(2)],'Color','r','LineWidth',2)
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

figure(2)
B_repiared = K_for_remove_unreachable;
B_repiared(end+1,end+1) = 0;

colormap([0 0 0;1 1 1]);  % color
pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B_repiared); % grid color
set(gca,'XTick',1:10:size(A_core,2),'YTIck',1:10:size(A_core,1)); 
axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.


%%
figure(3)
%Total_num_new = sum(sum(K));
Total_num_new =Total_num_for_remove_unreachable;
T_new = zeros(LENGTH/2);
num_new = 1;
start_p_new = start_p_ini;
T_new(start_p_new(2),start_p_new(1)) = num_new;

curr_p_new = zeros(2,1);
for d=dir_module_1
    tem_p_new = start_p_new + d;
    if tem_p_new(1)<=0||tem_p_new(1)>LENGTH/2||tem_p_new(2)<=0||tem_p_new(2)>LENGTH/2
        continue;
    end
    if K_for_remove_unreachable(tem_p_new(2),tem_p_new(1))==1
        %line([tem_p_new(1),start_p(1)],[tem_p_new(2),start_p(2)],'Color','r','LineWidth',5)
        line([tem_p_new(1),start_p(1)],[tem_p_new(2),start_p(2)],'Color','r','LineWidth',3)
        % openList_STC_new(1,:) = {[tem_p_new(1),start_p(1)],[tem_p_new(2),start_p(2)]};
        openList_STC_new(1,:) = {[start_p(1),start_p(2)],[tem_p_new(1),tem_p_new(2)]};
        curr_p_new = tem_p_new;
        num_new = num_new + 1;
        T_new(tem_p_new(2),tem_p_new(1)) = num_new;
        break;
    end
end

step_num_new = 0;
iteration_of_STC_without_increase = 0;

while num_new~=Total_num_for_remove_unreachable
    %num
    % move to free space
    step_num_new = step_num_new +1 ;  
    fprintf('Computing......            iteration_of_STC_without_increase = %d          ', iteration_of_STC_without_increase);
    fprintf('Computing......  \n');
    fprintf('step_num_new = %d\n' , step_num_new);
    fprintf('num_new = %d    ' , num_new);
    fprintf('MapSize = %d * ' , LENGTH);
    fprintf('%d    ' , LENGTH);
    fprintf('Total_num_new = %d\n' , Total_num_new);
    fprintf('curr_p_new : %d' , curr_p_new(1,1));
    fprintf(', %d \n' , curr_p_new(2,1));
    fprintf('tem_p_new  : %d' , tem_p_new(1,1));
    fprintf(', %d \n' , tem_p_new(2,1));
    
    move = 0;
    for d=dir_module_1
        tem_p_new = curr_p_new + d;
        if tem_p_new(1)<=0||tem_p_new(1)>LENGTH/2||tem_p_new(2)<=0||tem_p_new(2)>LENGTH/2
            continue; 
        end
        if K_for_remove_unreachable(tem_p_new(2),tem_p_new(1))==1 && T_new(tem_p_new(2),tem_p_new(1))==0 % bug 鎵?鍦?
            line([tem_p_new(1),curr_p_new(1)],[tem_p_new(2),curr_p_new(2)],'Color','r','LineWidth',3)
            

            openList_STC_new( num_new , : ) = {[curr_p_new(1),curr_p_new(2)],[tem_p_new(1),tem_p_new(2)]};
            curr_p_new = tem_p_new;
            num_new = num_new + 1;
            T_new(tem_p_new(2),tem_p_new(1)) = num_new;
            move = 1;
            break;
        end
    end

    if move==0
        for d=dir_module_2
            tem_p_new = curr_p_new + d;
            if tem_p_new(1)<=0||tem_p_new(1)>LENGTH/2||tem_p_new(2)<=0||tem_p_new(2)>LENGTH/2
                continue; 
            end
            if K_for_remove_unreachable(tem_p_new(2),tem_p_new(1))==1 && T_new(tem_p_new(2),tem_p_new(1))==0
            line([tem_p_new(1),curr_p_new(1)],[tem_p_new(2),curr_p_new(2)],'Color','r','LineWidth',3)
            

            openList_STC_new( num_new , : ) = {[curr_p_new(1),curr_p_new(2)],[tem_p_new(1),tem_p_new(2)]};
            curr_p_new = tem_p_new;
            num_new = num_new + 1;
            T_new(tem_p_new(2),tem_p_new(1)) = num_new;
            move = 1;
            break;
            end
        end
    end

    if move==0
        for d=dir_module_3
            tem_p_new = curr_p_new + d;
            if tem_p_new(1)<=0||tem_p_new(1)>LENGTH/2||tem_p_new(2)<=0||tem_p_new(2)>LENGTH/2
                continue; 
            end
            if K_for_remove_unreachable(tem_p_new(2),tem_p_new(1))==1 && T_new(tem_p_new(2),tem_p_new(1))==0
            line([tem_p_new(1),curr_p_new(1)],[tem_p_new(2),curr_p_new(2)],'Color','r','LineWidth',3)

            openList_STC_new( num_new , : ) = {[curr_p_new(1),curr_p_new(2)],[tem_p_new(1),tem_p_new(2)]};
            curr_p_new = tem_p_new;
            num_new = num_new + 1;
            T_new(tem_p_new(2),tem_p_new(1)) = num_new;
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


    if move==0
       iteration_of_STC_without_increase=iteration_of_STC_without_increase+1;
    end

    curr_p_new_index_of_T = T_new(curr_p_new(2),curr_p_new(1));
    need_to_be_back_of = T_new(curr_p_new(2,1),curr_p_new(1,1))-1;
    for i=1:(LENGTH/2)
        tem_p_new = [0;0];
        tem_p_new(1,1) = i;
        for j=1:(LENGTH/2)
             tem_p_new(2,1) = j;
             if T_new(tem_p_new(2,1),tem_p_new(1,1)) == need_to_be_back_of
                 curr_p_new = tem_p_new;
             break;
             end
        end
    end
    
    if iteration_of_STC_without_increase == ((LENGTH/2) *(LENGTH/2))
       iteration_of_STC_without_increase=0;
       break

       %iteration_of_STC_without_increase=iteration_of_STC_without_increase+1;
    end





end





    fprintf('step_num_new = %d\n' , step_num_new);
    fprintf('num_new = %d    ' , num_new);
    fprintf('MapSize = %d * ' , LENGTH);
    fprintf('%d    ' , LENGTH);
    fprintf('Total_num_new = %d\n' , Total_num_new);
    fprintf('End  \n');
    fprintf('  \n');
    fprintf('  \n');

    figure(3)
    colormap([0 0 0;1 1 1]);  % color
    pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B_repiared); % grid color
    set(gca,'XTick',1:10:size(A_core,2),'YTIck',1:10:size(A_core,1)); 
    axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.

    xlabel('X');
    ylabel('Y');
    
    for i=1:num_new-1  
    line([openList_STC_new{i,2}(1),openList_STC_new{i,1}(1)],[openList_STC_new{i,2}(2),openList_STC_new{i,1}(2)],'Color','r','LineWidth',3)
    end
toc

    figure(1)
    colormap([0 0 0;1 1 1]);  % color
    pcolor(0.5:size(A_core,2)+0.5,0.5:size(A_core,1)+0.5,B); % grid color
    set(gca,'XTick',1:10:size(A_core,2),'YTIck',1:10:size(A_core,1)); 
    axis image xy;  % axis image is the same as axis equal except that the plot box fits tightly around the data.
    xlabel('X');
    ylabel('Y');

