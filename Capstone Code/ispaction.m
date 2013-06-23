function [newholding, gest]=ispaction(newarr, s, holding)
l=size(s, 2);
gestt=0;
prob=-1;
newarr=newarr';

for i=1:l
    newprob=prod(normpdf(newarr, s(i).params(:, 1), s(i).params(:, 2)));
    if newprob>prob
        gestt=s(i).name;
        prob=newprob;
    end
end
if (holding==0)&&(prob>10e-30)
    '!'
    gest=gestt
    newholding=1;
else
    gest=0;
    newholding=0;
end
end