function tests = test_ft_connectivity_mim

% MEM 1gb
% WALLTIME 00:10:00
% DEPENDENCY ft_connectivity_mim
% DATA no

if nargout
  % assume that this is called by RUNTESTS
  tests = functiontests(localfunctions);
else
  % assume that this is called from the command line
  func = localfunctions;
  for i=1:numel(func)
    fprintf('evaluating %s\n', func2str(func{i}));
    feval(func{i});
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_chan_chan_freq(testCase)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nchan   = 6;
nfreq   = 5;
dimord  = 'chan_chan_freq';
input   = zeros(nchan, nchan, nfreq);

for freq=1:nfreq
  fdat = 10 * randn(nchan, 1) + 1i * 10 * randn(nchan, 1);
  input(:,:,freq) = fdat * ctranspose(fdat); % compute the cross-spectral density
end

result = {};
result{end+1} = ft_connectivity_cancorr(input, 'dimord', dimord, 'indices', [1 1 2 2 3 3]); % e.g. three pair of planar channels
result{end+1} = ft_connectivity_cancorr(input, 'dimord', dimord, 'indices', [1 1 1 2 2 2]); % e.g. two dipole moments (xyz)

% all iterations were done with (slightly) different options, hence the results should not be equal
for i=1:numel(result)
  for j=(i+1):numel(result)
    assert(~isequaln(result{i}, result{j}), 'the results %d and %d should not be equal', i, j);
  end
end
