% unpacking list(packed in zigzag block traversal) to block
function blocks = rev_zigzag(list, n)
    blocks = cell(1, length(list));
    for idx=1:length(list)
        block = zeros(n, 'double');
        q=1;
        % first half block
        for i=1:n
            if list{idx}(q)==-1000
               break;
            end
            for j=1:i
               if mod(i, 2)==1
                   block(i+1-j, j) = list{idx}(q);
               else
                   block(j, i+1-j) = list{idx}(q);
               end
               q=q+1;
               if list{idx}(q)==-1000
                   break;
               end
            end
            if list{idx}(q)==-1000
               break;
            end
        end
        
        % second half block
        for i=2:n
            if list{idx}(q)==-1000
               break;
            end
            for j=i:n
                if mod(n-i, 2)==1
                    block(j, n+i-j) = list{idx}(q);
                else
                    block(n+i-j, j) = list{idx}(q); 
                end
                q=q+1;
                if list{idx}(q)==-1000
                   break;
                end
            end
            if list{idx}(q)==-1000
                break;
            end
        end
        
        % updating current block into blocks list
        blocks{idx} = block;
    end
end