%% DELMѵ������
%����-----------------------
%P_train �������ݣ����ݸ�ʽΪN*dim,N��������������dim��������ά�ȡ�
%T_train �����ǩ����
%ActiveF Ϊ���������'sig','sin','hardlim','tribas'�ȡ�
%CΪ����ϵ��
%����� outWeightΪ���Ȩ��
function OutWeight = DELMTrain(P_train,T_train,ELMAEhiddenLayer,ActivF,C)
hiddenLayerSize = length(ELMAEhiddenLayer); %��ȡELM-AE�Ĳ���
outWieght = {};%���ڴ�����е�Ȩ��
P_trainOrg = P_train;
%% ELM-AE��ȡ��������
for i = 1:hiddenLayerSize
    [~,B,Hnew] = ELM_AE(P_train,ActivF,ELMAEhiddenLayer(i)); %��ȡȨ��
    OutWeight{i} = B';
    P_train =P_train*B'; %���뾭����һ��󴫵ݸ���һ��
end
%% ���һ��ELM���мලѵ��
P = P_train;
N =size(P,2);
I = eye(N);
beta = pinv((P'*P+I/C))*P'*T_train;
OutWeight{hiddenLayerSize + 1} = beta; %�洢���һ��ELM����Ϣ��
end