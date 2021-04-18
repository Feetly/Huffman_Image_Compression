% Decoder to get the values from code
function lists = Decode(codes, trees)
    lists = cell(1, length(trees));
    for idx=1:length(codes)
        values = getValue(trees{idx}, codes{idx});
        % replacing the eob symbol;
        values(length(values)+1) = -1000;
        lists{idx} = values;
    end
end

function values = getValue(tree, str)
    values = [];
    idx = 1;
    temp_tree = tree;
    while ~isempty(str)
        % traverse tree
        if str(1) == 0
            tree = tree{1};
        else
            tree = tree{2};
        end
        % remove current bit
        str(1) = [];
        % check if the current node is a leaf
        if isa(tree, 'cell')
            continue
        else
            values(idx) = tree;
            idx=idx+1;
            % reset root of the tree to decode new value
            tree = temp_tree;
        end
    end
end