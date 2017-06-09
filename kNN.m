clc
clear
close all

%K number of nearest neighbours
K=3;

%create 2 classes Blue and Red
N=20;
Blue=randn(2,N);
Red=randn(2,N);

%create a bunch of random points to classify
n=20;
Black=randn(4,n);

%before classification
plot(Blue(1,:),Blue(2,:),'bo',Red(1,:),Red(2,:),'ro'...
    ,Black(1,:),Black(2,:),'kx');
title('Before Classification');



%euclidean distances between every black point and
%every blue and red point
db=zeros(N,n);
dr=zeros(N,n);
for i=1:length(Blue)
    for j=1:length(Black)
        db(i,j)=sqrt(((Blue(1,i)-Black(1,j)).^2+((Blue(2,i)-Black(2,j)).^2)));
        dr(i,j)=sqrt(((Red(1,i)-Black(1,j)).^2+((Red(2,i)-Black(2,j)).^2)));
    end
end

%sort distances for every black point

 blktobludist=sort(db);
 blktoreddist=sort(dr);


%take only first K distances for every black point
Kblktobludist=blktobludist(1:K,:);
Kblktoreddist=blktoreddist(1:K,:);

X=zeros(1,length(Black));
Kblktobludist=vertcat(Kblktobludist,X);
Kblktoreddist=vertcat(Kblktoreddist,X);

%Compare both the distance vectors find the first K nearest whether 
%blue or red
for j=1:length(Black)
    blu=0;
    red=0;
    weightedblu=0;
    weightedred=0;
    count=0;
    temp1=Kblktobludist(1,j);
    temp2=Kblktoreddist(1,j);
    while blu+red < K
        if temp1<temp2
            blu=blu+1;
            
            %assigning weights to blue points
            weightedblu= weightedblu + (K-count)/(K*(K+1)/2);
            count=count+1;
            temp1=Kblktobludist(blu+1,j);
        else
            red=red+1;
            
            %assigning weights to red points
            weightedred= weightedred + (K-count)/(K*(K+1)/2);
            count=count+1;
            temp2=Kblktoreddist(red+1,j);
        end
       
        blupointsdist=Kblktobludist(1:blu,j);
        redpointsdist=Kblktoreddist(1:red,j);
        
        %K nearest neightbours compare no. of blue and red
        if blu>red
            tag = 1;
        else
            tag = 0;
        end
    
        if tag==1
            Black(3,j)=1;
        else
            Black(3,j)=0;
        end
        
        %Compare weights of K nearest neighbours
        if weightedblu>weightedred
            tag = 1;
        else
            tag = 0;
        end
    
        if tag==1
            Black(4,j)=1;
        else
            Black(4,j)=0;
        end
    end
end

%assigning matrices for kNN
Blux=zeros(4,length(Black));
Redx=zeros(4,length(Black));
for k=1:length(Black)
    if Black(3,k)==1
        Blux(:,k)=Black(:,k);
    else 
        Redx(:,k)=Black(:,k);
    end
end

%assigning matrices for kNN with weights
wBlux=zeros(4,length(Black));
wRedx=zeros(4,length(Black));
for k=1:length(Black)
    if Black(4,k)==1
        wBlux(:,k)=Black(:,k);
    else 
        wRedx(:,k)=Black(:,k);
    end
end


figure
plot(Blue(1,:),Blue(2,:),'bo',Red(1,:),Red(2,:),'ro'...
   ,Blux(1,:),Blux(2,:),'bx', Redx(1,:),Redx(2,:),'rx');
title('After kNN classification');


figure
plot(Blue(1,:),Blue(2,:),'bo',Red(1,:),Red(2,:),'ro'...
   ,wBlux(1,:),wBlux(2,:),'bx', wRedx(1,:),wRedx(2,:),'rx');
title('After kNN weighted classification');




