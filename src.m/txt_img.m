clc
clear
close all

a = 600;
b = 800;
c = 3;

img1R = uint8(textread('Result_Frame1_R.txt','%u'));
img1G = uint8(textread('Result_Frame1_G.txt','%u'));
img1B = uint8(textread('Result_Frame1_B.txt','%u'));

img2R = uint8(textread('Result_Frame2_R.txt','%u'));
img2G = uint8(textread('Result_Frame2_G.txt','%u'));
img2B = uint8(textread('Result_Frame2_B.txt','%u'));

img3R = uint8(textread('Result_Frame3_R.txt','%u'));
img3G = uint8(textread('Result_Frame3_G.txt','%u'));
img3B = uint8(textread('Result_Frame3_B.txt','%u'));

img4R = uint8(textread('Result_Frame4_R.txt','%u'));
img4G = uint8(textread('Result_Frame4_G.txt','%u'));
img4B = uint8(textread('Result_Frame4_B.txt','%u'));

img1(:,:,1) = reshape(img1R,[b,a]);
img1(:,:,2) = reshape(img1G,[b,a]);
img1(:,:,3) = reshape(img1B,[b,a]);

img2(:,:,1) = reshape(img2R,[b,a]);
img2(:,:,2) = reshape(img2G,[b,a]);
img2(:,:,3) = reshape(img2B,[b,a]);

img3(:,:,1) = reshape(img3R,[b,a]);
img3(:,:,2) = reshape(img3G,[b,a]);
img3(:,:,3) = reshape(img3B,[b,a]);

img4(:,:,1) = reshape(img4R,[b,a]);
img4(:,:,2) = reshape(img4G,[b,a]);
img4(:,:,3) = reshape(img4B,[b,a]);

subplot(221),imshow(img1),title('img1');
subplot(222),imshow(fliplr(imrotate(img2, -90))),title('img2');
subplot(223),imshow(fliplr(imrotate(img3,  90))),title('img3');
subplot(224),imshow(fliplr(imrotate(img4, 180))),title('img4');

imwrite(fliplr(imrotate(img1,-90)),'1.jpg');
imwrite(fliplr(imrotate(img2,-90)),'2.jpg');
imwrite(fliplr(imrotate(img3,-90)),'3.jpg');
imwrite(fliplr(imrotate(img4,-90)),'4.jpg');

%pic =dir('./*.jpg');
%pic_a = size(pic);
%pic_mum=pic_a(1);
%for i=1:pic_mum
%    im(:,:,:,i)=imread(strcat(num2str(i),'.jpg'));
%    imshow(im(:,:,:,i));
%    M(i) = getframe;
%end
%movie2avi(M,'C:\Users\lijing\Desktop\verilog\image_face\matlab\out.avi','FPS',1);



