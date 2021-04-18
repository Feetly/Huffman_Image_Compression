%Using huff_dict, encode sequnces into their respective huffman codes.
function enc = huffman_encode(sym,dict,vector)
    a = [];
    for i = 1:length(vector)
    a = [a , strtrim(cell2mat(dict(find(sym==vector(i)),2)))];
    end
    enc = a;
end