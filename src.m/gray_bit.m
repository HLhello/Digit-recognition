function [ posfig ] = gray_bit( grayfig )

bitfig = zeros(150,100);
posfig = zeros(2,15000);

kk = 0;
for ii = 1:1:150
    for jj = 1:1:100
        if(grayfig(ii,jj)>210)
            bitfig(ii,jj) = 0;
        else 
            bitfig(ii,jj) = 1;
            kk = kk+1;
            posfig(1,kk) = jj;
            posfig(2,kk) = 151-ii;
        end
    end
end


end

