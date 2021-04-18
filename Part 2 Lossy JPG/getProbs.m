% funtion to get the probabilites of pixel values in each block
function [keys, probs] = getProbs(lists, n)
    probs = cell(1, length(lists));
    keys = cell(1, length(lists));
    for idx=1:length(lists)
        % replacing the Endof Block (eob) symbol with 0
        lists{idx}(lists{idx}==-1000) = 0;
        % getting all the unique pixel values
        keys{idx} = unique(lists{idx});
        % updating the number of occurances of pixel values
        for i=1:length(keys{idx})
            probs{idx}(i) = double(sum(lists{idx}==keys{idx}(i), 'all'))/(n*n);
        end
        % updating the number of zeros as after the eob symbol.
        probs{idx}(keys{idx}==0) = probs{idx}(keys{idx}==0) + double((n*n)-length(lists{idx}))/(n*n);
    end
end