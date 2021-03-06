ifPlot=1;
% 比對pv和Pnsdf
waveDir='D:\LAB\wave';
waveDir=strrep(waveDir, '\', '/');
allWaves=recursiveFileList(waveDir, 'wav');
waveNum=length(allWaves);
%waveNum=10;
fprintf('從 "%s" 讀取了 %d 個 wav 檔案\n', waveDir, waveNum);
totalTime=0;
allscore=[];
Rdata=zeros(1,22); % 記錄正確點數  index表音高差在i個半音以內 表示0~10 and inf
%Wdata=zeros(1,11); % 記錄錯誤點數  index表音高差在i個半音內
%waveNum=1;
for i=1:waveNum
	tic;
    fprintf('%d/%d: Check the pitch of %s...\n', i, waveNum, allWaves(i).path);
	pvFile = [allWaves(i).path(1:end-3) 'pv'];
    nsdfFile = [allWaves(i).path(1:end-3) 'Pnsdf'];	
    % 讀取人工標音 pitch
    fp1 = fopen(pvFile,'r');
    pVector = fscanf(fp1,'%g');
    fclose(fp1);
    % 讀取nsdf標音 pitch
    fp2 = fopen(nsdfFile,'r');
    nVector = fscanf(fp2,'%g');
    fclose(fp2);
    % 選擇短pitch的為準
    NumP = length(pVector);
    NumN = length(nVector);
    CNum = min(NumP,NumN);
    % 目標index，只計算兩者些不是0的音高點
    targetI = find(pVector(1:CNum)>0 & nVector(1:CNum)>0);
    result = ceil(abs(pVector(targetI)-nVector(targetI))); % 相減的結果，並以ceil分類
    for j=1:length(result)
        if result(j) > 20
            index=21;
        else
            index=result(j);
        end
        for k=1:22
            if k-1 >= index
                Rdata(k) = Rdata(k) + 1;
            end
        end
    end
	t=toc;
	fprintf('used time=%g\n',t);
	totalTime=totalTime+toc;
end
fprintf('all points=%d\n',Rdata(22));
fprintf('totalTime=%g   averageTime=%g\n',totalTime,totalTime/waveNum);
if ifPlot
    x=0:21;
    plot(x,Rdata*100/Rdata(22),'-o');
    title('NSDF計算pitch與人工標示pitch辨識率');
    xlabel('相差音高(半音)');
    ylabel('辨識率(%)');
    axis([0,21,floor(Rdata(1)*100/Rdata(22)),inf]);
    grid on;
end

    
