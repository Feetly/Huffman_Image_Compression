%{ 
    Part 2: IT Course Project
    Topic: Lossy Huffman compression on BMP images to JPEG
    Author: Dhruv jain (180020006)
            Rajat Tyagi (180020029)
    Date: 16/04/2021

    Welcome to the Demonstration
%}

clear all; close all; clc; % Clearing Workspace

%Reading image
[filename, pathname] = uigetfile('*.bmp', 'Open image');  % Uncompressed Image
fname_inp = fullfile(pathname, filename); % Input File Full Name
name = split(filename,'.');
fname_out = fullfile(pathname, (name(1) + "_Lossy_Reconstructed.jpeg")); % Output Filename
flitersize = 8; % Size of DCT filter block

Mainy(fname_inp, fname_out, flitersize, 'DCT', true); % Function to demonstrate lossy compression

function Mainy(fname_inp, fname_out, n, transform, toshow)
    %---------------------------------------------------------%
    %    fname_inp: input image                               %
    %    fname_out: Name of output(decompressed) image        %
    %    n: (n x n)size of quantization Table                 %
    %    transform (str): transform function                  %
    %                  either 'DCT' or 'DFT'                  %
    %    toshow (bool): To display results                    %
    %---------------------------------------------------------%

    % Reading Image
    img = imread(fname_inp);
    
    % Padding image so that its compatible with the Filter size n
    padded_img = padImage(img, n); 
    
    out_img = zeros(size(padded_img), 'uint8');
    
    for channel=1:size(padded_img,3) % Looping over channels (if GPU: use parfor)
        grey_img = padded_img(:, :, channel);  % get particular channel
        sz = size(grey_img); % get dimensions
        
        % (compression)
        blocks = getBlocks(grey_img, n); % Breaking images into small blocks
        blocks = shift(blocks, 128, 0); % Shifting bloack to apply transformation
        blocks = transformNorm(blocks, n, 0, transform); % DCT transform with Quantization normalization
        list_for = for_zigzag(blocks, n); % Flattening image in an ZIGZAG manner
        [keys, probs] = getProbs(list_for, n); % Getting Probabilities of each pixel in the flattened list
        [trees, codes_list] = Encoder(keys, probs, list_for); % Using huffman encoder to compress it using huffman code
        
        % (Decompression)
        lists = Decode(codes_list, trees); % Getting pixels data back, huffman instantenous decoder
        blks1 = rev_zigzag(lists, n); % Reverse flattening to get the image back
        blks = transformNorm(blks1, n, 1, transform); % Inv DCT to get original data
        blks = shift(blks, 128, 1); % Inverse shift
        out_img(:, :, channel) = joinBlocks(blks, n, sz); % Combining all blocks back again
        disp("Channel "+channel + " processed");
    end
    
    % Save Reconstructed image
    imwrite(out_img, fname_out);
    
    if toshow
        figure(); % Figure Title
        sgtitle(sprintf("Lossy JPEG Compression using DCT, without altering Image Dimensions \n Image Dimensions: ("+join(string(size(padded_img)),", ")+")"));
        
        in_size = imfinfo(fname_inp).FileSize; % Size of input in Bytes
        out_size = imfinfo(fname_out).FileSize; % Output Size in Bytes
        compression = 100*((in_size - out_size)/in_size); % Compression factor
        
        in_avg_leng = round((in_size*8)/size(padded_img(:),1),3); % Avg length per pixel for input
        out_avg_leng = round((out_size*8)/size(padded_img(:),1),3); % Avg length per pixel for output
        
        nrmspe = 100*(sqrt(immse(padded_img, out_img))/size(padded_img(:),1)); % Normalized Root Means Square Pixel Error
        subplot(1,2,1);
        imshow(padded_img); % Input Image
        title(sprintf("Original image \n[Size: "+ in_size/(1024*1024) + " MB \n Average length: "+in_avg_leng+" Bits per Pixel]"));
    
        subplot(1,2,2);
        imshow(out_img); % Output Image
        title(sprintf("Compressed image \n[Size: "+ out_size/(1024*1024) + " MB \n Average length: "+out_avg_leng+" Bits per Pixel \n NRMSPE: "+nrmspe+"%%\n Compression Ratio: "+compression+"%%]"));
    end
end

%{ Thank You %}