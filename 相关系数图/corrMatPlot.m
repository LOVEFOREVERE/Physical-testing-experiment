% x=xlsread(['财政收入.xlsx'])'; %1elm 2elm   3bp  4bp
% CMP=corrMatPlot(X,'Format','triu','Type','pie');
% CMP=CMP.setColorMap(1);
% CMP=CMP.draw();
% CMP.setLabelStr({'welcome','to','follow','my','wechat','official','account','slandarer'})
classdef corrMatPlot
    properties
        ax;drawn=false;
        arginList={'Labels','colorMap','Format','Type'}
        Labels={};
        colorMap={};
        baseCM={[189, 53, 70;255,255,255; 97, 97, 97]./255,...
                [113,161,195;255,255,255;228,103, 38]./255,...
                [ 28,127,119;255,255,255;204,157, 80]./255,...
                [130,130,255;255,255,255;255,133,133]./255,...
                [209,58,78;253,203,121;254,254,189;198,230,156;63,150,181]./255,...
                [243,166, 72;255,255,255;133,121,176]./255};
        Format='full'% full:完整矩阵 triu:上三角 tril:下三角
        Type='pie'    % sq   : 方形(默认)
                     % ssq  : 含文本方形
                     % pie  : 饼图
                     % circ : 圆形
                     % oval : 椭圆形
        XData;num;corrMat;
        % -----------------------------------------------------------------
        boxHdl;txtHdl;
        RLabelHdl;CLabelHdl;
        colorbarHdl
        matrixHdl
    end

    methods
        function obj=corrMatPlot(varargin)
            if isa(varargin{1},'matlab.graphics.axis.Axes')
                obj.ax=varargin{1};varargin(1)=[];
            else
                obj.ax=gca;
            end
            % 获取版本信息
            tver=version('-release');
            verMatlab=str2double(tver(1:4))+(abs(tver(5))-abs('a'))/2;
            if verMatlab<2017
                hold on
            else
                hold(obj.ax,'on')
            end
            % -------------------------------------------------------------
            obj.colorMap=obj.baseCM{1};
            obj.XData=varargin{1};varargin(1)=[];
            obj.corrMat=corr(obj.XData);
            obj.num=size(obj.corrMat,1);
            % 获取其他信息
            for i=1:(length(varargin)-1)
                tid=ismember(obj.arginList,varargin{i});
                if any(tid)
                obj.(obj.arginList{tid})=varargin{i+1};
                end
            end
            if isempty(obj.Labels)
                for i=1:obj.num
                    obj.Labels{i}=['class ',num2str(i)];
                end
            end
            help corrMatPlot
        end
