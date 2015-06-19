function wave=pvPlay(pv, pitchRate, method, showPlot)
%pvPlay: Play a pitch vector (pv)
%
%	Usage:
%		pvPlay(pv, pitchRate)
%		pvPlay(pv, pitchRate, method)
%		pvPlay(pv, pitchRate, method, showPlot)
%		wave=pvPlay(...)
%
%	Description:
%		wave=pvPlay(pv, pitchRate, method, showPlot) plays the give pv (pitch vector).
%			pv: pitch vector in semitones, where zero is considered as silence
%			pitchRate: pitch points per second
%			method: method for generating the wave signals
%				method=1 ===> Smooth pitch playback using note2waveMex.dll
%				method=2 ===> Discrete pitch playback using method=2 in pv2wave.m
%				method=3 ===> Discrete pitch playback using the builtin PC speaker (Does not guarantee to work)
%			showPlot: 1 for plotting
%			wave: the output wave signals
%
%	Example:
%		% === Example 1: 
%		pv=[60.3304 59.2131 58.6804 59.2131 59.7627 60.3304 60.3304 60.3304 59.7627 59.7627 59.7627 59.7627 0 0 0 60.3304 59.2131 58.6804 58.6804 59.2131 59.2131 59.7627 59.7627 59.7627 59.2131 59.7627 59.7627 61.5248 63.4868 65.6999 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 67.35 66.5053 0 0 0 0 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 67.35 67.35 67.35 67.35 68.238 69.174 69.174 68.238 68.238 68.238 68.238 68.238 68.238 68.238 68.238 0 0 0 0 69.174 68.238 68.238 68.238 68.238 68.238 68.238 69.174 68.238 68.238 68.238 0 0 0 0 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 66.5053 67.35 67.35 65.699915 63.4868 62.8078 62.8078 63.4868 64.9304 64.1935 64.1935 64.1935 64.9304 64.9304 64.9304 64.1935 64.9304 64.9304 64.9304 0 0 0 0 64.9304 64.1935 64.1935 64.1935 64.1935 64.9304 64.9304 64.9304 64.9304 64.9304 64.1935 64.1935 63.486821 64.1935 63.4868 63.4868 63.4868 63.4868 63.4868 63.4868 63.4868 63.4868 64.1935 63.4868 0 0 63.4868 64.1935 63.4868 63.4868 63.4868 63.4868 63.4868 63.4868 63.4868 64.1935 63.4868 63.4868 0 0 0 0 60.9173 60.9173 60.9173 61.5248 61.5248 61.5248 61.5248 61.5248 61.5248 61.5248 62.8078 0 0 61.5248 60.9173 60.9173 60.9173 61.5248 61.5248 61.5248 61.5248 61.5248 61.5248 61.5248 62.1544 0 0 0 0 59.7627 59.2131 59.2131 59.7627 59.7627 59.7627 59.7627 59.2131 59.2131 59.2131 59.2131 59.2131 59.7627 60.3304 60.3304];
%		frameRate=8000/256;
%		showPlot=1;
%		fprintf('Using method 1 in pvPlay.m for playback...\n');
%		figure; pvPlay(pv, pitchRate, 1, showPlot)
%		fprintf('Using method 2 in pvPlay.m for playback...\n');
%		figure; pvPlay(pv, pitchRate, 2, showPlot)
%		% === Example 2: This is a bad example using method 2
%		pv=[56.699654;56.237965;56.699654;56.237965;56.699654;57.173995;57.661699;58.163541;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.163541;57.661699;56.237965;55.788268;55.788268;56.237965;56.237965;56.237965;56.237965;56.699654;56.699654;57.173995;57.661699;58.163541;58.680365;58.163541;58.163541;58.163541;58.163541;58.680365;58.680365;59.213095;59.762739;59.762739;60.330408;60.917323;60.917323;61.524836;61.524836;61.524836;61.524836;61.524836;61.524836;62.154445;61.524836;61.524836;61.524836;61.524836;61.524836;60.917323;60.330408;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.163541;58.163541;57.661699;57.661699;56.699654;56.699654;56.699654;56.699654;56.699654;56.237965;56.237965;56.699654;57.173995;56.699654;57.173995;56.699654;56.699654;56.699654;56.699654;57.173995;57.173995;57.661699;58.163541;58.163541;58.163541;58.163541;58.163541;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.680365;58.163541;58.163541;57.661699;57.173995;56.699654;56.237965;56.237965;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.699654;56.237965;55.349958;52.930351;49.836778;49.524836;50.807818;51.486821;51.836577;51.836577;51.486821;51.143991;51.486821;51.486821;51.486821;51.836577;52.193545;53.310858;53.699915;54.505286;54.922471;55.349958;54.922471;54.922471;54.505286;54.505286;54.505286;54.505286;54.505286;54.505286;54.505286;54.505286;54.505286;54.097918;54.097918;53.310858;52.193545;49.836778;50.154445;51.143991;51.486821;51.486821;51.486821;51.143991;51.143991;50.478049;50.154445;48.917323;48.621378;48.917323;49.524836;49.218415;48.917323;49.218415;49.524836;49.524836;49.218415;48.917323;49.218415;49.524836;49.524836;50.154445;50.478049;50.154445;50.478049;50.478049;50.807818;51.486821;51.836577;51.486821;51.143991;51.143991;51.143991;51.143991;51.143991;51.143991;51.143991;51.143991;51.486821;51.486821;51.486821;51.836577;51.836577;51.836577;51.486821;51.486821;51.486821;51.143991;51.143991;51.486821;51.143991;51.486821;51.486821;51.836577;51.836577;51.143991;51.143991;51.143991;51.143991;51.836577;52.193545;51.836577;51.486821;51.143991;50.478049;48.621378;50.154445];
%		pitchRate=8000/256;
%		fprintf('This is a bad example using method 2 in pvPlay.m for playback...\n');
%		figure; pvPlay(pv, pitchRate, 2, showPlot)

%	Roger Jang, 20050108, 20070601, 20121111

if nargin<1, selfdemo; return; end
if nargin<2, pitchRate=8000/256; end
if nargin<3, method=1; end
if nargin<4, showPlot=0; end

pv=pv(:)';
pv = double(pv);
pv(isnan(pv)) = 0;    % Convert NaN to 0
pvLen=length(pv);
duration=ones(1, pvLen)/pitchRate;
%[note(1:length(pvLen)).pitch] = deal(pv);
%[note(1:length(pvLen)).duration] = deal(duration);
note=[pv; duration]; note=note(:);
fs=16000;
switch (method)
	case 1		% Smooth pitch playback
		wave=note2wave(note, 1, fs, 2, showPlot);
		sound(wave, fs);
	case 2		% Discrete pitch playback (Bad for low-pitch vector.)
		wave=pv2wave(pv, pitchRate, fs, 2, showPlot);
		sound(wave, fs);
	case 3		% Playback by the builtin PC speaker (Some PCs do not have good PC speakers.)
		note(2:2:end)=1000*note(2:2:end);		% the time unit used in notePlayMex is 1/1000 second.
	%	note(1:2:end)=note(1:2:end)-12;			% shift 12 semitones to make it more pleasant to hear
		notePlayMex(double(note));			% playback using the builtin speaker. by Vincent Gao
		%notePlay2mex(double(note));			% playback using the sound card. by Wenny Cheng
	otherwise
		disp('Unknown method for pvPlay!')
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
