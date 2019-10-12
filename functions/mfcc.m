
% Feature extraction part by using MFCC
function ceps = mfcc(input, samplingRate)
    
[r c] = size(input);
if (r > c) 
	input=input';
end

%	parameter-parameter filter bank 
lowestFrequency = 133.3333;     %jarak antara frekuensi pusat
linearFilters = 13;             %jumlah filter berjarak linear
linearSpacing = 66.66666666;    %jarak linear
logFilters = 27;                %jumlah filter berjarak logaritmis
logSpacing = 1.0711703;         %faktor pemisah dalam frekuensi
fftSize = 512;                  %ukuran FFT
cepstralCoefficients = 13;      %jumlah koefisien cepstral
% windowSize = 400;               %Ukuran window standard 400,
windowSize = 256;               %ukuran window 256
                    			%menjadi fungsi dari sample rate 
                                %(dan Frekuensi terendah)
if (nargin < 2) samplingRate = 16000; end;
if (nargin < 3) frameRate = 100; end;

% total filter
totalFilters = linearFilters + logFilters;

% Mencari tepi band. 
% Pertama mencari semua frekueansi interesting. 
% Tepi band terendah, tengah, teratas  
% semua berturut-turut adalah frekuensi interesting

freqs = lowestFrequency + (0:linearFilters-1)*linearSpacing;
freqs(linearFilters+1:totalFilters+2) = ...
		      freqs(linearFilters) * logSpacing.^(1:logFilters+2);

lower = freqs(1:totalFilters);
center = freqs(2:totalFilters+1);
upper = freqs(3:totalFilters+2);

% Mengkombinasikan beberapa bin FFT sehingga masing2 filter 
% mempunyai bobot satuan, dg mengasumsikan sebuah fungsi 
% pembobotan segitiga. Pertama mencari tinggi segitiga, 
% kemudian mencari kontribusi masing2 frekuensi
mfccFilterWeights = zeros(totalFilters,fftSize);
triangleHeight = 2./(upper-lower);
fftFreqs = (0:fftSize-1)/fftSize*samplingRate;

for chan=1:totalFilters
	mfccFilterWeights(chan,:) = ...
  (fftFreqs > lower(chan) & fftFreqs <= center(chan)).* ...
   triangleHeight(chan).*(fftFreqs-lower(chan))/(center(chan)-lower(chan)) + ...
  (fftFreqs > center(chan) & fftFreqs < upper(chan)).* ...
   triangleHeight(chan).*(upper(chan)-fftFreqs)/(upper(chan)-center(chan));
end
% size(mfccFilterWeights)
% Windowing dg Hamming window
hamWindow = 0.54 - 0.46*cos(2*pi*(0:windowSize-1)/windowSize);

if 0 % me-window-nya seperti spektrum kompleks
	windowStep = samplingRate/frameRate;
	a = .54;
	b = -.46;
	wr = sqrt(windowStep/windowSize);
	phi = pi/windowSize;
	hamWindow = 2*wr/sqrt(4*a*a+2*b*b)* ...
		(a + b*cos(2*pi*(0:windowSize-1)/windowSize + phi));
end

% Mencari trasnformasi kosinus diskrit (DCT, Discrete Cosine Transform)
% untuk mendapatkan sebuah matriks dct(i,j) yang ukurannya sama dengan 
% totalFilter x cepstralCoefficients
% komponen i,j diberikan oleh
%               cos( i * (j+0.5)/totalFilters pi )
% dengan asumsi i dan j dimulai dari 0
mfccDCTMatrix = 1/sqrt(totalFilters/2)*cos((0:(cepstralCoefficients-1))' * ...
				(2*(0:(totalFilters-1))+1) * pi/2/totalFilters);
mfccDCTMatrix(1,:) = mfccDCTMatrix(1,:) * sqrt(2)/2;

windowStep = samplingRate/frameRate;
cols = fix((length(input)-windowSize)/windowStep);
% Mengalokasikan semua space yg dibutuhkan untuk larik output
ceps = zeros(cepstralCoefficients, cols);
% size(ceps)
% Pemrosesan. Untuk masing2 potongan data :
%   * me-window data dengan hamming window,
%   * mengubahnya menjadi orde FFT,
%   * mencari magnitud FFT,
%   * mengkonversi data fft menjadi keluaran filter bank,
%   * menghitung log basis 10,
%   * mencari transformasi kosinus untuk mengurangi dimensi.
for start = 0 : cols - 1
    first = start * windowStep + 1;
    last = first + windowSize - 1;
    fftData = zeros(1, fftSize);
    fftData(1 : windowSize) = input(first:last) .* hamWindow;
    fftMag = abs( fft( fftData));
    earMag = log10(mfccFilterWeights * fftMag');

    ceps(:, start + 1) = mfccDCTMatrix * earMag;
    
end
% size(ceps)
end

