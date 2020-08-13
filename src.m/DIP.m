clc
clear
close all;

flower = imread('flower.bmp');

flower_n1 = imnoise(flower,'salt & pepper', 0.04);
flower_n2 = imnoise(flower,'gaussian', 0, 0.02);
flower_n3 = imnoise(flower,'poisson');

flower_ycbcr = rgb2ycbcr(flower);
flower_hsv = rgb2hsv(flower);% h-色调, s-饱和度, v/i-强度/亮度
flower_gray = rgb2gray(flower);

diff_y_gray = flower_ycbcr(:,:,1) - flower_gray;
diff_h_gray = flower_hsv(:,:,1) - flower_gray;
diff_y_h = flower_ycbcr(:,:,1) - flower_hsv(:,:,1);

se = translate(strel(1),[30 30]);% 利用膨胀平移函数
flower_move = imdilate(flower,se);


