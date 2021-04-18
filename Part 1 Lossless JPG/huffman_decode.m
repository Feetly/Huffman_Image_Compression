%Using huff_dict, decodes huffman codes into their respective symbols.
function dec = huffman_decode(symbols,dict,hcode)
    array = [];
    for i = 1:length(symbols)
        array = [array, string(dict{i,2})];
    end
    dec = [];
    get = [];
    for i = 1:length(hcode)
        get = [get, hcode(i)];
        if find(array==get)
            dec = [dec,cell2mat(dict(find(array==get)))];
            get = [];
        end
    end
    dec = dec';
end