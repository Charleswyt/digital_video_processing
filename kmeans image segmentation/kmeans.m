function [mu,mask]=kmeans(ima,k)%k为指定类别数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   kmeans image segmentation
%
%   Input:
%          ima: grey color image灰度图像
%          k: Number of classes指定的图像中类别数目
%   Output:
%          mu: vector of class means 每个类的均值
%          mask: clasification image mask分类后的图像掩膜（mask)
%
%   Author: Jose Vicente Manjon Herrera
%    Email: jmanjon@fis.upv.es
%     Date: 27-08-2005
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pic=imread('1.jpg');
imshow(pic);
pic=rgb2hsv(pic);
h=pic(:,:,2);
h=round(h*255);
ima=h;
k=2;
% check image
ima=double(ima);
copy=ima;         % make a copy
ima=ima(:);       % vectorize ima将图像向量化，即一维化。
mi=min(ima);      % deal with negative 
ima=ima-mi+1;     % and zero values

s=length(ima);%获得图像像素个数

% create image histogram%创建图像直方图

m=max(ima)+1;%最大像素值加1
h=zeros(1,m);%直方图，有m个bin
hc=zeros(1,m);%标号矩阵，每个像素点的值为该点所隶属的类别号

for i=1:s%s是图像象素个数，即考查每个像素
  if(ima(i)>0) h(ima(i))=h(ima(i))+1;end;%直方图中对应bin加1
end
ind=find(h);%找到直方图中不为零的那些bin的序号。
hl=length(ind);%直方图中非零bin的个数

% initiate centroids

mu=(1:k)*m/(k+1);%k为指定的类别数，mu为不同类的分割点，相当于坐标轴上的整点

% start process

while(true)
  
  oldmu=mu;
  % current classification  
 
  for i=1:hl
      c=abs(ind(i)-mu);%就是相当于考察ind(i)在坐标轴上离哪个整点最近！注意mu总共就k个
      cc=find(c==min(c));%cc保留距离ind(i)最近整点的序号，序号为1、2、3...k
      hc(ind(i))=cc(1);
  end
  
  %recalculation of means  下面的程序用于计算每一类的均值位置
  
  for i=1:k, 
      a=find(hc==i);
      mu(i)=sum(a.*h(a))/sum(h(a));%h为直方图
  end
  
  if(mu==oldmu) break;end;%循环结束条件
  
end

% calculate mask
s=size(copy);
mask=zeros(s);
mask1=mask;%增加一个显示矩阵
size(mask1)
for i=1:s(1),
for j=1:s(2),
  c=abs(copy(i,j)-mu);
  a=find(c==min(c));  
  mask(i,j)=a(1);
end
end

mu=mu+mi-1;   % recover real range

for	i	=	1	:	k
	p=find(mask==i);
	mask1(p)=1/k*i;
end
figure,imshow(mask1)

%最后试验结果发现：
%rgb到hsv空间后，
%h效果最好，
%v的效果类似于二值化，很不好
%s也不是太好