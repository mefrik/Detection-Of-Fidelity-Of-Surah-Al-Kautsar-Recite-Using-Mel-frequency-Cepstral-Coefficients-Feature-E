

% fungsi untuk end point detection
function suara_EPD = EPD(suara2, fs, ts, thEPD, out_folder, outn)

% hitung panjang data tercuplik/frame
pjg = ts * fs;  % lebar framing
% terapkan STFT (spectrogram)
[s, ~, ~, ~] = spectrogram(suara2,hamming(pjg),floor(0.5*pjg),pjg);
% gunakan nilai absolute nya
abs_s = abs(s);

% plot spectrogram
window = hamming(pjg);
winoverlap = floor(0.5*pjg);
judul = 'Spectrogram ';
if exist ('outn') == 1
    nama_title_png = 'Spectrogram %s.png';
    nama_title_pdf = 'Spectrogram %s.pdf';
    cetak(judul, suara2, out_folder, outn, nama_title_png, nama_title_pdf, ...
        window,winoverlap, pjg, fs)
elseif exist ('out_folder') == 0
    alldata = {window winoverlap pjg fs};
    cetak(judul, suara2, alldata)
end


% cari jumlah kolom dan baris dari data nilai magnitude
num_r = size(abs_s, 1);
num_c = size(abs_s, 2);

a = 1;
b = 1;
temp = zeros(size(s));
% cek tiap frame terkait energy dan zero crossingnya
for idx = 1 : num_c
    [nr, ~] = find(abs_s(:, idx) > thEPD);
    if numel(nr) > thEPD * num_r
        temp(:, idx) = 1;
    end
    for ida = 1 : num_r
        if (temp(ida, idx) == 1)
            lokasi(a) = b;
            a = a+1;
        end
        b = b + 1;
    end
end

% dapatkan sinyal yang terpotong
suara_EPD = suara2(lokasi(1) : lokasi(end));


