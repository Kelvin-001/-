function [con,grotime,gromax,I] = logisticsg( xx,yy,name)
%% logistics���
%name = inputname(2);   %���ڵõ�һ����������ı�ʶ������
%���ʼ��
d = min(yy);   %��Сֵ
c = max(yy)-d;   %��ֵ
half = fix(length(xx)/2);    %fix��0����ȡ��,ȡ��ֵhalf
f1=strcat(num2str(c),'/(1+exp(a0+(b0*',num2str(xx(half-3)),')))+',num2str(d),'=',num2str(yy(half-3)));  %��������ڵ�ָ����ʽ,3dΪһ��
f2=strcat(num2str(c),'/(1+exp(a0+(b0*',num2str(xx(half+3)),')))+',num2str(d),'=',num2str(yy(half+3)));
%f1=strcat(num2str(c),'/(1+exp(a0+(b0*',num2str(xx(half-6)),')))+',num2str(d),'=',num2str(yy(half-6)));
%f2=strcat(num2str(c),'/(1+exp(a0+(b0*',num2str(xx(half+6)),')))+',num2str(d),'=',num2str(yy(half+6)));
[a0,b0]=solve(f1,f2,'a0,b0');  %�����ʽ����ʽ
a0=roundn(double(a0),-4);  %roundn�������룬С�������λ
b0=roundn(double(b0),-4);
a0=a0(abs(imag(a0))<eps(a0));%�޳���������abs(imag(a0)�������־���ֵ
b0=b0(abs(imag(b0))<eps(b0));
beta0 = [a0 b0]    %��ʼ��
%����Ͻ��
ff=strcat(num2str(c),'./(1+exp(a(1)+(a(2).*xx)))+',num2str(d));     %��������ڵ�ָ��
fun=inline(ff,'a','xx');      %��������������������һ�������Ǳ��ʽ���������Ǻ�������
%fun=@(xx,a)(ff);
beta = nlinfit(xx,yy,fun,beta0);   %beta�����Ƴ��Ļع�ϵ����beta0���ع�ϵ����ʼֵ��nlinfit���ڷ��������
con = [beta c d];      %������
x = xx(1):0.01:xx(length(xx));
y = fun(beta,x);
% ��ͼ
figure    %�ܹ�����һ��������ʾͼ�������һ�����ڶ���
%subplot(211) 
plot(xx,yy,'r.',x,y)
axis([min(x),max(x),min(y)*0.98,max(y)*1.02]);      %���õ�ǰ������x���y������Ʒ�Χ
xlabel('������DOY��','fontsize',18);  %x�ᣬfontsize�����С18
ylabel(strcat(name),'fontsize',18);  %y�ᣬstrcatˮƽ�����ַ���
set(gca,'tickdir','out');  %gca���ص�ǰaxes����ľ��ֵ��set����ͼ�����ԣ�tickdir���Ƴ߱��λ�ã�out�߱꽫��������������
set(gca,'LineWidth',2);    %ָ���߿�Ϊ2
set(gca, 'FontSize', 18);    %�����С18
set(gca,'XTick',100:50:300);
set(gcf,'Position',[100 100 600 250]);   %gcf���ص�ǰfigure����ľ��ֵ
%mean
%set(gca,'YTick',0.2:0.2:0.6);%ExG��GCC,GRVI����Ҫ
%set(gca,'YTick',0.4:0.1:0.6)%Hueman
%per90
%set(gca,'YTick',0.4:0.2:0.8);%ExG��,GRVI����Ҫ
%set(gca,'YTick',0.85:0.05:0.95);%GCC
%set(gca,'YTickLabel',{'0.85','0.90','0.95'})%GCC
%set(gca,'YTick',0.55:0.05:0.65);%h
%set(gca,'YTickLabel',{'0.55','0.60','0.65'})%h
%set(gca,'YTick',0.04:0.01:0.07);%GRVI
box off    %����ͼ��߿�
set(gcf,'color','white'); %�趨figure�ı�����ɫ
A=getframe(gcf); %��ȡ�����������ݵ�ͼ��
imwrite(A.cdata,strcat('G:\Pheno Result\re\',name,'g1.jpg')) %�洢��������С��ͼƬ

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
   ky(i)= kdy(i)/kdx(i);    %����
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
% ��ͼ
figure     %�ܹ�����һ��������ʾͼ�������һ�����ڶ���
%subplot(212)   
uk=linspace(xx(1),xx(length(xx)),(length(x)-3));  %linspace���ڲ���xx(1),xx(length(xx))֮���(length(x)-3)����ʸ��
                                                  %xx(1),xx(length(xx))�ֱ�Ϊ��ʼֵ����ֵֹ��(length(x)-3)ΪԪ�ظ���
plot(uk,ky) 
axis([min(xx),max(xx),min(ky)*1.2,max(ky)*1.2]);     %���õ�ǰ������x���y������Ʒ�Χ
hold on;        %�ڻ��꺯������֮�󱣳�����ͼ������ͼ�񲻱�ˢ�£�
plot([xx(1),xx(length(xx))],[0,0],'--'); %��y=0
plot([gromax(2,1),gromax(2,1)],[gromax(2,2),0],'--'); %����������
hold off;     %ȡ��ԭ����ͼ
xlabel('������DOY��','fontsize',18);  %x��
ylabel(strcat(name,'���ʵ���'),'fontsize',18);   %y��
set(gca,'tickdir','out');    %gca���ص�ǰaxes����ľ��ֵ��set����ͼ�����ԣ�tickdir���Ƴ߱��λ�ã�out�߱꽫��������������
box off   %����ͼ��߿�
set(gca,'LineWidth',2);
set(gca, 'FontSize', 18);
set(gca,'XTick',100:50:200);
set(gcf,'Position',[100 100 600 250]);
%mean
%set(gca,'YTick',-10e-5:10e-5:0e-5);%ExGmean
%set(gca,'YTick',-10e-8:10e-8:0e-8);%GCC\GRVImean,H����Ҫ
%per90
%set(gca,'YTick',-10e-5:10e-5:0e-5);%ExG
%set(gca,'YTick',-10e-8:10e-8:0e-8);%GCC
%set(gca,'YTick',-10e-8:10e-8:1e-8);%GRVI
%set(gca,'YTickLabel',{'-5','1','1'})%grvi
set(gcf,'color','white'); %�趨figure�ı�����ɫ
A=getframe(gcf);  %��ȡ�����������ݵ�ͼ��
imwrite(A.cdata,strcat('G:\Pheno Result\re\',name,'g2.jpg')) %�洢��������С��ͼƬ
%% �����
%grotime=unique(grotime,'rows');
%ffc = strcat(num2str(c),'./(1+exp(',num2str(beta(1)),'+(',num2str(beta(1)),'.*xx)))+',num2str(d));
%func = inline(ffc,'xx');
%[m,n]=size(grotime);
%I = quad(func,grotime(1,1),grotime(m,1));
% ��ͼ
%figure
%subplot(313)
%plot(x,y)
%xlabel('DOY','fontsize',18);  %x��
%ylabel(strcat(name,'��ˮ��'),'fontsize',18);%y��
%hold on; 
%timepx=grotime(1,1):0.01:grotime(m,1);
%timepy=fun(beta,timepx);
%area(timepx,timepy,'FaceColor',[.85 .85 .85],'EdgeColor','r');%�������ֵ���ֵ��ɫ���ɵ��м䲿��
%axis([min(x),max(x),min(y)*0.98,max(y)*1.02]);
%set(gca,'tickdir','out')
%hold off;
%set(gca,'LineWidth',2);
%set(gca, 'FontSize', 18);
%set(gcf,'Position',[100 100 600 250]);
%set(gca,'XTick',100:50:300); 
%set(gca,'YTick',0:0.2:1);
box off;

%% ����
set(gcf,'Name','period of growth')    %���֣�������
%saveas(gcf,strcat('G:\Pheno Result\re\',name,'g.jpg'));
warning off MATLAB:xlswrite:AddSheet    %��matlab�������в���ʾ����
xlswrite(strcat('G:\Pheno Result\re\',name,'g.xlsx'), xx, 'xx'); 
xlswrite(strcat('G:\Pheno Result\re\',name,'g.xlsx'), yy, 'yy');
xlswrite(strcat('G:\Pheno Result\re\',name,'g.xlsx'), x, 'x'); 
xlswrite(strcat('G:\Pheno Result\re\',name,'g.xlsx'), y, 'y');
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), uk, 'uk'); 
xlswrite(strcat('G:\Pheno Result\re\',name,'d.xlsx'), ky, 'ky');
xlswrite(strcat('G:\Pheno Result\re\',name,'g.xlsx'), gromax, 'gromax'); 
%xlswrite(strcat('G:\Pheno Result\re\',name,'g.xlsx'), grotime, 'grotime'); 
%xlswrite(strcat('G:\Pheno Result\re\',name,'g.xlsx'), con, 'con'); 
%xlswrite(strcat('G:\Pheno Result\re\',name,'g.xlsx'), I, 'I');
end

