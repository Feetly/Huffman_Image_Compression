%{ 
    Part 1: IT Course Project
    Topic: Lossless Huffman compression on BMP images to JPEG
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
fname_out = fullfile(pathname, (name(1) + "_Lossless_Reconstructed.jpeg")); % Output Filename

in_img = imread(fname_inp);
out_img = zeros(size(in_img),'uint8');
av_len = zeros(3);

for c = 1:size(in_img,3) % Looping over channels (if GPU: use parfor)
    I = in_img(:,:,c); % get particular channel
    [m,n]=size(I); % get dimensions of it
    
    %converts array to vector (Flattening)
    newvec = I(:);

    % Gets symbols and their probabilities
    symbols = single(unique(newvec)); % Get all unique symbols i.e pixel values present in image
    counts = hist(newvec, symbols); % Get respective counts
    p = double(counts) ./ sum(counts); % Getting Estimated probabilities

    %Huffman Dictonary
    [dict,av_len(c)] = huffman_dict(symbols,p); % Creating a dictonary using huffman coding
    %[dict,av_len(c)] = huffmandict(symbols,p); % Inbuilt
    %Huffman Encodig
    hcode = huffman_encode(symbols,dict,newvec); % Convert values to their code
    %hcode = huffmanenco(newvec,dict); % Inbuilt
    %Huffman Decoding
    dhsig = huffman_decode(symbols,dict,hcode); % Finally get values back from codes
    %dhsig = huffmandeco(hcode,dict); % Inbuilt
    
    %vector to array conversion (De-Flateing)
    out_img(:,:,c) = reshape(dhsig,m,[]);
end

imwrite(out_img, fname_out); % Finally saving reconstructed image

figure(); % Figure Title
sgtitle(sprintf("Lossless JPEG Compression wihtout Filtering, without altering Image Dimensions \n Image Dimensions: ("+join(string(size(in_img)),", ")+")"));

in_size = imfinfo(fname_inp).FileSize; % Size of input in Bytes
out_size = (in_size*(sum(av_len(:))/3))/8; % Output Size in Bytes
compression = 100*((in_size - out_size)/in_size); % Compression factor

in_avg_leng = round((in_size*8)/size(in_img(:),1),3); % Avg length per pixel for input
out_avg_leng = sum(av_len(:))/3; % Avg length per pixel for output

% Normalized Root Means Square Pixel Error
nrmspe = 100*(sqrt(immse(in_img, out_img))/size(in_img(:),1)); % Normalized Root Means Square Pixel Error

subplot(1,2,1);
imshow(in_img); % Input Image
title(sprintf("Original image \n[Size: "+ in_size/(1024*1024) + " MB \n Average length: "+in_avg_leng+" Bits per Pixel]"));

subplot(1,2,2);
imshow(out_img); % Output Image
title(sprintf("Compressed image \n[Size: "+ out_size/(1024*1024) + " MB \n Average length: "+out_avg_leng+" Bits per Pixel \n NRMSPE: "+nrmspe+"%%\n Compression Ratio: "+compression+"%%]"));

%{ Thank You %}