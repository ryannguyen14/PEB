im=imread('smallbeads.tif');

figure(1), imshow(mat2gray(im));
im2=zeros(size(1000,700));
im2(41:954,21:680)=im;
figure(3), imshow(mat2gray(im2))
saveas(gcf,'biggerBeads.tif','tif')
keyboard


midi=round(size(im,1)/2);
midj=round(size(im,2)/2);
imS=im(1:(midi-1),:);

%im2=zeros(size(im,1)*4,size(im,2)*4);
im2=[];
ii=1;
r=1;
for ii = 1:10:size(imS,1)
    
    di=abs(midi-ii);
    for k=1:ceil(ii+ii/(10*di))
        im2(r+k,:)=imS(ii,:);
        r=r+1;
    end
end
figure(2), imshow(mat2gray(im2))