% =========================================================================
        function obj=draw(obj)
            obj.ax.XLim=[.5,obj.num+.8];
            obj.ax.YLim=[.5,obj.num+.5];
            obj.ax.XTick=[];
            obj.ax.YTick=[];
            obj.ax.XColor='none';
            obj.ax.YColor='none';
            obj.ax.PlotBoxAspectRatio=[1,1,1];
            % 绘制boxHdl
            if strcmp(obj.Type(end-1:end),'sq');vb0='off';else,vb0='on';end
            switch obj.Format
                case 'full'
                    bX=[repmat([.5,obj.num+.5],[obj.num+1,1]),ones([obj.num+1,1]).*nan];
                    bY=[repmat((.5:1:obj.num+.5)',[1,2]),ones([obj.num+1,1]).*nan];
                    bXX=[bX;bY]';bYY=[bY;bX]';bXX=bXX(:);bYY=bYY(:);
                    obj.boxHdl=plot(bXX,bYY,'LineWidth',.8,'Color',[1,1,1].*.85,'Visible',vb0);
                case 'tril'
                    bX=[.5.*ones([obj.num+1,1]),(0:obj.num)'+1.5,ones([obj.num+1,1]).*nan];
                    bX(end,2)=bX(end,2)-1;
                    bY=[repmat((obj.num+.5:-1:.5)',[1,2]),ones([obj.num+1,1]).*nan];
                    bXX=[bX;bY]';bYY=[bY;bX]';bXX=bXX(:);bYY=bYY(:);
                    obj.boxHdl=plot(bXX,bYY,'LineWidth',.8,'Color',[1,1,1].*.85,'Visible',vb0);
                case 'triu'
                    bX=[(obj.num+.5).*ones([obj.num+1,1]),(obj.num:-1:0)'-.5,ones([obj.num+1,1]).*nan];
                    bX(end,2)=bX(end,2)+1;
                    bY=[repmat((.5:1:obj.num+.5)',[1,2]),ones([obj.num+1,1]).*nan];
                    bXX=[bX;bY]';bYY=[bY;bX]';bXX=bXX(:);bYY=bYY(:);
                    obj.boxHdl=plot(bXX,bYY,'LineWidth',.8,'Color',[1,1,1].*.85,'Visible',vb0);
            end

            colorFunc=colorFuncFactory(obj.colorMap);
            colormap(colorFunc(linspace(-1,1,100)));caxis([-1,1])
            cb=colorbar();
            % 绘制colorbar
            cb.Limits=[-1.02,1.02];
            cb.TickDirection='out';
            cb.LineWidth=.8;
            cb.Ticks=-1:.2:1;
            cb.FontName='Arial';
            cb.FontSize=11;
            obj.colorbarHdl=cb;

            for row=1:obj.num
                for col=1:obj.num  
                    tValue=obj.corrMat(row,col);
                    tColor=colorFunc(tValue);
                    tGray=1-rgb2gray(tColor);
                    baseT=linspace(0,2*pi,500);
                    thetaMat=[1,-1;1,1].*sqrt(2)./2;

                    vb1='on';
                    if strcmp(obj.Format,'triu')&&row>col,vb1='off';end
                    if strcmp(obj.Format,'tril')&&row<col,vb1='off';end
                    switch obj.Type
                        case 'sq'   % 方形
                            baseSqX=[-.5,.5,.5,-.5].*0.95;
                            baseSqY=[-.5,-.5,.5,.5].*0.95;
                            obj.matrixHdl(row,col).f=fill(baseSqX+col,baseSqY+1+obj.num-row,...
                                tColor,'EdgeColor','none','Visible',vb1);
                        case 'ssq'   % 含文本方形
                            baseSqX=[-.5,.5,.5,-.5].*0.95;
                            baseSqY=[-.5,-.5,.5,.5].*0.95;
                            obj.matrixHdl(row,col).f=fill(baseSqX+col,baseSqY+1+obj.num-row,...
                                tColor,'EdgeColor','none','Visible',vb1);
                            obj.matrixHdl(row,col).t=text(col,1+obj.num-row,...
                                sprintf('%.2f',obj.corrMat(row,col)),'FontName','Arial','FontSize',10,...
                                'HorizontalAlignment','center','Color',tGray,'Visible',vb1);
                        case 'pie'  % 饼图
                            baseCircX=cos(baseT).*.92.*.5;
                            baseCircY=sin(baseT).*.92.*.5;
                            obj.matrixHdl(row,col).c=fill(baseCircX+col,baseCircY+1+obj.num-row,...
                                [1,1,1],'EdgeColor',[1,1,1].*.3,'LineWidth',.8,'Visible',vb1);
                            baseTheta=linspace(pi/2,pi/2+tValue.*2.*pi,200);
                            basePieX=[0,cos(baseTheta).*.92.*.5];
                            basePieY=[0,sin(baseTheta).*.92.*.5];
                            obj.matrixHdl(row,col).f=fill(basePieX+col,basePieY+1+obj.num-row,...
                                tColor,'EdgeColor',[1,1,1].*.3,'lineWidth',.8,'Visible',vb1);
                        case 'circ' % 圆形   
                            baseR=(.25+.6.*abs(tValue)).*.5;
                            baseCircX=cos(baseT).*baseR;
                            baseCircY=sin(baseT).*baseR;
                            obj.matrixHdl(row,col).f=fill(baseCircX+col,baseCircY+1+obj.num-row,...
                                tColor,'EdgeColor','none','Visible',vb1);
                        case 'oval' % 椭圆形
                            baseA=1+(tValue<=0).*tValue;
                            baseB=1-(tValue>=0).*tValue;
                            baseOvalX=cos(baseT).*.98.*.5.*baseA;
                            baseOvalY=sin(baseT).*.98.*.5.*baseB;
                            baseOvalXY=thetaMat*[baseOvalX;baseOvalY];
                            obj.matrixHdl(row,col).f=fill(baseOvalXY(1,:)+col,baseOvalXY(2,:)+1+obj.num-row,...
                                tColor,'EdgeColor',[1,1,1].*.3,'lineWidth',.8,'Visible',vb1);
                    end
                    
                end
            end

            tfig=obj.ax.Parent;
            tfig.Position(2)=tfig.Position(2)./2;
            tfig.Position(4)=tfig.Position(3);
            tfig.Color=[1,1,1];

            for row=1:obj.num
                obj.RLabelHdl(row)=text(.42+(row-1).*strcmp(obj.Format,'triu'),obj.num+1-row,...
                    obj.Labels{row},'HorizontalAlignment','right',...
                    'FontName','Arial','FontSize',12);
            end
            for col=1:obj.num
                obj.CLabelHdl(col)=text(col-.1,obj.num+.75-(col-1).*strcmp(obj.Format,'tril'),...
                    obj.Labels{col},'HorizontalAlignment','left',...
                    'FontName','Arial','FontSize',12,'Rotation',30);
            end
            obj.drawn=true;

            % -------------------------------------------------------------
            % 渐变色句柄生成函数
            function colorFunc=colorFuncFactory(colorList)
                x=linspace(-1,1,size(colorList,1));
                y1=colorList(:,1);y2=colorList(:,2);y3=colorList(:,3);
                colorFunc=@(X)[interp1(x,y1,X,'linear')',...
                    interp1(x,y2,X,'linear')',interp1(x,y3,X,'linear')'];
            end
        end
% =========================================================================
        % 预设/设置colormap
        function obj=setColorMap(obj,CM)
            if length(CM)==1
                obj.colorMap=obj.baseCM{CM};
            else
                obj.colorMap=CM;
            end

            if obj.drawn
                colorFunc=colorFuncFactory(obj.colorMap);
                colormap(colorFunc(linspace(-1,1,100)));
                for row=1:obj.num
                for col=1:obj.num  
                    tValue=obj.corrMat(row,col);
                    tColor=colorFunc(tValue);
                    tGray=1-rgb2gray(tColor);
                    set(obj.matrixHdl(row,col).f,'FaceColor',tColor);
                    if strcmp(obj.Type,'ssq')
                        set(obj.matrixHdl(row,col).t,'Color',tGray)
                    end
                end
                end
            end

            % -------------------------------------------------------------
            % 渐变色句柄生成函数
            function colorFunc=colorFuncFactory(colorList)
                x=linspace(-1,1,size(colorList,1));
                y1=colorList(:,1);y2=colorList(:,2);y3=colorList(:,3);
                colorFunc=@(X)[interp1(x,y1,X,'linear')',...
                    interp1(x,y2,X,'linear')',interp1(x,y3,X,'linear')'];
            end
        end
        % XY轴标签设置
        function obj=setLabelStr(obj,LB)
            obj.Labels=LB;
            if obj.drawn
                for i=1:obj.num
                    set(obj.RLabelHdl(i),'String',obj.Labels{i});
                    set(obj.CLabelHdl(i),'String',obj.Labels{i});
                end
            end
        end

        function obj=setXLabel(obj,varargin)
            for i=1:obj.num
                set(obj.CLabelHdl(i),varargin{:})
            end
        end
        function obj=setYLabel(obj,varargin)
            for i=1:obj.num
                set(obj.RLabelHdl(i),varargin{:})
            end
        end
        % patch对象设置
        function obj=setPatch(obj,varargin)
            for row=1:obj.num
                for col=1:obj.num 
                    set(obj.matrixHdl(row,col).f,varargin{:});
                    if strcmp(obj.Type,'pie')
                        set(obj.matrixHdl(row,col).c,varargin{:},'FaceColor',[1,1,1])
                    end
                end
            end
        end
        % 设置数值文本
        function obj=setCorrTxt(obj,varargin)
            if strcmp(obj.Type,'ssq')
                for row=1:obj.num
                for col=1:obj.num  
                    set(obj.matrixHdl(row,col).t,varargin{:})
                end
                end
            end
        end       
        % 设置框样式
        function obj=setBox(obj,varargin)
            set(obj.boxHdl,varargin{:},'Visible','on')
        end
    end
% @author : slandarer
% gzh  : slandarer随笔
end







