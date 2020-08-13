clc
clear
close all 

figdata=textread('logo.txt','%s');
fp = fopen('figdata.txt','w');
for ii = 1:1:length(figdata)
    fprintf(fp, '%s\n', figdata(ii));
end
fclose(fp);