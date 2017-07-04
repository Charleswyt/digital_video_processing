    function Test()  
        clear all  
        rgb=imread('fig5.tif');%需要处理的图片  
        imshow(rgb);
        m=size(rgb,1);           %图像的行数，也就是高度, 行数对应高  
        n=size(rgb,2);           %图像的列数，也就是宽度，列数对应宽  
        rr=zeros(m,n);           %定义三个同样大小的变量存放图片  
        gg=zeros(m,n);           %同上  
        bb=zeros(m,n);           %同上  
        for i=1:m  
            for j=1:n  
                rr(i,j)=logm(double(rgb(i,j,1))+eps);  
                gg(i,j)=logm(double(rgb(i,j,2))+eps);  
                bb(i,j)=logm(double(rgb(i,j,3))+eps);  
            end  
        end  
        rr=rr/max(max(rr(:)));  
        gg=gg/max(max(gg(:)));  
        bb=bb/max(max(bb(:)));  
        rrr= retinex_frankle_mccann(rr, 4);  
        ggg= retinex_frankle_mccann(gg, 4);  
        bbb= retinex_frankle_mccann(bb, 4);  
        for i=1:m  
            for j=1:n  
                rrr(i,j)=round(exp(rrr(i,j)*5.54));  
                ggg(i,j)=round(exp(ggg(i,j)*5.54));  
                bbb(i,j)=round(exp(bbb(i,j)*5.54));  
            end  
        end  
        rgb=cat(3,uint8(rrr),uint8(ggg),uint8(bbb));  
        rgb=max(min(rgb,255),0);  
        figure;
        imshow(rgb);  
    end  