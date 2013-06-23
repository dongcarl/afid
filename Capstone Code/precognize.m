function [newavg, newcounters, name] = precognize(avg, counters, newarr, s)
% determines if user is performing an action by calculating averages and
% comparing to old averages to determine stability of sensor readings. If
% sensor readings are stable, isaction is called on the current sensor
% readings. 
newcounters=counters;

newavg=avg;
name=0;
newavg(counters(1)+1, :)=newarr;
newcounters(1)=mod(counters(1)+1, 10); 



if (newcounters(1)==0)
    newcounters(2)=mod(counters(2)+1, 5);
    newavg(counters(2)+11, :)=mean(newavg(1:10, :));
    last=mod(newcounters(2)+1, 5);
    diff=abs(newavg(newcounters(2)+11)-newavg(last+11));
    I=find(diff>15);
    if (size(I)==0)
        [newcounters(3), name]=ispaction(newarr, s, counters(3));
    elseif size(find(abs(newavg(newcounters(2)+11)-newavg(last+11)))>50)~=0
        newcounters(3)=0;
    end
end
end