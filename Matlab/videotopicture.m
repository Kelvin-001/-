clc;
clear;
     fileName = 'TLC00010.AVI';
    obj = VideoReader(fileName);
     numFrames = obj.NumberOfFrames;% ֡������
     for k = 1 : numFrames% ��ȡ����
     frame = read(obj,k);
     imshow(frame);%��ʾ֡
     imwrite(frame,strcat(num2str(k),'.jpg'),'jpg');% ����֡
end
