function [OB_1] = OB_grid_map_11_for_paper1_80
%OB_FOR_TEST 此处显示有关此函数的摘要
%   此处显示详细说明
OB_1 = ones(40,40);


for i = (20/5):1:(25/5)
    for j = (80/5):1:(120/5)
        OB_1(i,j) = 0;
    end
end


for i = (20/5):1:(25/5)
    for j = (160/5):1:(185/5)
        OB_1(i,j) = 0;
    end
end

for i = (100/5):1:(105/5)
    for j = (160/5):1:(185/5)
        OB_1(i,j) = 0;
    end
end

for i = (100/5):1:(105/5)
    for j = (80/5):1:(120/5)
        OB_1(i,j) = 0;
    end
end

for i = (160/5):1:(165/5)
    for j = (80/5):1:(185/5)
        OB_1(i,j) = 0;
    end
end

for i = (20/5):1:(60/5)
    for j = (80/5):1:(85/5)
        OB_1(i,j) = 0;
    end
end

for i = (80/5):1:(165/5)
    for j = (80/5):1:(85/5)
        OB_1(i,j) = 0;
    end
end

for i = (20/5):1:(165/5)
    for j = (180/5):1:(185/5)
        OB_1(i,j) = 0;
    end
end
%for i = 20:1:50
%    for j = 20:1:45
%        OB_1(i,j) = 0;
%    end
%end


%Y_i_x = 0;
%for i = (140/5):1:(180/5)
%    Y_i_x = i;
%    for j = (40/5-fix((20/40)*((180/5)-Y_i_x))):1:(40/5+fix((20/40)*((180/5)-Y_i_x)))
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
