clc
clear
close all 
addpath('E:\working_files\about_dip\ref\pic')

fig = imread('1.png');
ycbcrfig = rgb2ycbcr(fig);
posfig = gray_bit( ycbcrfig(:,:,1));
plot(posfig(1,:),posfig(2,:),'.');




