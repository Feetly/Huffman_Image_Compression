% Division into blocks(subimages)
function blocks = getBlocks(grey_img, n)
    [x,y] = size(grey_img);
    blocks = cell(1, (x/n)*(y/n));
    idx = 1;
    for i=0:x/n - 1
        for j=0:y/n - 1
            blocks{idx} = double(grey_img(i*n+1:i*n+n, j*n+1:j*n+n));
            idx=idx+1;
        end
    end
end