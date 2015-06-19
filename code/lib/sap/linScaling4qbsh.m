function [minDist, shiftedPitch, allDist]=linScaling(queryPitch, dbPitch, opt, showPlot)
% linScaling: Linear scaling for melody recognition
%
%	Usage:
%		[minDist, shiftedPitch, allDist1]=linScaling(queryPitch, dbPitch, lowerRatio, upperRatio, resolution, distanceType)
%		[minDist, shiftedPitch, allDist1]=linScaling(queryPitch, dbPitch, lowerRatio, upperRatio, resolution, distanceType, showPlot)
%
%	Example:
%		queryPitch=[48.044247 48.917323 49.836778 50.154445 50.478049 50.807818 51.143991 51.486821 51.486821 51.486821 51.143991 50.154445 50.154445 50.154445 49.218415 51.143991 51.143991 50.807818 49.524836 49.524836 49.524836 49.524836 51.143991 51.143991 51.143991 51.486821 51.836577 50.807818 51.143991 52.558029 51.486821 51.486821 51.486821 51.143991 51.143991 51.143991 51.143991 51.143991 51.143991 51.143991 51.143991 51.143991 49.218415 50.807818 50.807818 50.154445 50.478049 48.044247 49.524836 52.193545 51.486821 51.486821 51.143991 50.807818 51.486821 51.486821 51.486821 51.486821 51.486821 55.788268 55.349958 54.922471 54.922471 55.349958 55.349958 55.349958 55.349958 55.349958 55.349958 55.349958 55.349958 53.699915 58.163541 59.213095 59.762739 59.762739 59.762739 59.762739 58.163541 57.661699 58.163541 58.680365 58.680365 58.680365 58.163541 55.788268 54.505286 55.349958 55.788268 55.788268 55.788268 54.922471 54.505286 56.237965 55.349958 55.349958 55.349958 55.349958 54.505286 54.505286 55.349958 48.917323 50.478049 50.807818 51.143991 51.143991 51.143991 50.807818 50.807818 50.478049 50.807818 51.486821 51.486821 51.486821 51.486821 51.486821 51.486821 52.558029 52.558029 52.558029 52.558029 52.193545 51.836577 52.193545 53.310858 53.310858 53.310858 52.930351 52.930351 53.310858 52.930351 52.558029 52.193545 52.930351 53.310858 52.930351 51.836577 52.558029 53.699915 52.930351 52.930351 52.558029 52.930351 52.930351 52.558029 52.558029 52.558029 53.310858 53.310858 53.310858 53.310858 52.930351 52.930351 52.930351 52.558029 52.930351 52.930351 52.930351 52.930351 52.930351 52.930351 52.930351 53.310858 53.310858 53.310858 52.193545 52.193545 52.193545 54.097918 52.930351 52.930351 52.930351 52.930351 52.930351 51.143991 51.143991 51.143991 48.917323 49.524836 49.524836 49.836778 49.524836 48.917323 49.524836 49.218415 48.330408 48.330408 48.330408 48.330408 48.330408 49.524836 49.836778 53.310858 53.310858 53.310858 52.930351 52.930351 52.930351 53.310858 52.930351 52.930351 52.558029 52.558029 51.143991 52.930351 49.218415 49.836778 50.154445 49.836778 49.524836 48.621378 48.621378 48.621378 49.836778 49.836778 49.836778 49.836778 46.680365 46.680365 46.680365 46.163541 45.661699 45.661699 45.910801 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 46.163541 50.807818 51.486821 51.486821 51.143991];
%		dbPitch=[60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 64 64 64 64 64 64 64 64 64 64 64 64 64 67 67 67 67 67 67 67 67 67 67 67 67 64 64 64 64 64 64 64 64 64 64 64 64 64 60 60 60 60 60 60 60 60 60 60 60 60 60 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 59 59 59 59 59 59 59 59 59 59 59 59 59 62 62 62 62 62 62 62 62 62 62 62 62 59 59 59 59 59 59 59 59 59 59 59 59 59 55 55 55 55 55 55 55 55 55 55 55 55 55 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 64 64 64 64 64 64 64 64 64 64 64 64 64 67 67 67 67 67 67 67 67 67 67 67 67 64 64 64 64 64 64 64 64 64 64 64 64 64 60 60 60 60 60 60 60 60 60 60 60 60 60 67 67 67 67 67 67 67 67 67 67 67 67 65 65 65 65 65 65 65 65 65 65 65 65 65 64 64 64 64 64 64 64 64 64 64 64 64 62 62 62 62 62 62 62 62 62 62 62 62 62 60 60 60 60 60 60 60 60 60 60 60 60 60];
%		resolution=21;
%		lowerRatio=0.5;
%		upperRatio=1.5;
%		distanceType=1;		% L1-norm
%		[minDist, shiftedPitch, allDist]=linScaling(queryPitch, dbPitch, lowerRatio, upperRatio, resolution, distanceType, 1);

%	Roger Jang, 20070531

if nargin<1, selfdemo; return; end
if nargin<4, showPlot=0; end

% ====== Cut out leading/trailing rests
while queryPitch(1)==0; queryPitch(1)=[]; end
while queryPitch(end)==0; queryPitch(end)=[]; end
queryPitch2=pvRestHandle(queryPitch, opt.useRest);
queryPitch(queryPitch==0)=nan;
[minDist, shiftedPitch, allDist]=linScalingMex(queryPitch2, dbPitch, opt.lowerRatio, opt.upperRatio, opt.resolution, opt.lsDistanceType);

if showPlot
	ratio=linspace(opt.lowerRatio, opt.upperRatio, opt.resolution);
	[junk, index]=min(allDist); bestSf=ratio(index);
	subplot(2,1,1);
	plot(1:length(dbPitch), dbPitch, '.-', 1:length(queryPitch2), queryPitch2, '.-', 1:length(queryPitch), queryPitch, '.-', 1:length(shiftedPitch), shiftedPitch, '.-');
	legend('Database pitch', 'Rest-filled query pitch', 'Original query pitch', 'Best scaled/transposed pitch', 'location', 'northOutside', 'orientation', 'horizontal');
	title(sprintf('Database, query, and scaled/transposed query pitch (sf=%f, distance=%f)', bestSf, minDist)); ylabel('Semitones');
	subplot(2,1,2);
	allDist(allDist>1e9)=inf;
	plot(ratio, allDist, '.-'); line(bestSf, minDist, 'marker', 'o', 'color', 'r');
	xlabel('Scaling ratios'); ylabel('Distances');
	title(sprintf('Normalized distance via L_%d norm', opt.lsDistanceType));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
