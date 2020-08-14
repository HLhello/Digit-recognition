clc
clear
close all 
f1 = fopen('logo.txt', 'r');
dd = fscanf(f1,'%x');
figdata = dec2hex(dd);
f2 = fopen('figdata.txt','w');
for ii = 1:1:length(figdata)
    fprintf(f2, '%s\n', figdata(ii,4));
    fprintf(f2, '%s\n', figdata(ii,3));
    fprintf(f2, '%s\n', figdata(ii,2));
    fprintf(f2, '%s\n', figdata(ii,1));
end
fclose(f1);
fclose(f2);
