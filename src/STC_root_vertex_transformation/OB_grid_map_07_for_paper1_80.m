function [OB_1] = OB_grid_map_07_for_paper1_80
%OB_FOR_TEST 此处显示有关此函数的摘要
%   此处显示详细说明
OB_1 = ones(40,40);

for i = 1:1:(80/5)
    for j = 1:1:(40/5)
        OB_1(i,j) = 0;
    end
end

for i = (40/5):1:(100/5)
    for j = (120/5):1:(160/5)
        OB_1(i,j) = 0;
    end
end

for i = (140/5):1:(160/5)
    for j = (40/5):1:(100/5)
        OB_1(i,j) = 0;
    end
end

Y_i_1 = 0;
for i = 1:1:(40/5)
    Y_i_1 = i;
    for j = (40/5):1:(40/5+fix((40/40)*(Y_i_1)))
        OB_1(i,j) = 0;
    end
end

Y_i_2 = 0;
for i = (40/5):1:(80/5)
    Y_i_2 = i;
    for j = (40/5):1:((80/5)-fix((40/40)*(Y_i_2-(40/5))))
        OB_1(i,j) = 0;
    end
end

%for i = 20:1:50
%    for j = 20:1:45
%        OB_1(i,j) = 0;
%    end
%end

%下斜
%Y_i_2 = 0;
%for i = (140/5):1:(180/5)
%    Y_i_2 = i;
%    for j = (40/5-fix((20/40)*((180/5)-Y_i_2))):1:(40/5+fix((20/40)*((180/5)-Y_i_2)))
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
