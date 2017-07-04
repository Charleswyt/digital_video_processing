clear all;
close all;

rng default;
x = randn(36,1);
x0 = downsample(x,3,0);
x1 = downsample(x,3,1);
x2 = downsample(x,3,2);

y0 = upsample(x0,3,0);
y1 = upsample(x1,3,1);
y2 = upsample(x2,3,2);

subplot(411)
stem(x,'marker','none');
set(gca,'ylim',[-4 4]); title('Original Signal');
subplot(412)
stem(y0,'marker','none'); ylabel('Phase 0');
set(gca,'ylim',[-4 4]);
subplot(413)
stem(y1,'marker','none'); ylabel('Phase 1');
set(gca,'ylim',[-4 4]);
subplot(414)
stem(y2,'marker','none'); ylabel('Phase 2');
set(gca,'ylim',[-4 4]);
set(gcf,'position',get(0,'ScreenSize'));