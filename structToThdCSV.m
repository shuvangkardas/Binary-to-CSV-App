function csv = structToThdCSV(dataStruct)
[n,m] = size(dataStruct);
% data = dataStruct;

idx = getDataIndex(dataStruct);
mIdx = getMinuteIndex(dataStruct,idx)
[p,q] = size(mIdx);
for i = 1:q
    A = [dataStruct(mIdx(i)).data(1,:) dataStruct(mIdx(i)+1).data(1,:) dataStruct(mIdx(i)+2).data(1,:) dataStruct(mIdx(i)+3).data(1,:)];
    B = [dataStruct(mIdx(i)).data(2,:) dataStruct(mIdx(i)+1).data(2,:) dataStruct(mIdx(i)+2).data(2,:) dataStruct(mIdx(i)+3).data(2,:)];
    C = [dataStruct(mIdx(i)).data(3,:) dataStruct(mIdx(i)+1).data(3,:) dataStruct(mIdx(i)+2).data(3,:) dataStruct(mIdx(i)+3).data(3,:)];
    N = [dataStruct(mIdx(i)).data(4,:) dataStruct(mIdx(i)+1).data(4,:) dataStruct(mIdx(i)+2).data(4,:) dataStruct(mIdx(i)+3).data(4,:)];
    meanA = mean(A);
    meanB = mean(B);
    meanC = mean(C);
    meanN = mean(N);
    A = A - meanA;
    B = B - meanB;
    C = C - meanC;
    N = N - meanN;
    txt = sprintf("--------------count : %d---------------",i)
    fftA = fftBin(A,500)
    csvA = fftTocsv(fftA)
    fftB = fftBin(B,500)
    fftC = fftBin(C,500)
    fftN = fftBin(N,500)
end   
% plot(A);
% hold on
% plot(B);
% hold on;
% plot(C);
% hold on
% plot(N);

% phase;
% for pInd = 1:4
%     phase(pInd,:) = [dataStruct(mIdx(1)).data(pInd,:) dataStruct(mIdx(1)+1).data(pInd,:) dataStruct(mIdx(1)+2).data(pInd,:) dataStruct(mIdx(1)+3).data(pInd,:)];
% end
% plot(phase(1,:));
% hold on 
% plot(phase(2,:));

% avg = mean(A)
% A = A - avg
% % plot(sample)
% myfft = fftBin(A,500)

end

%% FFT to CSV String conversion
function fftCsv = fftTocsv(fftx)
n = length(fftx.freq)
fftCsv = 1;
end

%% This functions returns all the data structure index that has continuity in more than 100 samples
function index = getDataIndex(data)
[n,m] = size(data);
index = [];
for i = 1:n-4
    if(data(i).endMicros+1 == data(i+1).startMicros)
        if(data(i+1).endMicros + 1 == data(i+2).startMicros)
            if(data(i+2).endMicros+1 == data(i+3).startMicros)
                if(data(i+3).endMicros +1 == data(i+4).startMicros)
%                     txt = sprintf("Index : %d",i)
                    index(end+1)=i;
                end
            end
        end
    end
end

end

%% This functions returns the minute-wise continuous data index

function minIndex = getMinuteIndex(data,index)
[n,m] = size(data);
minIndex = [];

iCount = 1;
dt = datetime(data(1).unixTime,'ConvertFrom', 'posixtime' );
currentMin = minute(dt);
previousMin = currentMin;

for i = 1:n-4
    if(i == index(iCount))
        dt = datetime(data(i).unixTime,'ConvertFrom', 'posixtime' );
        currentMin = minute(dt);
        if(currentMin>previousMin)
            previousMin = currentMin;
            minIndex(end+1) = index(iCount);
%             dt
        end 
        iCount = iCount+1;
    end
    
end

end
