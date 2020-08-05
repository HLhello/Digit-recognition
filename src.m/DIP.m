clc
clear
close all;

flower = imread('flower.bmp');

figure(1)
flower_n1 = imnoise(flower,'salt & pepper', 0.04);
flower_n2 = imnoise(flower,'gaussian', 0, 0.02);
flower_n3 = imnoise(flower,'poisson');
subplot(2,2,1), imshow(flower), title('flower');
subplot(2,2,2), imshow(flower_n1), title('salt & pepper');
subplot(2,2,3), imshow(flower_n2), title('gaussian');
subplot(2,2,4), imshow(flower_n3), title('possion');

figure(2)
flower_ycbcr = rgb2ycbcr(flower);
subplot(2,2,1), imshow(flower_ycbcr), title('ycbcr');
subplot(2,2,2), imshow(flower_ycbcr(:,:,1)), title('ycbcr_y');
subplot(2,2,3), imshow(flower_ycbcr(:,:,2)), title('ycbcr_{cb}');
subplot(2,2,4), imshow(flower_ycbcr(:,:,3)), title('ycbcr_{cr}');

figure(3)
flower_gray = rgb2gray(flower);
subplot(1,2,1), imshow(flower_gray), title('flower_{gray}');
subplot(1,2,2), imshow(flower_ycbcr(:,:,1)),title('ycbcr_y');







