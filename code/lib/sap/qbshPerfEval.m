function [recogRate, waveData, songDb]=qbshPerfEval(songDb, waveData, qbshOpt, showPlot)
% qbshPerfEval: QBSH performance evaluation
%
%	Usage:
%		[waveData, songDb]=qbshPerfEval(songDb, waveData, qbshOpt, outputFile)

%	Roger Jang, 20130425

if nargin<4, showPlot=0; end

% ====== Preprocessing (This part can be moved out of this function if necessary)
% === Create songDb(i).pv
if ~isfield(songDb, 'pv')
	fprintf('Generate songDb(i).pv from the songDb of %d songs ===> ', length(songDb)); tic;
	for i=1:length(songDb)
	%	fprintf('%d/%d: songName=%s\n', i,  length(songDb), songDb(i).songName);
		note = double(songDb(i).track);
		if isfield(songDb, 'anchorNoteIndex')	% anchorNoteIndex is generated by goSongDbGen.m for Dean's songs
			[songDb(i).pv, songDb(i).noteStartPvIndex, songDb(i).anchorPvIndex] = note2pv(note, qbshOpt.ptOpt.frameRate, inf, songDb(i).anchorNoteIndex, 0);
		else
			[songDb(i).pv, songDb(i).noteStartPvIndex] = note2pv(note, qbshOpt.ptOpt.frameRate, inf, [], 0);
		end
	end
	fprintf('%.2f seconds\n', toc);
end
% === Create songDb(i).anchorPvIndex
if ~isfield(songDb, 'anchorPvIndex')
	fprintf('Generate songDb(i).anchorPvIndex from the songDb of %d songs ===> ', length(songDb)); tic;
	switch lower(qbshOpt.anchorPos)
		case lower({'songStart'})
			for i=1:length(songDb), songDb(i).anchorPvIndex=1; end
		case lower({'sentenceStart'})
			% Do nothing since it's done in line 12 of this file already for Dean's songs
		case lower({'noteStart'})
			for i=1:length(songDb), songDb(i).anchorPvIndex=songDb(i).noteStartPvIndex; end
		otherwise
			fprintf('Supported anchorPos = ''songStart'', ''sentenceStart'', and ''noteStart''\n'); 
			error(sprintf('Unknown anchorPos=%s', qbshOpt.anchorPos));
	end
	fprintf('%.2f seconds\n', toc);
end
% === Rest handling
%fprintf('Handle rests ===> '); tic;
%for i=1:length(songDb)
%	songDb(i).pv=pvRestHandle(songDb(i).pv, qbshOpt.useRest);
%end
%fprintf('%.2f seconds\n', toc);

% ====== Compute recog. rate
[recogRate, waveData]=qbshPerfEvalCore(waveData, songDb, qbshOpt, showPlot);		% Compute recog. rate of each file
if showPlot
	fprintf('Top-1 recognition rate = %.2f%%\n', 100*recogRate);
	fprintf('Total search time: %g seconds\n', sum([waveData.time]));
	fprintf('Average search time for a wave file: %g seconds\n', mean([waveData.time]));
end

% ====== Write output file
if isfield(qbshOpt, 'outputFile')
	fid=fopen(qbshOpt.outputFile, 'w');
	for i=1:length(waveData)
		fprintf(fid, '%s: ', waveData(i).path);
		distVec=waveData(i).dist;
		if waveData(i).success
			[sorted, sortIndex]=sort(distVec);
			tempDb=songDb(sortIndex);
			for j=1:10
				fprintf(fid, ' %s', tempDb(j).id);
			end
			fprintf(fid, '\n');
		end
	end
	fclose(fid);
end

% ====== Plot figures
if showPlot
	rrVec=rankPlot([waveData.rank]);
	fprintf('Top-1 RR=%f%%\n', rrVec(1));
	fprintf('Top-10 RR=%f%%\n', rrVec(10));
	[sortedRank, rankCount]=elementCount([waveData.rank]);
	topN=10;
	index=find(sortedRank<=topN);
	mrr=sum(rankCount(index).*(sortedRank(index).^(-1)))/length(waveData);
	fprintf('Top-%d MRR=%f\n', topN, mrr);
%	figure; histPlot([waveData.rank]);
%	figure; piePlot([waveData.rank], message);
end

% ====== A core version of QBSH evaluation
function [recogRate, waveData]=qbshPerfEvalCore(waveData, songDb, qbshOpt, showPlot)
% qbshPerfEvalCore: Core part of QBSH performance evaluation
%	Roger Jang, 20090922, 20130425
if nargin<4, showPlot=0; end
songIds={songDb.id};	% For mirex, this is the song's ID
waveNum=length(waveData);
fprintf('Performing QBSH evaluation on %d wave files against %d midi files:\n', length(waveData), length(songDb));
for i=1:waveNum
	waveData(i).success=1;
%	try
		myTic=tic;
		pitch=waveData(i).cPitch;
		if qbshOpt.usePv, pitch=waveData(i).tPitch; end
		[waveData(i).dist, waveData(i).minIndex] = feval(qbshOpt.matchFun, songDb, pitch, qbshOpt);	% 將一首wave比對所有的歌
		waveData(i).time = toc(myTic);
		songIndex=find(strcmp(songIds, waveData(i).songId));	% 找出所有和標準答案同名的歌曲
		if ~isempty(songIndex)		% 找到了一首或多首
			minDistOfTheSong = min(waveData(i).dist(songIndex));	% 以最短距離為主
			waveData(i).rank = length(find(minDistOfTheSong>=waveData(i).dist));	
		else	% 找不到...
		%	fprintf('Cannot find %s in the songDb!\n', waveData(i).songId);
			waveData(i).rank = inf;
		end
		waveData(i).songIndex=songIndex;		% 紀錄標準答案的 index
		if showPlot
			fprintf('%d/%d: rank=%d, wave="%s", time=%2.3fs\n', i, waveNum, waveData(i).rank, waveData(i).path, waveData(i).time);
		end
%	catch exception
%		waveData(i).success=0;
%		waveData(i).errorMsg=exception.message;
%	end
end
recogRate=sum([waveData.rank]==1)/length(waveData);