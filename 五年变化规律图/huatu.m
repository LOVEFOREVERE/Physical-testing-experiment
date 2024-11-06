data=xlsread('18-22.xlsx')';
N1=data(1,:); 
N2=data(3,:); 
N3=data(5,:); 
N4=data(7,:); 
N5=data(9,:); 
N6=data(11,:); 
N7=data(13,:); 
plot(N1,'black','linewidth',1)
hold on 
plot(N2,'color',[0.87 0.63 0.87],'linewidth',1);
hold on
plot(N3,'color',[0.18 0.55 0.34],'linewidth',1);
hold on
plot(N4,'color',[0.25 0.41 0.88],'linewidth',1);
hold on
plot(N5,'color',[0 0.78 0.55],'linewidth',1)
hold on
plot(N6,'color',[0.96 0.64 0.38],'linewidth',1);
hold on
plot(N7,'color',[0.61 0.4 0.12],'linewidth',1)
hold off
set(gca,'FontSize',20);
xlabel('particular year','FontSize', 20);
ylabel('value of score','FontSize', 20);
h=legend('Height and Weight Score','vital capacity','50m','standing long jump','sit-up-and-bend' ,'1000m' ,'pull-up' ,'FontSize', 20);
title('Five-Year Changes in Indicators of mans Physical Fitness Tests', 'FontSize', 20);
set(h,'Box','off');
% 设置x轴的刻度位置和标签
xticks(1:5);  % 假设每列数据代表一个年份，从1到5
xticklabels({'2018', '2019', '2020', '2021', '2022'});  % 设置刻度标签


data=xlsread('18-22.xlsx')';
N1=data(2,:); 
N2=data(4,:); 
N3=data(6,:); 
N4=data(8,:); 
N5=data(10,:); 
N6=data(12,:); 
N7=data(14,:); 
plot(N1,'black','linewidth',1)
hold on 
plot(N2,'color',[0.87 0.63 0.87],'linewidth',1);
hold on
plot(N3,'color',[0.18 0.55 0.34],'linewidth',1);
hold on
plot(N4,'color',[0.25 0.41 0.88],'linewidth',1);
hold on
plot(N5,'color',[0 0.78 0.55],'linewidth',1)
hold on
plot(N6,'color',[0.96 0.64 0.38],'linewidth',1);
hold on
plot(N7,'color',[0.61 0.4 0.12],'linewidth',1)
hold off
set(gca,'FontSize',20);
xlabel('particular year','FontSize', 20);
ylabel('value of score','FontSize', 20);
h=legend('Height and Weight Score','vital capacity','50m','standing long jump','sit-up-and-bend' ,'800m' ,'sit-up' ,'FontSize', 20);
title('Five-Year Changes in Indicators of girls Physical Fitness Tests', 'FontSize', 20);
set(h,'Box','off');
% 设置x轴的刻度位置和标签
xticks(1:5);  % 假设每列数据代表一个年份，从1到5
xticklabels({'2018', '2019', '2020', '2021', '2022'});  % 设置刻度标签

