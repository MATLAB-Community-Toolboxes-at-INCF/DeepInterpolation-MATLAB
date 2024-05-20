% Testsuite for the DeepInterpolation Datastore
% https://www.mathworks.com/help/matlab/import_export/testing-guidelines-for-custom-datastores.html
% 
% The test-suite expects the tiff-files "ophys_tiny_761605196.tif" and
% "ophys_tiny_761605196_wrongsize.tif" in the subfolder data of the current folder. 
% If that is different, alter TESTSTACKFULLFILE!
%
% Note that a different test-dataset will fail many tests as they check for
% specific frames or framecounts.
%
% Dr. Thomas Künzel, The MathWorks, 2023
% tkuenzel@mathworks.com

base_folder = setup;

TESTSTACKFULLFILE = fullfile(base_folder,"sample_data","ophys_tiny_761605196.tif");
WRONGSIZETESTSTACKFULLFILE = fullfile(base_folder,"sample_data","ophys_tiny_761605196_wrongsize.tif");

%% Test 01: Check if  matlab.io.Datastore is superclass.
% A deepinterpolation datastore inherits from abstract Datastore
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
assert(isa(dids,'matlab.io.Datastore'));

%% Test 02: Call the read
% A deepinterpolation datastore returns training data (512x512x60) and the reference
% frame (512x512) in a 1x2 cell array
% The first center- or reference frame to be read is actually the 32nd frame of the
% dataset, as deepinterpolation takes 60 flanking frames [n-31:n-2 n+2:n+31] around a
% center frame, leaving one frame each left and right as a gap, for training.
% The first frame that allows that is the 32nd!
% The combination of training data and center frame is called a "set" here, and the
% number of sets, following the logic above, is N-Frames - 62.
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
t = read(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));

