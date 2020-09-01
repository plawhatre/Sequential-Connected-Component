function [a,ai] = bubble_srt(a)
l=length(a);
ai=1:l;
for k=1:(l-1)
    for s=1:(l-1)
        if a(s)>a(s+1)
            %value swap
            temp1=a(s);
            a(s)=a(s+1);
            a(s+1)=temp1;
            %optional:nargout
            if nargout>1
                temp2=ai(s);
                ai(s)=ai(s+1);
                ai(s+1)=temp2;
            end
        end
    end
end
end

