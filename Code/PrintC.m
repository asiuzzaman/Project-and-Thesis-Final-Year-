function [] = PrintC(I,A,B)


[row,colum]=size(A);
 
id1=0;
id2=0;

for i=1:row
    for j=1:row
    
        if(A(i,1)==B(j,1) && A(i,2)==B(j,2))
            if(j<=i)
                id1=id1+1;
                plot(A(i,2),A(i,1),'r+');
                set1(id1)=i;
            else
                id2=id2+1;
                plot(A(i,2),A(i,1),'b+');
                set2(id2)=i;
            end
            
            break;
        end
    
    end
    

end


Xmin=1000;
Xmax=-1000;
Ymin=1000;
Ymax=-1000;

for i=1:id1
    Xmin=min(A(set1(i),2),Xmin);
    Xmax=max(A(set1(i),2),Xmax);
    Ymin=min(A(set1(i),1),Ymin);
    Ymax=max(A(set1(i),1),Ymax);
end

r=50;
x=Xmin+(r/2);
y=Ymax-(r/2);

th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,'r*');




Xmin=1000;
Xmax=-1000;
Ymin=1000;
Ymax=-1000;

for i=1:id2
    Xmin=min(A(set2(i),2),Xmin);
    Xmax=max(A(set2(i),2),Xmax);
    Ymin=min(A(set2(i),1),Ymin);
    Ymax=max(A(set2(i),1),Ymax);
end


r=50;
x=Xmin+(r/2);
y=Ymax-(r/2);


th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,'b*');



hold off

end

