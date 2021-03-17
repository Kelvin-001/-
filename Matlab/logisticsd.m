function [con,grotime,gromax] = logisticsd( xx,yy,name)
%% logistics���
%name = inputname(2);   %���ڵõ�һ����������ı�ʶ������
%���ʼ��
d = min(yy);    %��Сֵ
c = max(yy)-d;   %��ֵ
half = fix(length(xx)/2);   %fix��0����ȡ��,ȡ��ֵhalf
f1=strcat(num2str(c),'/(1+exp(a0+(b0*',num2str(xx(half-3)),')))+',num2str(d),'=',num2str(yy(half-3)));    %��������ڵ�ָ����ʽ,3dΪһ��
f2=strcat(num2str(c),'/(1+exp(a0+(b0*',num2str(xx(half+3)),')))+',num2str(d),'=',num2str(yy(half+3)));
[a0,b0]=solve(f1,f2,'a0,b0');  %�����ʽ����ʽ
a0=roundn(double(a0),-4);    %roundn�������룬С�������λ
b0=roundn(double(b0),-4);
a0=a0(abs(imag(a0))<eps(a0));%�޳���������abs(imag(a0)�������־���ֵ
b0=b0(abs(imag(b0))<eps(b0));
beta0 = [a0 b0];    %��ʼ��
%����Ͻ��
ff=strcat(num2str(c),'./(1+exp(a(1)+(a(2).*xx)))+',num2str(d));    %��������ڵ�ָ��
fun=inline(ff,'a','xx');      %��������������������һ�������Ǳ��ʽ���������Ǻ�������
beta = nlinfit(xx,yy,fun,beta0);   %beta�����Ƴ��Ļع�ϵ����beta0���ع�ϵ����ʼֵ��nlinfit���ڷ��������
con = [beta c d];      %������
x = xx(1):0.01:xx(length(xx));
y = fun(beta,x);
%��ͼ
figure    %�ܹ�����һ��������ʾͼ�������һ�����ڶ���
%subplot(211) 
plot(xx,yy,'r.',x,y)    
axis([min(x),max(x),min(y)*0.98,max(y)*1.02]);      %���õ�ǰ������x���y������Ʒ�Χ
set(gca,'tickdir','out')    %gca���ص�ǰaxes����ľ��ֵ��set����ͼ�����ԣ�tickdir���Ƴ߱��λ�ã�out�߱꽫��������������
xlabel('������DOY��','fontsize',18);  %x�ᣬfontsize�����С18
ylabel(strcat(name),'fontsize',18);  %y�ᣬstrcatˮƽ�����ַ���
set(gca,'LineWidth',2);   %ָ���߿�Ϊ2
set(gca, 'FontSize', 18);   %�����С18
set(gca,'XTick',250:50:300); 
set(gcf,'Position',[100 100 600 250]);   %gcf���ص�ǰfigure����ľ��ֵ
%mean%grvi
%set(gca,'YTick',0.01:0.01:0.03);%%grvi
%set(gca,'YTick',0.45:0.1:0.55);%h
%per90
%set(gca,'YTick',0.2:0.2:1);%ExG
%set(gca,'YTick',0.85:0.05:0.95);%GCC
%set(gca,'YTickLabel',{'0.85','0.90','0.95'})%GCC
%set(gca,'YTick',0.55:0.05:0.65);%h
%set(gca,'YTickLabel',{'0.55','0.60','0.65'})%h
%set(gca,'YTick',0.06:0.01:0.08);%GRVI
box off   %����ͼ��߿�

set(gcf,'color','white'); %�趨figure�ı�����ɫ
A=getframe(gcf);  %��ȡ�����������ݵ�ͼ��

imwrite(A.cdata,strcat('G:\Pheno Result\re\',name,'d1.jpg')) %�洢��������С��ͼƬ

imwrite(A.cdata,strcat('G:\Pheno Result\re\',name,'d1.jpg')) %�洢��������С��ͼƬ

%% б�ʼ���  
for i=1:(length(x)-1)  
   dx(i)=x(i+1)-x(i);  
   dy(i)=y(i+1)-y(i);              % ��ɢһ�ε����൱������һ�ε�����  
   dddy(i)= dy(i)/dx(i);      %��y/��x
end  
  
%% ���ʼ���  
for i = 1 : (length(x)-2)  
   ddx(i) = dx(i+1) - dx(i);  
   ddy(i) = dy(i+1) - dy(i);      % ��ɢ���β��(�൱���������ε�)  
   K(i)=(dx(i)*ddy(i)-dy(i)*ddx(i))/((dx(i)*dx(i)+dy(i)*dy(i))^1.5); % ���ʣ����ʰ뾶k  
end     

%% ���ʵ������� 
n = 1;
for i=1:(length(x)-3)  
   kdx(i)=x(i+1)-x(i);  
   kdy(i)=K(i+1)-K(i);                
   ky(i)= kdy(i)/kdx(i);      %����
   if i > 1 && ky(i)*ky(i-1) < 0
       grotime(n,2)=fix(ky(i));      %�����ڵĿ�ʼ�ͽ���
       grotime(n,1)=fix(x(i));
       n=n+1;
   end 
end

[gromax(1,2),loc1] = max(ky);   %locλ������
[gromax(2,2),loc2] = min(ky);
gromax(1,1)=x(loc1);            %��������ʢ��ʱ��
gromax(2,1)=x(loc2);
hold on       %�ڻ��꺯������֮�󱣳�����ͼ������ͼ�񲻱�ˢ�£�
figure       %�ܹ�����һ��������ʾͼ�������һ�����ڶ���
uk=linspace(xx(1),xx(length(xx)),(length(x)-3)); %linspace���ڲ���xx(1),xx(length(xx))֮���(length(x)-3)����ʸ��
                                                 %xx(1),xx(length(xx))�ֱ�Ϊ��ʼֵ����ֵֹ��(length(x)-3)ΪԪ�ظ���  
plot(uk,ky) 
axis([min(xx),max(xx),min(ky)*1.2,max(ky)*1.2]);     %���õ�ǰ������x���y������Ʒ�Χ
hold on;        %�ڻ��꺯������֮�󱣳�����ͼ
plot([xx(1),xx(length(xx))],[0,0],'-'); %����������
plot([gromax(1,1),gromax(1,1)],[gromax(1,2),0],'--'); %����С������

set(gca,'tickdir','out')   %gca���ص�ǰaxes����ľ��ֵ��set����ͼ�����ԣ�tickdir���Ƴ߱��λ�ã�out�߱꽫��������������
hold off;    %ȡ��ԭ����ͼ
xlabel('������DOY��','fontsize',18);  %x��
ylabel(strcat(name,'���ʵ���'),'fontsize',18);   %y��
box off   %����ͼ��߿�
set(gcf,'Name','Decline period')    %���֣�˥����
set(gca,'LineWidth',2);
set(gca, 'FontSize', 18);
set(gca,'XTick',200:50:350);
set(gcf,'Position',[100 100 600 250]);
%mean
%set(gca,'YTick',0:4e-6:8e-6);%exg
%set(gca,'YTick',0:10e-8:10e-8);%gcc
%set(gca,'YTick',0:4e-8:4e-8);%grvi
%set(gca,'YTick',0:4e-7:4e-7);%hue
%per90
%set(gca,'YTick',0:4e-6:4e-6);%exg
%set(gca,'YTick',0:4e-8:4e-8);%gcc
set(gca,'YTick',-1.4e-8:0.4e-8:-0.6e-8);%grvi
set(gcf,'color','white'); %�趨figure�ı�����ɫ
A=getframe(gcf);  %��ȡ�����������ݵ�ͼ��
imwrite(A.cdata,strcat('G:\Pheno Result\re\',name,'d2.jpg')) %�洢��������С��ͼƬ
warning off MATLAB:xlswrite:AddSheet    %��matlab�������в���ʾ����

xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), xx, 'xx'); 
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), yy, 'yy');
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), x, 'x'); 
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), y, 'y');
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), uk, 'uk'); 
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), ky, 'ky');
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), gromax, 'gromax');
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), con, 'con'); 
%grotime=unique(grotime,'rows');
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), grotime, 'grotime'); 


end

