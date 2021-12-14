clc
ii=0;
H=[];
M=[];
ParaLH = [];
ParaLM = [];
HM=[];

AUTH = ones([1,28]);
AUTH(15:28)=-1;

for ii = 1:14 
    H = [H ; lower(importdata(['H' num2str(ii) '.txt']))];
    ParaLH = [ParaLH length(H)];
    M = [M ; lower(importdata(['M' num2str(ii) '.txt']))];

    ParaLM = [ParaLM length(M)];
end

ii=0;
ParaLHM = [];
for ii = 1:8 
    HM = [HM ; lower(importdata(['HM' num2str(ii) '.txt']))];
    ParaLHM = [ParaLHM length(HM)];
end



ii=0;


Hstr = lower(string(H));
Mstr = lower(string(M));
HMstr = lower(string(HM));

ii = 0;
H1=[''];

for ii = 1:length(Hstr)
    H1 = append(H1, Hstr(ii));
end


M1=[''];
for ii = 1:length(Mstr)
    M1 = append(M1, Mstr(ii));
end

ii=0;
HM1=[''];
for ii = 1:length(HMstr)
    HM1 = append(HM1, HMstr(ii));
end

Hwords = strsplit(H1);
Mwords = strsplit(M1);
HMwords = strsplit(HM1);

words = [Hwords Mwords HMwords];

words=unique(words);


ii=0;
jj=0;
Mw=zeros([length(M), length(words)]);

for jj = 1:length(M)

    for ii = 1:length(words)
    
    Mw(jj,ii) = count(M(jj),words(ii));

    end
end


ii=0;
jj=0;

Hw=zeros([length(H), length(words)]);

for jj = 1:length(H)

    for ii = 1:length(words)
    
    Hw(jj,ii) = count(H(jj),words(ii));

    end
end




ii=0;
jj=0;
HMw=zeros([length(HM), length(words)]);

for jj = 1:length(HM)

    for ii = 1:length(words)
    
    HMw(jj,ii) = count(HM(jj),words(ii));

    end
end

%% 



ii=0;

Para = [1 ParaLH];
SumH = [];
SumM = [];
for ii = 1:length(ParaLH)
    
    Second = Para(ii+1);
    First = Para(ii);
    
    SumH = [SumH ; sum(Hw(First:Second,:),1)];
end
%% 


ii=0;

Para = [1 ParaLM];

for ii = 1:length(ParaLM)
    
    Second = Para(ii+1);
    First = Para(ii);
    
    SumM = [SumM ; sum(Mw(First:Second,:),1)];
end


%% 


ii=0;

Para = [1 ParaLHM];
SumHM = [];

for ii = 1:length(ParaLHM)
    
    Second = Para(ii+1);
    First = Para(ii);
    
    SumHM = [SumHM ; sum(HMw(First:Second,:),1)];
end



%% 


H2 = (ones([1 , 14])');
M2 = (ones([1 , 14])' * -1);
AUTHORS = [H2 ; M2];

DATA = [SumH ; SumM];

%nftool
%% 

NFToolAuthors

AUTHORS_est = net(DATA');
HM_est = net(SumHM');

%{
AUTHORS_est = net(DATA');

HM_est = net(HMw');

ParaLM = ParaLM+ParaLH(end);
ParaL=[ParaLH ParaLM];


ii=0;

Para = [1 ParaL];
Average = [];

for ii = 1:length(ParaL)
    
    Second = Para(ii+1);
    First = Para(ii);
    
    Average = [Average mean(AUTHORS_est(First:Second))];
end


Average(Average>0) = 1;
Average(Average<0) = -1;

Difference = abs(Average - AUTH);
Wrong = sum(Difference)/2
Accuracy = 1-Wrong/length(Difference)





ii=0;

Para = [1 ParaLHM];
Average = [];

for ii = 1:length(ParaLHM)
    
    Second = Para(ii+1);
    First = Para(ii);
    
    Average = [Average mean(HM_est(First:Second))];
end

Average
Average(Average>0) = 1;
Average(Average<0) = -1;

Contested = Average




%}


subplot(2,1,1)
title('Analyzing the Known Federalist Papers Using Word Vectors')
xlabel('Hamilton (Left), Madison (Right)')
ylabel('Madison (Bottom), Hamilton (Top)')
hold on
yline(0)
xline(14+0.5)
%xline(length(H)+0.5,'r')

scatter(1:length(AUTHORS_est),AUTHORS_est,'b')

subplot(2,1,2)
hold on
title('Analyzing Paragraphs from the Contested Federalist Papers Using Word Vectors')
yline(0)
%xline(ParaLHM+0.5)
xlabel('Contested Federalist Papers')
ylabel('Madison (Bottom), Hamilton (Top)')
scatter(1:length(HM_est),HM_est,'b')