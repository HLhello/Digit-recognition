clc
clear
close all 
f1 = fopen('logo.txt', 'r');
dd = fscanf(f1,'%x');
figdata = dec2hex(dd);
f2 = fopen('figdata.txt','w');
for ii = 1:1:length(figdata)
    fprintf(f2, '%s%s\n', figdata(ii,3),figdata(ii,4));
    fprintf(f2, '%s%s\n', figdata(ii,1),figdata(ii,2));
end
fclose(f1);
fclose(f2);
