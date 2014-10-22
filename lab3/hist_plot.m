function y = hist_plot(h,c,avg,std,name,sequ)
y = 0;

f=figure('visible','off');
figure(sequ);
bar(c,h);
xlabel(sprintf('%s, avg: %f, std error: %f', name,avg, std));
n = strcat(name);
print(f, '-dpng', strcat(n,'.png'));

end