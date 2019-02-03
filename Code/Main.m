clc;
close all;
clear;
KK=10;
XX=zeros(100,2);
addpath('jlinkage');
addpath('C:\vlfeat-0.9.20\toolbox');%%%%
vl_setup;%Initialize VLFeat
show=1;
%Get File
[name, path]=uigetfile({'*.jpg;*.png;*.bmp;*.tif','Images (*.jpg,*.png,*.bmp,*.tif)'},'Select An Image');
if isequal(name,0)
    error('User selected Cancel');
end
tic;
filename=fullfile(path, name);
%%%% initializations
RGBimage=imread(filename);
tic;%record time for calculate elapsed time
T=0.1; %threshold for G2NN Test %%output varies depending on threshold change.

min_distance=16;
grayimage=rgb2gray(RGBimage);

imshow(grayimage);
corners = detectFASTFeatures(grayimage);


moment01=0;
moment10=0;
  for i=1:corners.Count
  x=corners.Location(i,1);
  y=corners.Location(i,2);
  moment01=moment01+y;
  moment10=moment10+x;
  end
theta=atan(moment01/moment10);
%figure, imshow(im/4);
  
 imshow(grayimage); hold on;
 plot(corners.selectStrongest(10000));

fn=0;

for i=1:size(corners.Location)
   x=corners.Location(i,1);
   y=corners.Location(i,2);
    if x<y
    fn=fn+(2.^(i-1));
    end
end
%disp(fn);
matrix=[cos(theta) -sin(theta); sin(theta) cos(theta)];
ORBDescriptors=matrix*corners.Location';
[Loc,ORBDescriptors]= vl_sift(single(grayimage));
Loc=Loc([2,1,3,4],:)';

%disp(size(ORBDescriptors));
%new=ORBDescriptors;
ORBDescriptors=ORBDescriptors';
%new1=ORBDescriptors;
%Descriptor Normalization
ORBDescriptors=double(ORBDescriptors);
%new2=ORBDescriptors;
ORBDescriptors=ORBDescriptors./repmat(NormRow(ORBDescriptors,2),1,128);
new3=ORBDescriptors;
 figure;
 imshow(RGBimage);
 hold on
 for i = 1: size(Loc,1)
     plot(Loc(i,2), Loc(i,1), 'r*');
 end

[num_keypoint ,~]=size(ORBDescriptors);
[n_rows,n_columns,~]=size(RGBimage);

[LL,CC,num_L]=kmeans_plus_plus(XX,KK,ORBDescriptors,num_keypoint);

%%%% Matching
%num_L=num_keypoint;
Match_Mat=false(num_L);
maximum=min(20,num_L);
[distances,index]=pdist2(ORBDescriptors,ORBDescriptors,'euclidean','smallest',maximum);
for u=1:num_L
    for v=2:maximum-1
        if (distances(v,u)<=distances(v+1,u)*T)
            if norm(Loc(u,1:2)-Loc(index(v,u),1:2))<min_distance
                continue;
            end
            Match_Mat(u,index(v,u))=1;
            Match_Mat(index(v,u),u)=1;
        else
            break;
        end
    end
end
num_match=sum(Match_Mat(:));
disp('No of matches');
disp(num_match);
[t1,t2]=find(Match_Mat);
matchIndices=[t1,t2];

%Show Match Keypoints
if (show==1)
    figure;
    imshow(RGBimage);
    hold on;
    title('Match Keypoints');
    loc1_temp=Loc(matchIndices(:,1),1:2);
    loc2_temp=Loc(matchIndices(:,2),1:2);
    locs_temp=[loc1_temp;loc2_temp];
    plot(locs_temp(:,2),locs_temp(:,1),'go');%Show points
    temp=[loc1_temp,loc2_temp,nan(size(loc2_temp,1),4)]';
    locs_temp=reshape(temp(:),4,[]);
    plot([locs_temp(2,:);locs_temp(4,:)],[locs_temp(1,:);locs_temp(3,:)],'b-');
    
end
   
PrintC(RGBimage,loc1_temp,loc2_temp);
toc;