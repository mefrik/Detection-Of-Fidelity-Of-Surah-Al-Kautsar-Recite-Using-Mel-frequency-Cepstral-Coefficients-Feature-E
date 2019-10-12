
% Program utama untuk template

clear all;
close all;
clc;
warning('off')
set(0,'DefaultFigureVisible','off')

direk = uigetdir('*.*', 'Choose a folder');

if ~isequal(direk, 0)
    
    Nfiles = dir(fullfile(direk, '*.*'));
    for nf = 3 : numel(Nfiles)
        
        %% Baca file suara
        fname = Nfiles(nf).name;
        au_name = fullfile(direk, fname);
        [suara, fs] = audioread(au_name);
        suara = suara';
        fprintf('Proses File: %s\n', fname);
        outn = fname(1 : length(fname)-4);
        
        %% centering
        fprintf(' >> Centering ...');
        suara1 = suara - mean(suara);
        fprintf(' [Selesai]\n');
        
        %% Normalisasi amplitudo sinyal suara
        fprintf(' >> Normalisasi ...');
        suara2 = suara1 / max(abs(suara1));
        fprintf(' [Selesai]\n');
        
        %% Plot data sinyal original
        out_folder = 'TEMPLATE PIC';
        if ~exist(out_folder, 'dir');
            mkdir(out_folder);
        end
        
        judul = 'Sinyal Original ';
        nama_title_png = 'Sinyal Original %s.png';
        nama_title_pdf = 'Sinyal Original %s.pdf';
        cd ('.\functions');
        cetak(judul, fs, suara, out_folder, outn, nama_title_png, nama_title_pdf)
        
        %% Plot data normalisasi dan centering        
        judul = 'Sinyal Setelah Centering dan Normalisasi ';
        nama_title_png = 'Sinyal Setelah Centering dan Normalisasi %s.png';
        nama_title_pdf = 'Sinyal Setelah Centering dan Normalisasi %s.pdf';
        cetak(judul, fs, suara2, out_folder, outn, nama_title_png, nama_title_pdf)  
        
        %% End point detection
        fprintf(' >> End Point Detection ...');
        ts = 0.01;
        thEPD = 0.05;
        suara_EPD = EPD(suara2, fs, ts, thEPD, out_folder, outn);
        fprintf(' [Selesai]\n');
        
        %% Plot hasil end point detection
        judul = 'Sinyal Setelah Pemotongan ';
        nama_title_png = 'Sinyal Setelah Pemotongan %s.png';
        nama_title_pdf = 'Sinyal Setelah Pemotongan %s.pdf';
        cetak(judul, fs, suara_EPD, out_folder, outn, nama_title_png, nama_title_pdf)    
                
        %% Deteksi ayat
        fprintf(' >> Deteksi Ayat ...');
        thayat = 0.05;
        [Ayat] = Potong_Ayat(suara_EPD, thayat, fs, out_folder, outn);
        fprintf(' [Selesai]\n');
        
        %% Plot hasil deteksi Ayat
        judul = 'Hasil Deteksi Ayat ';
        nama_title_png = 'Hasil Deteksi Ayat %s.png';
        nama_title_pdf = 'Hasil Deteksi Ayat %s.pdf';
        cetak(judul, fs, Ayat, out_folder, outn, nama_title_png, nama_title_pdf) 
        
        %% Deteksi Kata
        fprintf(' >> Deteksi Kata ...');
        thkata = 0.05;
        [Kata] = Potong_Kata(Ayat, thkata, fs, out_folder, outn);
        fprintf(' [Selesai]\n');
        
        %% Plot hasil deteksi kata
        judul = 'Hasil Deteksi Kata ';
        nama_title_png = 'Hasil Deteksi Kata Pada %s %s.png';
        nama_title_pdf = 'Hasil Deteksi Kata Pada %s %s.pdf';
        cetak(judul, fs, Kata, out_folder, outn, nama_title_png, nama_title_pdf)
        
        %% Pre-Emphasize
        fprintf(' >> Pre-Emphasize Kata ...');
        cd ('.\functions');
        Kata_pre = filterpreemphasize(Kata);
        fprintf(' [Selesai]\n');
        
        %% Plot hasil Pre-Emphasize
        judul = 'Sinyal Setelah Pre-Emphasize ';
        nama_title_png = 'Sinyal Kata Setelah Pre-Emphasize Pada %s %s.png';
        nama_title_pdf = 'Sinyal Kata Setelah Pre-Emphasize Pada %s %s.pdf';
        cetak(judul, fs, Kata_pre, out_folder, outn, nama_title_png, nama_title_pdf)  
       
        %% Ekstraksi ciri menggunakan MFCC untuk setiap kata
        fprintf(' >> Ekstraksi Ciri Tiap Kata ...');
        judul = 'Ekstraksi Ciri ';
        nama_title_png = 'Representasi Nilai Ceps Kata Pada %s %s.png';
        nama_title_pdf = 'Representasi Nilai Ceps Kata Pada %s %s.pdf';
        cd ('.\functions');
        
        fmccs = zeros(size(Kata_pre, 1), 12);
        for m = 1 : size(Kata_pre, 1)
            for n = 1 : size(Kata_pre, 2)
                if cellfun(@isempty,Kata_pre(m,n)) == 0
                    ceps = mfcc(Kata_pre{m, n}, fs);
                    ceps = nanmean(ceps, 2);
                    fmccs(n, :) = ceps(2 : end);
                end
            end    
            % Plot
            cetak(judul, fmccs, out_folder, outn, nama_title_png, ...
                nama_title_pdf, m, n);
            % Kumpulkan data fmccs
            allfmccs{m, 1} = fmccs;
        end
        cd ..
        
        % Dapatkan seluruh data Kata Ceps pada semua Ayat
        feats{nf - 2, 1} = allfmccs;
        
        % save features as template
        save('feats.mat', 'feats');
        fprintf(' [Selesai]\n');
        
        %% folder untuk simpan hasil potong Ayat & Kata dari file template
        out_folder = 'TEMPLATE WAV';
        if ~exist(out_folder, 'dir');
            mkdir(out_folder);
        end
        
        % Hasil potong Ayat
        for m = 1 : size(Ayat, 1)
            out_name = sprintf('%s_AYAT_%d.wav',outn, m);
            out_name = fullfile(out_folder, out_name);
            audiowrite(out_name, Ayat{m, 1}, fs);
            for n = 1 : size(Kata, 2)
                if cellfun(@isempty,Kata(m,n)) == 0
                    out_name = sprintf('%s_AYAT_%d_KATA_%d.wav',outn, m, n);
                    out_name = fullfile(out_folder, out_name);
                    audiowrite(out_name, Kata{m, n}, fs);
                end
            end
        end
        fprintf('\n');
    end
    fprintf(' >> Proses Selesai ... :)\n');
end

