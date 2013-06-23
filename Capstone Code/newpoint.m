function s2=newpoint(s1, pointname, pointarr)
% recieves structure containing datapoints, and adds new point pointarr
% with the name pointname
l=size(s1, 2);
s2=s1;
for i=1:l
    if s1(i).name==pointname
        cols=size(s1(i).mat, 2);
        s2(i).mat(:, cols+1)=transpose(pointarr);
        return
    end
end
s2(l+1).name=pointname;
s2(l+1).mat=pointarr';
end
