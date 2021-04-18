% packing blocks(traversing in zigzag pattern) to list
function list = for_zigzag(blocks, n)
    list = cell(1, length(blocks));
    for q=1:length(blocks)
        str = zeros(1, n*n, 'double');
        idx=1;
        % first half block
        for i=1:n
            for j=1:i
               if mod(i, 2)==1
                   str(idx) = blocks{q}(i+1-j, j);
               else
                   str(idx) = blocks{q}(j, i+1-j);
               end
               idx=idx+1;
            end
        end
        
        % second half block
        for i=2:n
            for j=i:n
                if mod(n-i, 2)==1
                    str(idx) = blocks{q}(j, n+i-j);
                else
                    str(idx) = blocks{q}(n+i-j, j);
                end
                idx=idx+1;
            end
        end
        
        % marking the last non zero index
        idx = find(str, 1, 'last');
        if isempty(idx)
            idx=0;
        end
        str(idx+1) = -1000;
        list{q} = str(1:idx+1);
    end
end