%% Test 03: Call the read again
% Standard sequential datastore behavior: advance to "second" center-frame
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
read(dids);
[t,info] = read(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert(info == "set=2/centerframe=33")

%% Test 04: Successfully read until no more data
% The testdatastack should return 38 sets of training frames and reference frame
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
count = 0;
while(hasdata(dids))
    read(dids);
    count = count + 1;
end
assert(count == 38);

%% Test 05: Call read when out of data
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
try
    read(dids);
catch ME
    assert(ME.message == "No more data to read");
end

%% Test 11: Call the readall method
% Standard sequential datastore behavior: return all data in a nx2 Cell array, for
% the test dataset n==38
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
allt = readall(dids);
assert(all(size(allt)==[38 2]));

%% Test 12: Call the readall method when out of data
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
while(hasdata(dids))
  read(dids);
end
allt = readall(dids);
assert(all(size(allt)==[38 2]));

%% Test 21: Call the reset method before any read
% Reset to "first" frame (in fact, the 32nd frame in the stack...)
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
reset(dids);
[t,info] = read(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert(info == "set=1/centerframe=32");

%% Test 22: Call the reset method after some reads
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
read(dids);
read(dids);
read(dids);
reset(dids);
[t,info] = read(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert(info == "set=1/centerframe=32");

%% Test 23: Call the reset method after readall
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
read(dids);
tall = readall(dids);
reset(dids);
[t,info] = read(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert(info == "set=1/centerframe=32");

%% Test 24: Call the reset method when out of data
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
while(hasdata(dids))
  read(dids);
end
reset(dids);
[t,info] = read(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert(info == "set=1/centerframe=32");

%% Test 31: Call the progress method before any reads
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
p = progress(dids);
assert(p==0);

%% Test 32: Call the progress method after readall but before read.
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
readall(dids);
p = progress(dids);
assert(p==0);

%% Test 33: Call the progress method after read
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
read(dids);
p = progress(dids);
assert((p-0.0270)<1e-4);

%% Test 34: Call the progress method when out of data
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
while(hasdata(dids))
  read(dids);
end
p = progress(dids);
assert((p-1.0)<1e-4);

%% Test 35: Progress produces correct output over all sets
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
idx = 1;
while(hasdata(dids))
  p(idx) = progress(dids);
  read(dids);
  idx = idx + 1;
end
p(idx) = progress(dids);
assert(all(p <= 1), "progress must be between 0 and 1!");
assert(all(diff(p) > 0), "progress must be monotonically increasing");

%% Test 41: Preview methods returns first set
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
t = preview(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert((t{1}(323,23,44)-138)<1e-4);

%% Test 42: Preview methods returns first set after reads
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
read(dids);
read(dids);
t = preview(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert((t{1}(323,23,44)-138)<1e-4);

%% Test 43: Preview methods returns first set after readall
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
readall(dids);
t = preview(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert((t{1}(323,23,44)-138)<1e-4);

%% Test 44: Preview methods returns first set after reads and reset
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
read(dids);
read(dids);
reset(dids);
t = preview(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert((t{1}(323,23,44)-138)<1e-4);

%% Test 45: Preview methods returns first set when out of data
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
while hasdata(dids)
    read(dids);
end
t = preview(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert((t{1}(323,23,44)-138)<1e-4);

%% Test 46: Read after preview is from correct location
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
read(dids);
read(dids);
preview(dids);
[t,info] = read(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert(info == "set=3/centerframe=34");

%% Test 47: Readall after preview works correctly
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
preview(dids);
allt = readall(dids);
assert(all(size(allt)==[38 2]));

%% Test 48: Hasdata works correctly after preview
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
read(dids);
preview(dids);
assert(hasdata(dids));

%% Test 50: Call Partition, check if the partition is a deepinterpolation datastore
% A partition of the deepinterpolation datastore is merely pointing to a different
% startframe and has a smaller number of available sets. All the other behaviors are
% derived from that
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = partition(dids,10,7);
assert(isa(subds,'matlab.io.Datastore'));

%% Test 51: Call Partition, check if the partition has correct properties
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = partition(dids,10,7);
assert(isequal(properties(dids),properties(subds)));

%% Test 52: Call Partition, check if the partition has correct methods
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = partition(dids,10,7);
assert(isequal(methods(dids),methods(subds)));

%% Test 53: Call Partition, successfully read from a partition
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = partition(dids,10,7);
[t,info] = read(subds);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert(info == "set=1/centerframe=56");

%% Test 54: Call last Partition, read all data
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = partition(dids,13,13);
while hasdata(subds)
    read(subds);
end

%% Test 55: Call Partition, check that total number of sets/frames is correct
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
partsets = 0;
for iii = 1:10
    subds = partition(dids,10,iii);
    partsets = partsets + subds.dsSetCount;
end
assert(partsets-38 < 1e-4);

%% Test 56: Call partition with partition=1 and index=1 and validate
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = partition(dids,1,1);
assert(isequal(properties(dids),properties(subds)));
assert(isequal(methods(dids),methods(subds)));
assert(isequaln(read(subds),read(dids)));
assert(isequaln(preview(subds),preview(dids)));

%% Test 57: Partition a partition again and validate
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = partition(dids,2,2);
subsubds = partition(subds,2,2);
[t,info] = read(subsubds);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert(info == "set=1/centerframe=61");

%% Test 58: Progress is working correctly in partitions
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = partition(dids,2,2);
idx = 1;
clear p
while(hasdata(subds))
  p(idx) = progress(subds);
  read(subds);
  idx = idx + 1;
end
p(idx) = progress(subds);
assert(p(1)<1e-4, "first progress item should be 0");
assert((p(end)-1)<1e-5, "last progress item should be 1");
assert(all(p <= 1), "progress must be between 0 and 1!");
assert(all(diff(p) > 0), "progress must be monotonically increasing");

%% Test 60: Create a Subset of the datastore and validate
% deepinterpolation datastore is subsettable, again this just assigns the correct
% startframe and number of available sets, but points to the same file
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = subset(dids,5:20);
[t,info]=read(subds);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));
assert(info == "set=1/centerframe=36");

%% Test 61: Progress is working correctly in subsets
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
subds = subset(dids,5:10);
idx = 1;
clear p
while(hasdata(subds))
  p(idx) = progress(subds);
  read(subds);
  idx = idx + 1;
end
p(idx) = progress(subds);
assert(p(1)<1e-4, "first progress item should be 0");
assert((p(end)-1)<1e-5, "last progress item should be 1");
assert(all(p <= 1), "progress must be between 0 and 1!");
assert(all(diff(p) > 0), "progress must be monotonically increasing");

%% Test 71: Fail on wrong image size
try
    dids = deepinterp.Datastore(WRONGSIZETESTSTACKFULLFILE); %#ok<NASGU>
catch EM
    assert(strcmp(EM.message,'Actual frame size is not equal to specified outputFrameSize'),"Fail on wrong tiff size");
end

%% Test 72: Read data with automatic resize
options.doAutoResize = true;
dids = deepinterp.Datastore(WRONGSIZETESTSTACKFULLFILE, options);
t = read(dids);
assert(iscell(t));
assert(numel(t) == 2);
assert(all((size(t{1})==[512 512 60])));
assert(all((size(t{2})==[512 512])));

%% Test 81: Shuffling returns randomized datastore without error
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
shds = shuffle(dids);
assert(isa(shds,'matlab.io.Datastore'));

%% Test 82: can read sequentially from shuffled datastore
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
shds = shuffle(dids);
count = 0;
while(hasdata(shds))
    read(shds);
    count = count + 1;
end
assert(count == 38);

%% Test 83: can read all from shuffled datastore
dids = deepinterp.Datastore(TESTSTACKFULLFILE);
shds = shuffle(dids);
allt = readall(shds);
assert(all(size(allt)==[38 2]));
