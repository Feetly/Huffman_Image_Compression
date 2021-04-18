% joining all subimages
function image = joinBlocks(blocks, n, sz)
    idx=1;
    for i=0:sz(1)/n - 1
        for j=0:sz(2)/n - 1
            image(i*n+1:i*n+n, j*n+1:j*n+n) = uint8(blocks{idx});
            idx=idx+1;
        end
    end
end