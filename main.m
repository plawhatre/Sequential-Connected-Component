%main code
tic
clc,clear,close all
%input
addpath('input images')
I=im2double(imread('3.png'));
conn=8;
%%%%%%%%%%%for dyanamic declaration (can be set by user)
V=max(I(:))%[255];
%function calling
cc=Conncomp(I,conn,V);
cls_img=zeros(size(cc));
cls_img(cc~=0)=1;
subplot(1,2,1)
imshow(cls_img)
title('Processed image')
subplot(1,2,2)
imshow(I)
title('Original image')
%output struc
[lx,ly]=size(cc);
disp('calculated')
strc.Connectivity=conn;
strc.ImageSize=[lx ly];
strc.NumObjects=max(max(cc));
strc
time1=toc
tic
disp('inbuilt')
bwconncomp(I,8)
time2=toc