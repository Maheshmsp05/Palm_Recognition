clc;clear all;close all;warning off all;
%global fnd;
while(1)
    ch=menu('PALM PRINT RECOGNIZATION',...
            'Input image',...
            'Preprocessing',...
            'Segmentation',...
            'Edge Detection',...
            'Feature Extraction',...
            'Classification',...
            'Exit');
        if(ch==7)
            break;
        end
        if(ch==1)
            dicomlist = dir(fullfile('7','*.bmp'));
            figure;tn=1;ll=numel(dicomlist);
            for cnt = 1 : numel(dicomlist)
                img{cnt} = rgb2gray(imread(fullfile('7',dicomlist(cnt).name)));  
                 subplot(round(sqrt(ll)),round(sqrt(ll))+1,tn)
                imshow(uint16(img{cnt}),[])
                tn=tn+1;
            end
            tn=tn-1;
        end
        if(ch==2)
            %%%%%  Preprocessing
            disp('Preprocessing Started')
            figure;
            for i=1:tn
               nbc = size(img{i},1);
                X=img{i};
                 wname = 'coif2'; lev = 3;
                [c,s] = wavedec2(X,lev,wname);
                 det1 = detcoef2('compact',c,s,1);
                sigma = median(abs(det1))/0.6745;
                 alpha = 1.2;
                thr = wbmpen(c,s,sigma,alpha)
                % Use wdencmp for de-noising the image using the above
                % thresholds with soft thresholding and approximation kept.
                keepapp = 1;
                xd = wdencmp('gbl',c,s,wname,lev,thr,'s',keepapp);
                im1{i}=xd;
                subplot(round(sqrt(ll)),round(sqrt(ll))+1,i)
                imshow(im1{i},[])
            end
           disp('Preprocessing Ended')
        end 
        if(ch==3)          
            %Segmentation
            disp('Segmentation Started')
            dd='a';
            figure;
            for i1=1:tn
                
                level = graythresh(uint8(im1{i1}));
                I=im2bw(uint8(im1{i1}),level);
                [r c]=find(I);
                tt=length(r);
                tt1=round(tt/2);
                [P, J{i1}] = pattern_analys(im1{i1},[r(tt1) c(tt1)],70);
                
                subplot(round(sqrt(ll)),round(sqrt(ll))+1,i1)
                imshow(J{i1},[])
                [r c]=find(J{i1});
                fin(1:256,1:256)=0;
                for j=1:length(r)
                    fin(r(j),c(j))=uint8(im1{i1}(r(j),c(j)));
                end
                J1{i1}=fin;
            end
            disp('Segmentation Ended')
        end
        if(ch==4)
            %%%  Edge Detection
            disp('Edge Detection Started')
             figure;
            for i3=1:tn
                ed=J1{i3};
                 fuz{i3}=trimf(J1{i3},[min(ed(:)) mean(ed(:)) max(ed(:))]);
                [Iout,intensity,fitness,time]=fa_edge(J1{i3});
                Iout1{i3}=Iout;
               % Iedg{i3}=Iout|J{i3};
               Iedg{i3}=Iout;
                subplot(round(sqrt(tn)),round(sqrt(tn))+1,i3)
                imshow(Iout1{i3})
            end
            disp('Edge Detection Ended')
        end
        
        if(ch==5)
            disp('Feature Extraction Started')
           
            for i2=1:tn
                 I = Iedg{i2};
                 GLCM2 = graycomatrix(I,'Offset',[2 0;0 2]);
                 stats{i2} = texturefeat(GLCM2,0)
                 trfeat(i2,:)= cell2mat(struct2cell(stats{i2})')
            end
            disp('Feature Extraction Ended')
        end
        if(ch==6)
            disp('Classification Started')
            pause(.2);
            [file path]=uigetfile('*');
            II=rgb2gray(imread(strcat(path,file)));
            [fpath,na,et1] = fileparts(strcat(path,file));
              fnd=na(1:end-1);
            figure;imshow(II,[])
            nbc = size(II,1);
            X=II;
            wname = 'coif2'; lev = 3;
            [c,s] = wavedec2(X,lev,wname);
            det1 = detcoef2('compact',c,s,1);
            sigma = median(abs(det1))/0.6745;
            alpha = 1.2;
            thr = wbmpen(c,s,sigma,alpha);
            keepapp = 1;
            xd = wdencmp('gbl',c,s,wname,lev,thr,'s',keepapp);
            figure;
            imshow(xd,[])
             level = graythresh(uint8(xd));
                I=im2bw(uint8(xd),level);
                [r c]=find(I);
                tt=length(r);
                tt1=round(tt/2);
                [P, J] = pattern_analys(xd,[r(tt1) c(tt1)],70);
                figure;
                imshow(J,[])
                [r c]=find(J);
                fin(1:256,1:256)=0;
                for j=1:length(r)
                    fin(r(j),c(j))=uint8(im1{i1}(r(j),c(j)));
                end
                 ed=fin;
                 fuz{i3}=trimf(fin,[min(ed(:)) mean(ed(:)) max(ed(:))]);
                [Iout,thresh1,fitness,time]=bound_analy(fin,fnd);
           %     Iedg{i3}=Iout|J;
              Iedg{i3}=Iout;
                GLCM= graycomatrix(fin,'Offset',[2 0;0 2]);
              LL=load('label.txt');
              st=texturefeat(GLCM,0);
             tstfeat =cell2mat(struct2cell(st)');
             [thresh, YY] = multisvm(trfeat,LL,tstfeat);
             if(thresh1==1)
                 msgbox('The input image is user1 ');
             elseif (thresh1==0)
                 msgbox('The input image is user2 ');
             else
                  msgbox('The input image is user3 ');
             end            
              EV = Evaluate(LL,YY)*100;
        end
        
end  