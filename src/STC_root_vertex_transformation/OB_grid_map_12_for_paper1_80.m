function [OB_1] = OB_grid_map_12_for_paper1_80

OB_1 = ones(40,40);

for i = (80/5):1:(85/5)
    for j = 1:1:(65/5)
        OB_1(i,j) = 0;
    end
end

for i = (80/5):1:(85/5)
    for j = (100/5):1:(180/5)
        OB_1(i,j) = 0;
    end
end

for i = (120/5):1:(125/5)
    for j = (40/5):1:(65/5)
        OB_1(i,j) = 0;
    end
end

for i = (120/5):1:(125/5)
    for j = (100/5):1:(200/5)
        OB_1(i,j) = 0;
    end
end

for i = 1:1:(85/5)
    for j = (100/5):1:(105/5)
        OB_1(i,j) = 0;
    end
end

for i = (120/5):1:(200/5)
    for j = (60/5):1:(65/5)
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
