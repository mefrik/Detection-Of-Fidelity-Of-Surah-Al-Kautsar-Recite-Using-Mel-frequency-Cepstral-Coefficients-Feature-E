

% fungsi ini untuk memotong Kata pada setiap ayat Alkautsar
function [Kata] = Potong_Kata(input, thkata, fs, out_folder, outn)

Kata1 = [];
Kata2 = [];
Kata3 = [];
kata_n_hilang = [];
kata_t_n = [];

% Input data setiap ayat dan cari batas setiap kata
for m = 1 : size(input,1)
    ayat = input{m};
    
    % Hitung envelope sinyal
    env = imdilate(abs(ayat), true(1, 1501));

    % Plot Hasil Envelope Ayat
    % Digunakan untuk proses pemotongan kata
    judul = 'Envelope ';
    if exist ('out_folder') == 1
        nama_title_png = 'Envelope Pemotongan Kata %s %s.png';
        nama_title_pdf = 'Envelope Pemotongan Kata %s %s.pdf';
        cetak(judul, ayat, fs, out_folder, outn, nama_title_png, nama_title_pdf, env, m)
        cd ('.\functions');
    elseif exist ('fs') == 1
        alldata = {env fs m};
        cetak(judul, ayat, alldata)
        cd ('.\functions');
    end

    % Bagian thresholding
    kata = env<thkata;
    
    % Dapatkan index dari 0 data kata
    [~, ca] = find(kata==0);
    
    % Cari jumlah nilai 0 dari nilai x...xn
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
    
    %% Ambil index dari data 0 terbanyak pada ayat 1,2 dan 3
    
    if m == 1 || m == 2
        % Cari range nilai titik 0 dari index terbanyak Ayat ke 1 & 2
        [~, rc] = maxk(t_n,2);
        rc = sort(rc,'ascend');
        % Kata 1
        m1 = cell2mat(n_hilang(rc(1)))';
        % Kata 2
        m2 = cell2mat(n_hilang(rc(2)))';
        
        % Ambil data suara setiap Ayat ke 1 & 2
        % Kata 1
        Kata1 = ayat(1 : m1(1));
        % Kata 2
        Kata2 = ayat(m1(end) : m2(1));
        % Kata 3
        Kata3 = ayat(m2(end) : end);
    elseif m == 3
        [~, rc] = maxk(t_n,3);
        rc = sort(rc,'ascend');
        % Kata 1
        m1 = cell2mat(n_hilang(rc(1)))';
        % Kata 2
        m2 = cell2mat(n_hilang(rc(2)))';
        % Kata 3
        m3 = cell2mat(n_hilang(rc(3)))';
        
        % Ambil data suara setiap Ayat ke 3
        % Kata 1
        Kata1 = ayat(1 : m1(1));
        % Kata 2
        Kata2 = ayat(m1(end) : m2(1));
        % Kata 3
        Kata3 = ayat(m2(end) : m3(1));
        % Kata 4
        Kata4 = [];
        Kata4 = ayat(m3(end) : end);
    end
    
    %% Ambil data suara setiap Ayat
    Kata{m, 1} = Kata1;
    Kata{m, 2} = Kata2;
    Kata{m, 3} = Kata3;
    Cek_Kata4 = exist('Kata4');
    if  Cek_Kata4 == 1
        Kata{m, 4} = Kata4;
    end
    
    % Banyak range nilai titik 0 yang hilang sebagai jeda antar kata pada setiap ayat
    kata_n_hilang{m} = n_hilang;
    % Banyak elemen nilai 0 yang menjadi jeda antar kata pada setiap ayat
    kata_t_n{m} = t_n;
    
end

