% add padding on bottom and right side of image
function image = padImage(inp_image, n)
    [r, c, channels] = size(inp_image);
    r_new  = get(r, n);
    c_new  = get(c, n);
    image = zeros([r_new, c_new, channels], 'uint8');
    image(1:r, 1:c, :) = inp_image;
end

function new = get(tmp,n)
    if mod(tmp, n)
        new  = tmp+n-mod(tmp, n);
    else
        new = tmp;
    end
end