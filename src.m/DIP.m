clc
clear
close all;

flower = imread('flower.bmp');
% figure(1)
% subplot(2,2,1), imshow(flower), title('flower');
% subplot(2,2,2), imshow(flower(:,:,1)), title('flower_r');
% subplot(2,2,3), imshow(flower(:,:,2)), title('flower_g');
% subplot(2,2,4), imshow(flower(:,:,3)), title('flower_b');
% 
% figure(2)
% flower_n1 = imnoise(flower,'salt & pepper', 0.04);
% flower_n2 = imnoise(flower,'gaussian', 0, 0.02);
% flower_n3 = imnoise(flower,'poisson');
% subplot(2,2,1), imshow(flower), title('flower');
% subplot(2,2,2), imshow(flower_n1), title('salt & pepper');
% subplot(2,2,3), imshow(flower_n2), title('gaussian');
% subplot(2,2,4), imshow(flower_n3), title('possion');
% 
% figure(3)
% flower_ycbcr = rgb2ycbcr(flower);
% subplot(2,2,1), imshow(flower_ycbcr), title('ycbcr');
% subplot(2,2,2), imshow(flower_ycbcr(:,:,1)), title('ycbcr_y');
% subplot(2,2,3), imshow(flower_ycbcr(:,:,2)), title('ycbcr_{cb}');
% subplot(2,2,4), imshow(flower_ycbcr(:,:,3)), title('ycbcr_{cr}');
% 
% 
% figure(4)
% % h-色调, s-饱和度, v/i-强度/亮度
% flower_hsv = rgb2hsv(flower);
% subplot(2,2,1), imshow(flower_hsv), title('flower_{hsv}');
% subplot(2,2,2), imshow(flower_hsv(:,:,1)), title('hsv_h');
% subplot(2,2,3), imshow(flower_hsv(:,:,2)), title('hsv_s');
% subplot(2,2,4), imshow(flower_hsv(:,:,3)), title('hsv_v');
% 
% figure(5)
% flower_gray = rgb2gray(flower);
% diff_f = flower_ycbcr(:,:,1) - flower_gray;
% subplot(1,2,1), imshow(flower_gray), title('flower_{gray}');
% subplot(1,2,2), imshow(flower_ycbcr(:,:,1)),title('ycbcr_y');
% 
% figure(6)
% subplot(1,2,1), imshow(flower_ycbcr), title('flower_{ycbcr}');
% subplot(1,2,2), imshow(flower_hsv), title('flower_{hsv}');

figure(7)
% 利用膨胀平移函数
se = translate(strel(1),[30 30]);
flower_move = imdilate(flower,se);
subplot(1,2,1), imshow(flower), title('flower');
subplot(1,2,2), imshow(flower_move), title('flower_{move}');


