function  logistics( y,thres)    %thres��ֵ���ٽ�ֵ��
name = inputname(1);   %���ڵõ�һ����������ı�ʶ������
[xx,yy]=shadow( y,name,thres);    %��Ӱ
half = fix(length(xx)/2);   %fix��0����ȡ��,ȡ��ֵhalf
%[cong,grotimeg,gromaxg] = logisticsg( xx(1:half),yy(1:half),name)  %������
[cond,grotimed,gromaxd] = logisticsd( xx(half:length(xx)),yy(half:length(xx)),name)   %˥����
end

