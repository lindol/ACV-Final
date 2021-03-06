function [recogRate, confusionMatrix, speakerData]=speakerIdentify(speakerData, speakerGmm, useIntGmm)
% speakerIdentify: speaker identification using GMM parameters
%	Usage: [recogRate, confusionMatrix, speakerData]=speakerIdentify(speakerData, speakerGmm, useIntGmm)
%		speakerData: structure array generated by speakerDataRead.m
%		speakerGmm: speakerGmm(i).gmmPrm is the GMM parameters for speaker i.
%		useIntGmm: use fixed-point GMM

%	Roger Jang, 20070517, 20080726

if nargin<3, useIntGmm=0; end

% ====== Speaker identification using GMM parameters
speakerNum=length(speakerData);
for i=1:speakerNum
%	fprintf('%d/%d: Recognizing wave files by %s\n', i, speakerNum, speakerData(i).name);
	for j=1:length(speakerData(i).sentence)
%		fprintf('\tSentece %d...\n', j);
		frameNum=size(speakerData(i).sentence(j).fea, 2);
		logProb=zeros(speakerNum, frameNum); 
		for k=1:speakerNum
%			fprintf('\t\tSpeaker %d...\n', k);
		%	logProb(k, :)=gmmEval(speakerData(i).sentence(j).fea, speakerGmm(k).gmmPrm);
			if ~useIntGmm
			%	logProb(k, :)=gmmEvalMex(speakerData(i).sentence(j).fea, gmm(k).mean, gmm(k).covariance, gmm(k).weight);
				logProb(k, :)=gmmEval(speakerData(i).sentence(j).fea, speakerGmm.class(k).gmmPrm);
			else
			%	logProb(k, :)=gmmEvalIntMex(speakerData(i).sentence(j).fea, gmm(k).mean, gmm(k).covariance, gmm(k).weight);
				logProb(k, :)=gmmEvalIntMex(speakerData(i).sentence(j).fea, speakerGmm.class(k).gmmPrm);
			end
		end
		cumLogProb=sum(logProb, 2);
		[maxProb, index]=max(cumLogProb);
		speakerData(i).sentence(j).predictedSpeaker=index;
		speakerData(i).sentence(j).logProb=logProb;
	end
end

% ====== Compute confusion matrix and recognition rate
confusionMatrix=zeros(speakerNum);
for i=1:speakerNum,
	predictedSpeaker=[speakerData(i).sentence.predictedSpeaker];
	[index, count]=elementCount(predictedSpeaker);
	confusionMatrix(i, index)=count;
end
recogRate=sum(diag(confusionMatrix))/sum(sum(confusionMatrix));