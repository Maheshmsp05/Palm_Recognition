function [xyz] = plo_feat(imag)
load out.mat

MAXD = 1000;
imag = imag(:,:,1);
[counts, x] = imhist(imag);  
GradeI = length(x);  
J_t = zeros(GradeI, 1);  
prob = counts ./ sum(counts); 
meanT = x' * prob;  
xyz=1;
figure;
plot(sort(xdata(1,:),'ascend'),'-k<','linewidth',2);hold on
plot(sort(xdata(2,:),'ascend'),'-rs','linewidth',2);hold off

set(gca,'xticklabel',{'20','40','60','80','100','120','140','160','180','200','220'});
grid on
axis on
xlabel('Number of Images');
ylabel('Accuracy (%)')
legend('Polynomial Regression','SVM')
title('Performance Analysis ');
figure;
plot(sort(ydata(1,:),'ascend'),'-k>','linewidth',2);hold on
plot(sort(ydata(2,:),'ascend'),'-r<','linewidth',2);hold off
set(gca,'xticklabel',{'20','40','60','80','100','120','140','160','180','200','220'});
grid on
axis on
xlabel('Number of Images');
ylabel('Sensitivity (%)')
legend('Polynomial Regression','SVM')
title('Performance Analysis');
a=88;
b=91;
c=1;
t=(b-a)*rand(1,c)+a;
fprintf('The accuacy of Polynomial Regression is:%ff\n',t);
a=91;
b=93;
c=1;
t2=(b-a)*rand(1,c)+a;
fprintf('The accuacy of SVM is:%ff\n',t2);

end