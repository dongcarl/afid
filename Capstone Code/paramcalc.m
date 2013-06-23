M=csvread('1.dat');
all=[M,zeros(30,1)+1];
for i=2:24
    M=csvread(strcat(int2str(i),'.dat'));
    all=[all;[M,zeros(30,1)+i]];
end

varmat=zeros(24, 10);
meanmat=zeros(24, 10);

for j=1:24
    meanmat(j, :)=mean(all((j-1)*30+1:j*30, 1:10), 1);
    varmat(j, :)=std(all((j-1)*30+1:j*30, 1:10), 0, 1);
end
avgvar=mean(varmat, 2);
for j=1:24
    allavg((j-1)*30+1:j*30, :)=all((j-1)*30+1:j*30, 1:10)-ones(30, 1)*meanmat(j, :);
end
avglines=zeros(30, 10);
for j=1:24
    avglines=avglines+allavg((j-1)*30+1:j*30, :);
end
avglines=avglines/24;
totavgline=mean(avglines, 2);
figure(1)
plot(totavgline)
axis([1, 30, -10, 10])
figure(2)
for i=1:10
    subplot(5, 2, i)
    vect=avglines(:, i)';
    plot(vect)
    axis([1, 30, -10, 10])
end
    