% target dataset
% dataset = 'ucsd';
% dataset = 'mall';
dataset = 'cell';
dataset_Mode = 3;
% just for ucsd as it contains many forms of training and testing.
modeName = {'max','down','up','min','dense'}; 
% decide whether use the mask to filter out some outliers
useMask = true;

% patch setting
region.size = 4;
region.teStep = 2;
region.trStep = 2;

% the number of examplar
region.types = 128;

% the number of training samples.
nTrain = 16;

if strcmp(dataset,'cell')
    
    assert(nTrain < 101);

    % the range of training samples
    trRange = 1:100;

    % the number of testing samples.
    nTest = 100;
    assert(nTest < 101);

    % the range of testing samples
    teRange = 101:200;
else
    if strcmp(dataset,'mall')
        trRange = 1:800;
        
        % the number of testing samples.
        nTest = 1200;
        
        % the range of testing samples
        teRange = 801:2000;
    else % dataset is ucsd
        switch dataset_Mode
            case 1
                % the range of training samples
                trRange = 600 : 5 : 1400;
            case 2
                trRange = 1205 : 5 : 1600;
            case 3
                trRange = 805 : 5 : 1100;
            case 4
                trRange = 640 : 80 : 1360;
                if nTrain > length(trRange)
                    nTrain = length(trRange);
                end
            case 5
                trRange = 601 : 1400;
        end
        
        teRange = 1 : 2000;
        t = ones(2000,1);
        t(trRange) = 0;
        teRange = teRange(logical(t));
        
        nTest = length(teRange);
    end
end

% the cross-validation number
folders = 5;

% the number of all images, including testing and training ones.
totalNum = 200;
if ~strcmp(dataset,'cell')
    totalNum = 2000;
end
% assert(totalNum == (length(trRange) + length(teRange)));

% regularized parameter for controlling the synthetic result.
lambda = 0.001;

% the dimensions of feature vectors
vd = region.size^2;


% quick access
quickFileName = ['example_' dataset '.mat'];

% saving folder for synthetic images generated by algorithm
saveName = ['FEVOC_' dataset '+' datestr(now,'yyyy-mm-dd_HH-MM-SS') ...
    '_P+' num2str(region.size) '_teS+' num2str(region.teStep) '_trS+' ...
    num2str(region.trStep) '_train+' num2str(nTrain) '_atoms' ...
    num2str(region.types) '_cross+' num2str(folders)];
if strcmp(dataset, 'ucsd')
    saveName = ['FEVOC_' dataset '_M+' modeName{dataset_Mode} '+' ...
        datestr(now,'yyyy-mm-dd_HH-MM-SS') ...
    '_P+' num2str(region.size) '_teS+' num2str(region.teStep) '_trS+' ...
    num2str(region.trStep) '_train+' num2str(nTrain) '_atoms' ...
    num2str(region.types) '_cross+' num2str(folders)];
end