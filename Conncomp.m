function [cc] = Conncomp(I,connectivity,V)
%%PRE-PROCESSING PHASE:using V to convert image into binary image
[m,n]=size(I);
for i=1:m
    for j=1:n
        if sum(I(i,j)==V)>0
            I(i,j)=1;
        else
            I(i,j)=0;
        end
    end
end
%%PHASE I
%Step1:raster scan
L=zeros(m,n);
label=0;
eq_cls=[];
for i=1:m
    for j=1:n
        %neighbourhood check
        b=i-1;  
        c=i+1;
        d=j-1;
        e=j+1;
        [x1,x2,x3,x4,x5,x6,x7,x8]=nbh(L,i,j,m,n,b,c,d,e);
        %neighbourhood label matrix
        if connectivity==4
            x=[x2,x4];
        else
            x=[x1,x2,x3,x4];
        end
        x=x(x~=realmax);
        % COND.1:if pixel value is 0 
        if I(i,j)==0
            L(i,j)=0;
        else
            %removing zeros from the neighbourhood label matrix
                x=x(x~=0);
            %COND.2:if pixel value is in V and neighbourhood isn't in V
            if  isempty(x)==1
                label=label+1;
                L(i,j)=label;
            else
                %sorting x for redundant matrix x
                x=bubble_srt(x);
                y=[];
                jx=1;
                terminate=0;
                for ix=1:length(x)
                    y=[y,x(jx)];
                    while(y(end)==x(jx))
                        jx=jx+1;
                        if jx>length(x)
                            terminate=1;
                            break
                        end
                    end
                    if terminate==1
                        break
                    end
                end
                x=y;
                %COND.3,4:if pixel value in V and neighbourhood also in V
                L(i,j)=x(1);
                %equivalent class
                len_x=length(x);
                if len_x>1
                    v=x;
                    while length(v)<4
                        v=[v,0];
                    end
                    eq_cls=[eq_cls;v];
                end
            end
        end
    end
end
%total number of classes after phase 1
if length(eq_cls)~=0%isempty(eq_cls)==0%%%%%%%%%%%correcetion needed
    %sorting equivalent class 1st column
    ecc=eq_cls(:,1);
    [ec1,ec2]=bubble_srt(ecc);
    clear ec1
    %reducing duplicate rows
    eq_cls=eq_cls(ec2,:);
    y=[];
    jx=1;
    terminate=0;
    [ex,ey]=size(eq_cls);
    for ix=1:ex
        y=[y;eq_cls(jx,:)];
        while(y(end,:)==eq_cls(jx,:))
            jx=jx+1;
            if jx>ex
                terminate=1;
                break
            end
        end
        if terminate==1
            break
        end
    end
    eq_cls=y;
    %PHASE II
    [ex,ey]=size(eq_cls);
    for li=ex:-1:1
        c=eq_cls(li,:);
        c=c(c~=0);
        for k1=1:m
            for k2=1:n
                if sum(L(k1,k2)==c)>0
                    L(k1,k2)=min(c);
                end
            end
        end
    end
end
% unique elements in martrix L since label are not consecutive number
uni=[realmax];
[rl,cl]=size(L);
for lx=1:rl
    for ly=1:cl
        c=L(lx,ly);
        lz=1;
        while lz<=length(uni)
            if c==uni(lz)
                break
            end
            lz=lz+1;
        end
        if lz>length(uni)
            uni(lz)=c;
        end
    end
end
uni(1)=[];%to drop realmax and zero
uni=uni(uni~=0);
%assign consecutive class number
for lx=1:rl
    for ly=1:cl
        c=L(lx,ly);
        for lz=1:length(uni)
            if uni(lz)==c
                L(lx,ly)=lz;
                break
            end
        end
    end
end
cc=L;
end