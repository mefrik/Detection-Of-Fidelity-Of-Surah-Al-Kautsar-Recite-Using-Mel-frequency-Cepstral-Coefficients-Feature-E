

% fungsi ini untuk memotong Alkautsar menjadi 3 ayat
function [Ayat] = Potong_Ayat(input, thayat, fs, out_folder, outn)

Ayat1 = [];
Ayat2 = [];
Ayat3 = [];

% Hitung envelope sinyal
env = imdilate(abs(input), true(1, 1501));

% Plot Envelope
judul = 'Envelope ';
if exist ('out_folder') == 1
    nama_title_png = 'Envelope Pemotongan Ayat %s.png';
    nama_title_pdf = 'Envelope Pemotongan Ayat %s.pdf';
    cetak(judul, input, env, fs, out_folder, outn, nama_title_png, ...
        nama_title_pdf)
elseif exist ('fs') == 1
    alldata = {env fs};
    cetak(judul, input, alldata)
end

% Bagian thresholding
ayat = env<thayat;

% Daptkan index dari 0 data ayat
[~, ca] = find(ayat==0);

%% Cari jumlah nilai 0 dari nilai x...xn
range = unique(ca(1,:));
t_n = [];
n_hilang = [];
inc = 1;
for i = 1:numel(range)-1
    temp1 = ca(i);
    temp2 = ca(i+1);
    if temp1 + 1 ~= temp2
        s = temp1+1 : temp2-1;
        n_hilang{inc} = s(:);
        t_n(inc) = numel(s);
        inc = inc + 1;
    end
end

%% Ambil 2 index dari data 0 terbanyak
[~, rc] = maxk(t_n,2);
rc = sort(rc,'ascend');
m1 = cell2mat(n_hilang(rc(1)))';
m2 = cell2mat(n_hilang(rc(2)))';

%% Ambil data suara setiap Ayat

% Ayat 1
Ayat1 = input(1 : m1(1));
% Ayat 2
Ayat2 = input(m1(end) : m2(1));
% Ayat 3
Ayat3 = input(m2(end) : end);

Ayat{1, 1} = Ayat1;
Ayat{2, 1} = Ayat2;
Ayat{3, 1} = Ayat3;

