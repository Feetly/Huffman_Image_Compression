% level shifting
function blocks = shift(blocks, n_term, inv)
    %------------------------------------------------%
    % level shift                                    %
    % if inv==1 ? inverse level shift : level shift  %
    %------------------------------------------------%
    if inv==1 
        n_term = n_term*(-1);
    end
    for i=1:length(blocks)
        blocks{i} = blocks{i} - n_term;
    end
end