  close all;clc;clear all;
tic;
img = imread('C:\Users\Asiuzzaman\Desktop\img\test7.jpg');
i = img;
%imshow(img);
img = imresize(img, [512 512]);
imwrite(img, 'color.jpg')
img = rgb2gray(img);
imwrite(img, 'gray.jpg');


sift('gray.jpg');
process_image('color.jpg', 'single', 2,4, 1, 'tmp.key')
toc;