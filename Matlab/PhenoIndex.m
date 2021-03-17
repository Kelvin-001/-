function PhenoIndex( path,canum )
%pathΪ�����ļ�����·��;
%   ���������Ƶ����λ��video;
%   ����ͼƬ�Ĵ洢λ��picture;
%   ������ɫ���εĴ洢λ��g;
%   ��������̶�ָ���Ĵ洢λ��Gcc,Gcc=g/(r+g+b);
%   ���ɾ����̶�ָ���Ĵ洢λ��ExG,ExG=2*g-(r+b);
%   �����̺�ֲ��ָ���Ĵ洢λ��GRVI,GRVI=��g-r)/(g+r);
%   canumΪ�����ţ�Ϊ����ͼƬ�洢����ʹ��

filepath = strcat(path,'\video');						%��Ƶ�ļ�λ��	
imgpath = strcat(path,'\picture');						%��Ƭ�ļ�λ��
gpath = strcat(path,'\g');                              %��ɫ����ͼ�ļ�λ��	
Gccpath = strcat(path,'\Gcc');                          %����̶�ָ��ͼ�ļ�λ��
ExGpath = strcat(path,'\ExG');                          %�����̶�ָ��ͼ�ļ�λ��
GRVIpath = strcat(path,'\GRVI');						%�̺�ֲ��ָ��ͼ�ļ�λ��
numd = 0;											   	%��ͬһ���ļ��ڲ�ͬ�ļ���ʱʹ�ã���ǰһ���ļ��е�����

videoname = dir(strcat(filepath,'\*.avi'));             %��ȡ��Ƶ�ļ�·���µ������ļ���׺Ϊ.avi���ļ�����
                                                        %dir��ȡָ���ļ������������ļ��к��ļ�
for i=1:1:length(videoname)                             %����matlab�ļ�·����ȡʱǰ����Ϊ'.��'..'�����Ǳ���ֻȡ.avi
    videofile=strcat(filepath,'\',videoname(i).name);   %��ȡ��i����Ƶ�ļ����ļ���
    m=VideoReader(videofile);                           %��ȡ��Ƶ�ļ�
    greend=(i+numd);                                    %ΪͼƬ�ļ��洢�ļ���������
    
    %Ϊ��ʹ�ļ���ʱ������洢����Ҫ��С��10������ǰ��00��������001��ʽ������10С��100ǰ��0������010��ʽ���������洢���ɡ�
    %ͬһ����24��ͼƬ����ͬ��ʹ�����ַ�����
    for j=1:1:24
        img=read(m,j);
        if greend <10 %��ע��˴�ӦΪ��ֵ�Ƚ�
            if j < 10									  
                 imwrite(img,strcat(imgpath,'\',canum,'_day00',num2str(greend),'_0',num2str(j),'.tif'));   %һ����ͼƬ˳��С��10��Ϊ01��ʽ
            else
                imwrite(img,strcat(imgpath,'\',canum,'_day00',num2str(greend),'_',num2str(j),'.tif'));
            end
        elseif greend < 100 && greend >= 10;
            if j < 10									  
                 imwrite(img,strcat(imgpath,'\',canum,'_day0',num2str(greend),'_0',num2str(j),'.tif'));   
            else
                imwrite(img,strcat(imgpath,'\',canum,'_day0',num2str(greend),'_',num2str(j),'.tif'));
            end
        else   
            if j < 10									 
                 imwrite(img,strcat(imgpath,'\',canum,'_day',num2str(greendd),'_0',num2str(j),'.tif'));   
            else
                imwrite(img,strcat(imgpath,'\',canum,'_day',num2str(greend),'_',num2str(j),'.tif'));
            end
        end
    end
end
'Video cut is over';    %��Ƶ�ָ�

picturename = dir(strcat(imgpath,'\*.tif'));                    %��ȡͼƬ�ļ�����.tif��ʽ���ļ���
for k=1:1:length(picturename)
    image = imread(strcat(imgpath,'\',picturename(k).name));
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);                                           %��ȡͼƬrgb��������
    Gcc=double(g)./(double(r)+double(b)+double(g));
    ExG = (2.*double(g))-(double(r)+double(b));	
    GRVI = double((double(g)-double(r))./(double(g)+double(r)));
    imwrite(g,strcat(gpath,'\',picturename(k).name));
    imwrite(Gcc,strcat(Gccpath,'\',picturename(k).name));
    imwrite(ExG,strcat(ExGpath,'\',picturename(k).name));
    imwrite(GRVI,strcat(GRVIpath,'\',picturename(k).name));      %�����ɵ�ͼƬ�洢��Ŀ��λ��
end
'PhenoIndex is over'   %����ָ��

end

