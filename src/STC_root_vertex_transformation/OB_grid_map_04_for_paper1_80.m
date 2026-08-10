function [OB_1] = OB_grid_map_04_for_paper1_80
%OB_FOR_TEST 此处显示有关此函数的摘要
%   此处显示详细说明
OB_1 = ones(40,40);

for i = (40/5):1:(80/5)
    for j = (60/5):1:(140/5)
        OB_1(i,j) = 0;
    end
end

for i = (80/5):1:(120/5)
    for j = (100/5):1:(140/5)
        OB_1(i,j) = 0;
    end
end

for i = (120/5):1:(160/5)
    for j = (60/5):1:(140/5)
        OB_1(i,j) = 0;
    end
end

%for i = 20:1:50
%    for j = 20:1:45
%        OB_1(i,j) = 0;
%    end
%end

%for i = 20:1:50
%    for j = 60:1:80
%        OB_1(i,j) = 0;
%    end
%end

%for i = 20:1:50
%    for j = 60:1:80
%        OB_1(i,j) = 0;
%    end
%end

%for i = 20:1:50
%    for j = 60:1:80
%        OB_1(i,j) = 0;
%    end
%end

%for i = 20:1:50
%    for j = 60:1:80
%        OB_1(i,j) = 0;
%    end
%end

%for i = 20:1:50
%    for j = 60:1:80
%        OB_1(i,j) = 0;
%    end
%end

%for i = 20:1:50
%    for j = 60:1:80
%        OB_1(i,j) = 0;
%    end
%end

%for i = 20:1:50
%    for j = 60:1:80
%        OB_1(i,j) = 0;
%    end
%end

%for i = 20:1:50
%    for j = 60:1:80
%        OB_1(i,j) = 0;
%    end
%end


end
