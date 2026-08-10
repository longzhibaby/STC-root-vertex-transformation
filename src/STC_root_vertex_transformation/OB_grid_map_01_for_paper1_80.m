function [OB_1] = OB_grid_map_01_for_paper1_80
%OB_FOR_TEST 此处显示有关此函数的摘要
%   此处显示详细说明
    OB_1 = ones(40,40);%障碍对应地图尺度

%   i 表示y轴  j 表示x轴
%   

%   for i = 50:1:70
%        for j = 20:1:80
%            OB_1(i,j) = 0;
%        end
%   end

%    for i = 20:1:50
%        for j = 20:1:45
%            OB_1(i,j) = 0;
%        end
%    end

%    for i = 20:1:50
%        for j = 60:1:80
%            OB_1(i,j) = 0;
%       end
%    end


   for i = 1:1:8
        for j = 20:1:(120/5)
            OB_1(i,j) = 0;
        end
   end

   for i = 1:1:(40/5)
        for j = (140/5):1:(160/5)
            OB_1(i,j) = 0;
        end
   end

   for i = 1:1:(40/5)
        for j = (180/5):1:(200/5)
            OB_1(i,j) = 0;
        end
   end

   for i = (1:1:20/5)
        for j = (120/5):1:(140/5)
            OB_1(i,j) = 0;
        end
   end
   for i = 1:1:(20/5)
        for j = (160/5):1:(180/5)
            OB_1(i,j) = 0;
        end
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%

   for i = (20/5):1:(40/5)
        for j = (20/5):1:(80/5)
            OB_1(i,j) = 0;
        end
   end

   for i = (40/5):1:(60/5)
        for j = (20/5):1:(40/5)
            OB_1(i,j) = 0;
        end
   end
   for i = (60/5):1:(80/5)
        for j = 1:1:(120/5)
            OB_1(i,j) = 0;
        end
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%
   for i = (120/5):1:(140/5)
        for j = (60/5):1:(160/5)
            OB_1(i,j) = 0;
        end
   end
   for i = (140/5):1:(180/5)
        for j = (60/5):1:(80/5)
            OB_1(i,j) = 0;
        end
   end
   for i = (140/5):1:(160/5)
        for j = (140/5):1:(160/5)
            OB_1(i,j) = 0;
        end
   end
   for i = (140/5):1:(160/5)
        for j = (180/5):1:(190/5)
            OB_1(i,j) = 0;
        end
   end
   for i = (160/5):1:(200/5)
        for j = (140/5):1:(200/5)
            OB_1(i,j) = 0;
        end
   end





%%%%%%%%%%%%%%%%%%%%%%%%%%%
end