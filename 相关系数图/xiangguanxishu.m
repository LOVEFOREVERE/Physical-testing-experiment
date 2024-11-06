data=xlsread(['yuce50.xlsx']);
for i=1:8
  data(:,i) = (data(:,i)- min(data(:,i))) / (max(data(:,i)) - min(data(:,i)));
end


CMP=corrMatPlot(data,'Format','triu','Type','pie');
CMP=CMP.setColorMap(1);
CMP=CMP.setLabelStr({'Height and Weight Score','vital capacity','50m','standing long jump','sit-up-and-bend' ,'1000m' ,'pull-up','Comprehensive score'});
CMP=CMP.draw();

data=xlsread(['yucenvz.xlsx']);
for i=1:8
  data(:,i) = (data(:,i)- min(data(:,i))) / (max(data(:,i)) - min(data(:,i)));
end


CMP=corrMatPlot(data,'Format','triu','Type','pie');
CMP=CMP.setColorMap(1);
CMP=CMP.setLabelStr({'Height and Weight Score','vital capacity','50m','standing long jump','sit-up-and-bend' ,'800m' ,'sit-up' ,'Comprehensive score'});
CMP=CMP.draw();