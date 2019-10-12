

% fungsi untuk menyimpan gambar ploting figure as (.png & .pdf)
function cetak(varargin)
cd ..

%% Plot & Export untuk Multi Testing ...
if length(varargin) > 3
    FigW=6;
    FigH=2.7;
    set(figure,'defaulttextinterpreter','latex',...
        'PaperUnits','inches','Papersize',[FigW,FigH],...
        'Paperposition',[0,0,FigW,FigH],'Units','Inches',...
        'Position',[0,0,FigW,FigH])
    
    n_ayat = {'Ayat Pertama', 'Ayat Kedua', 'Ayat Ketiga'};
    n_kata = {'Kata Pertama','Kata Kedua','Kata Ketiga','Kata Keempat'};
    clor = {'blue','red','green','cyan'};
    
    if contains(varargin{1},'Original') || contains(varargin{1},'Centering') ...
            || contains(varargin{1},'Pemotongan')
        judul = varargin{1};
        fs = varargin{2};
        suara = varargin{3};
        out_folder = varargin{4};
        outn = varargin{5};
        nama_title_png = varargin{6};
        nama_title_pdf = varargin{7};
        
        out_name_data = sprintf('%s',outn);
        plot((1 : length(suara)) / fs, suara);
        if contains(varargin{1},'Original') == 1
            title([judul, out_name_data]);
        else
            title(judul);
        end
        xlabel('Waktu (detik)');
        ylabel('Amplitudo');
        
    elseif contains(varargin{1},'Ayat')
        judul = varargin{1};
        fs = varargin{2};
        Ayat = varargin{3};
        out_folder = varargin{4};
        outn = varargin{5};
        nama_title_png = varargin{6};
        nama_title_pdf = varargin{7};
        
        d1 = length(Ayat{1});
        d2 = length(Ayat{2});
        d3 = length(Ayat{3});
        
        plot((1:d1)/fs , Ayat{1}, 'b-'); hold on;
        plot((d1+1:d1+d2)/fs, Ayat{2}, 'r-'); hold on;
        plot((d1+d2+1:d1+d2+d3)/fs, Ayat{3}, 'g-'); hold off;
        legend(n_ayat{1}, n_ayat{2}, n_ayat{3});
        title(judul);
        xlabel('Waktu (Detik)');
        ylabel('Amplitudo');
        
    elseif contains(varargin{1},'Kata') || contains(varargin{1},'Pre-Emphasize')
        judul = varargin{1};
        fs = varargin{2};
        Kata = varargin{3};
        out_folder = varargin{4};
        outn = varargin{5};
        nama_title_png = varargin{6};
        nama_title_pdf = varargin{7};
        
        for m = 1 : size(Kata,1)
            d1 = length(Kata{m,1});
            d2 = length(Kata{m,2});
            d3 = length(Kata{m,3});
            if m + 1 == 4
                d4 = length(Kata{m,4});
            end
            
            plot((1:d1)/fs, Kata{m,1}, 'b-'); hold on;
            plot((d1+1:d1+d2)/fs, Kata{m,2}, 'r-'); hold on;
            plot((d1+d2+1:d1+d2+d3)/fs, Kata{m,3}, 'g-'); hold on;
            Cek_d4 = exist('d4');
            if  Cek_d4 == 1
                plot((d1+d2+d3+1:d1+d2+d3+d4)/fs, Kata{m,4}, 'c-'); hold off;
                legend(n_kata{1}, n_kata{2} ,n_kata{3} ,n_kata{4});
            else
                legend(n_kata{1}, n_kata{2} ,n_kata{3});
            end
            if contains(varargin{1},'Kata')
                title(['Hasil Deteksi Kata Pada ', n_ayat{m}]);
            else
                title(['Hasil Pre-Emphasize Kata Pada ', n_ayat{m}]);
            end
            xlabel('Waktu (Detik)');
            ylabel('Amplitudo');
            
            grid on;
            grid minor;
            
            set(gca,...
                'FontSize',10,...
                'FontName','Times New Roman'); % LaTex Arial
            
            out_name_png = sprintf(nama_title_png, n_ayat{m}, outn);
            out_name_png = fullfile(out_folder, out_name_png);
            out_name_pdf = sprintf(nama_title_pdf, n_ayat{m}, outn);
            out_name_pdf = fullfile(out_folder, out_name_pdf);
            print ('-dpng','-r500', out_name_png);
            print ('-dpdf','-r500', out_name_pdf);
            clf
        end
        clear d4;
        return
        
    elseif contains(varargin{1},'Ekstraksi')
        judul = varargin{1};
        fmcss = varargin{2};
        out_folder = varargin{3};
        outn = varargin{4};
        nama_title_png = varargin{5};
        nama_title_pdf = varargin{6};
        m = varargin{7};
        
        plot(fmcss(1,:), clor{1}); hold on;
        plot(fmcss(2,:), clor{2}); hold on;
        plot(fmcss(3,:), clor{3}); hold on;
        if size(fmcss, 1) == 4
            plot(fmcss(4,:), clor{4});
            legend(n_kata{1}, n_kata{2} ,n_kata{3}, n_kata{4});
        else
            legend(n_kata{1}, n_kata{2} ,n_kata{3});
        end
        hold off;
        
        title(['Representasi Nilai Ceps Setiap Kata Pada ', n_ayat{m}]);
        xlabel('Vektor');
        ylabel('Cepstrum');
        xlim([1 12]);
        grid on;
        grid minor;
        
        set(gca,...
            'FontSize',10,...
            'FontName','Times New Roman');
        
        out_name_png = sprintf(nama_title_png, n_ayat{m} ,outn);
        out_name_png = fullfile(out_folder, out_name_png);
        out_name_pdf = sprintf(nama_title_pdf, n_ayat{m}, outn);
        out_name_pdf = fullfile(out_folder, out_name_pdf);
        print ('-dpng','-r500', out_name_png);
        print ('-dpdf','-r500', out_name_pdf);
        
        clf
        cd ('.\functions');
        return
        
    elseif contains(varargin{1},'Spectrogram')
        judul = varargin{1};
        suara2 = varargin{2};
        out_folder = varargin{3};
        outn = varargin{4};
        nama_title_png = varargin{5};
        nama_title_pdf = varargin{6};
        window = varargin{7};
        winoverlap = varargin{8};
        pjg = varargin{9};
        fs = varargin{10};
        
        spectrogram(suara2,window,winoverlap,pjg,fs,'yaxis')
        xlabel('Waktu(Detik)');
        ylabel('Frekuensi(kHz)');
        %         yyaxis('right');
        %         ylabel('Energi/Frekuensi(dB/Hz)');
        out_name_data = sprintf('%s',outn);
        title(judul);
        
    elseif contains(varargin{1},'Envelope')
        envup = imdilate(varargin{2}, true(1, 1501));
        if  length(varargin) <= 8
            judul = varargin{1};
            suara_EPD = varargin{2};
            env = varargin{3};
            fs = varargin{4};
            out_folder = varargin{5};
            outn = varargin{6};
            nama_title_png = varargin{7};
            nama_title_pdf = varargin{8};
            
            out_name_data = sprintf('%s',outn);
            t = (1 : length(suara_EPD)) / fs;
            plot(t,suara_EPD);
            drawnow;
            
            
            hold on;
            plot(t, envup, 'r-', 'LineWidth', 1.5);
            plot(t,-env, 'r-', 'LineWidth', 1.5);
            legend('Sinyal setelah pemotongan', 'Envelope');
            
            title('Sinyal setelah pemotongan + Envelope');
            xlabel('Waktu (detik)');
            ylabel('Amplitudo');
            
        else
            judul = varargin{1};
            ayat = varargin{2};
            fs = varargin{3};
            out_folder = varargin{4};
            outn = varargin{5};
            nama_title_png = varargin{6};
            nama_title_pdf = varargin{7};
            env = varargin{8};
            m = varargin{9};
            
            out_name_data = sprintf('%s',outn);
            t = (1 : length(ayat)) / fs;
            plot(t,ayat);
            drawnow;
            
            hold on;
            plot(t,envup, 'r-', 'LineWidth', 1.5);
            plot(t,-env, 'r-', 'LineWidth', 1.5);
            legend('Sinyal Ayat', 'Envelope');
            
            title(['Sinyal ', n_ayat{m},' + Envelope']);
            xlabel('Waktu (detik)');
            ylabel('Amplitudo');
            
            grid on;
            grid minor;
            
            set(gca,...
                'FontSize',10,...
                'FontName','Times New Roman');
            
            out_name_png = sprintf(nama_title_png, n_ayat{m},outn);
            out_name_png = fullfile(out_folder, out_name_png);
            out_name_pdf = sprintf(nama_title_pdf, n_ayat{m},outn);
            out_name_pdf = fullfile(out_folder, out_name_pdf);
            print ('-dpng','-r500', out_name_png);
            print ('-dpdf','-r500', out_name_pdf);
            clf
            return
        end
        
    elseif contains(varargin{1},'ceps')
        judul = varargin{1};
        ceps = varargin{2};
        m = varargin{3};
        n = varargin{4};
        a = 1:12;
        out_folder = varargin{5};
        outn = varargin{6};
        
        n_kata2 = {'Kata Pertama ','Kata Kedua ','Kata Ketiga ','Kata Keempat '};
        nama_title_png = 'Perbandingan Nilai Ceps %s %s %s.png';
        nama_title_pdf = 'Perbandingan Nilai Ceps %s %s %s.pdf';

        plot(a,ceps(2,:),'b', a,ceps(1,:),'r');
        legend('Data Latih (Template)','Data Uji');
        
        title(['Perbandingan Nilai Ceps Pada ', n_kata2{n}, n_ayat{m}]);
        xlabel('Vektor');
        ylabel('Cepstrum');
        xlim([1 12]);
        grid on;
        grid minor;
        
        set(gca,...
            'FontSize',10,...
            'FontName','Times New Roman');
        
        out_name_png = sprintf(nama_title_png,  n_kata{n}, n_ayat{m} ,outn);
        out_name_png = fullfile(out_folder, out_name_png);
        out_name_pdf = sprintf(nama_title_pdf,  n_kata{n}, n_ayat{m}, outn);
        out_name_pdf = fullfile(out_folder, out_name_pdf);
        print ('-dpng','-r500', out_name_png);
        print ('-dpdf','-r500', out_name_pdf);
        
        clf
        
        cd ('.\functions');
        return
        
    end
    
    grid on;
    grid minor;
    
    set(gca,...
        'FontSize',10,...
        'FontName','Times New Roman');
    
    % Export Data
    out_name_png = sprintf(nama_title_png,outn);
    out_name_png = fullfile(out_folder, out_name_png);
    out_name_pdf = sprintf(nama_title_pdf,outn);
    out_name_pdf = fullfile(out_folder, out_name_pdf);
    print ('-dpng','-r500', out_name_png);
    print ('-dpdf','-r500', out_name_pdf);
    
    clear varargin
    cd ('.\functions');
    
    
else
    %% Hanya untuk ploting, Single Testing ...
    
    FigW=6;
    FigH=2.8;
    set(figure,'defaulttextinterpreter','latex',...
        'PaperUnits','inches','Papersize',[FigW,FigH],...
        'Paperposition',[0,0,FigW,FigH],'Units','Inches',...
        'Position',[0,0,FigW,FigH])
    
    n_ayat = {'Ayat Pertama', 'Ayat Kedua', 'Ayat Ketiga'};
    n_kata = {'Kata Pertama','Kata Kedua','Kata Ketiga','Kata Keempat'};
    clor = {'blue','red','green','cyan'};
    
    if contains(varargin{1},'Original') || contains(varargin{1},'Centering') ...
            || contains(varargin{1},'Pemotongan') || contains(varargin{1},'Pre-Emphasize')
        judul = varargin{1};
        fs = varargin{2};
        suara = varargin{3};
        
        plot((1 : length(suara)) / fs, suara);
        title(judul);
        xlabel('Waktu (detik)');
        ylabel('Amplitudo');
        
    elseif contains(varargin{1},'Ayat')
        judul = varargin{1};
        fs = varargin{2};
        Ayat = varargin{3};
        
        d1 = length(Ayat{1});
        d2 = length(Ayat{2});
        d3 = length(Ayat{3});
        
        plot((1:d1)/fs , Ayat{1}, 'b-'); hold on;
        plot((d1+1:d1+d2)/fs, Ayat{2}, 'r-'); hold on;
        plot((d1+d2+1:d1+d2+d3)/fs, Ayat{3}, 'g-'); hold off;
        legend(n_ayat{1}, n_ayat{2}, n_ayat{3});
        title(judul);
        xlabel('Waktu (Detik)');
        ylabel('Amplitudo');
        
    elseif contains(varargin{1},'Kata')
        judul = varargin{1};
        fs = varargin{2};
        Kata = varargin{3};
        
        for m = 1 : size(Kata,1)
            d1 = length(Kata{m,1});
            d2 = length(Kata{m,2});
            d3 = length(Kata{m,3});
            if m + 1 == 4
                d4 = length(Kata{m,4});
            end
            
            plot((1:d1)/fs, Kata{m,1}, 'b-'); hold on;
            plot((d1+1:d1+d2)/fs, Kata{m,2}, 'r-'); hold on;
            plot((d1+d2+1:d1+d2+d3)/fs, Kata{m,3}, 'g-'); hold on;
            Cek_d4 = exist('d4');
            if  Cek_d4 == 1
                plot((d1+d2+d3+1:d1+d2+d3+d4)/fs, Kata{m,4}, 'c-'); hold off;
                legend(n_kata{1}, n_kata{2} ,n_kata{3} ,n_kata{4});
            else
                legend(n_kata{1}, n_kata{2} ,n_kata{3});
            end
            title(['Hasil Deteksi Kata Pada ', n_ayat{m}]);
            xlabel('Waktu (Detik)');
            ylabel('Amplitudo');
            
            grid on;
            grid minor;
            
            set(gca,...
                'FontSize',10,...
                'FontName','Times New Roman'); % LaTex Arial
            
            if m ~= 3
                FigW=6;
                FigH=2.8;
                set(figure,'defaulttextinterpreter','latex',...
                    'PaperUnits','inches','Papersize',[FigW,FigH],...
                    'Paperposition',[0,0,FigW,FigH],'Units','Inches',...
                    'Position',[0,0,FigW,FigH])
            end
        end
        clear d4;
        return
        
    elseif contains(varargin{1},'Ekstraksi')
        judul = varargin{1};
        ceps = varargin{2};
        m = varargin{3};
        
        plot(ceps{m}(1,:), clor{1}); hold on;
        plot(ceps{m}(2,:), clor{2}); hold on;
        plot(ceps{m}(3,:), clor{3}); hold on;
        if m == 3
            plot(ceps{m}(4,:), clor{4});
            legend(n_kata{1}, n_kata{2} ,n_kata{3}, n_kata{4});
        else
            legend(n_kata{1}, n_kata{2} ,n_kata{3});
        end
        hold off;
        
        title(['Representasi Nilai Ceps Setiap Kata Pada ', n_ayat{m}]);
        xlabel('Vektor');
        ylabel('Cepstrum');
        xlim([1 12]);
        grid on;
        grid minor;
        
        set(gca,...
            'FontSize',10,...
            'FontName','Times New Roman');
        
        cd ('.\functions');
        return
        
    elseif contains(varargin{1},'Spectrogram')
        judul = varargin{1};
        suara2 = varargin{2};
        window = varargin{3}{1};
        winoverlap = varargin{3}{2};
        pjg = varargin{3}{3};
        fs = varargin{3}{4};
        
        spectrogram(suara2,window,winoverlap,pjg,fs,'yaxis')
        xlabel('Waktu(Detik)');
        ylabel('Frekuensi(kHz)');
        %         yyaxis('right');
        %         ylabel('Energi/Frekuensi(dB/Hz)');
        title(judul);
        
        
    elseif contains(varargin{1},'Envelope')
        envup = imdilate(varargin{2}, true(1, 1501));
        if size(varargin{3},2) <= 2
            judul = varargin{1};
            suara_EPD = varargin{2};
            env = varargin{3}{1};
            fs = varargin{3}{2};
            
            t = (1 : length(suara_EPD)) / fs;
            plot(t,suara_EPD);
            drawnow;
            
            hold on;
            plot(t,envup, 'r-', 'LineWidth', 1.5);
            plot(t,-env, 'r-', 'LineWidth', 1.5);
            legend('Sinyal EPD', 'Envelope');
            
            title('Sinyal EPD + Envelope ');
            xlabel('Waktu (detik)');
            ylabel('Amplitudo');
        else
            judul = varargin{1};
            ayat = varargin{2};
            env = varargin{3}{1};
            fs = varargin{3}{2};
            m = varargin{3}{3};
            
            t = (1 : length(ayat)) / fs;
            plot(t,ayat);
            drawnow;
            
            hold on;
            plot(t,envup, 'r-', 'LineWidth', 1.5);
            plot(t,-env, 'r-', 'LineWidth', 1.5);
            legend('Sinyal Ayat', 'Envelope');
            
            title(['Sinyal ', n_ayat{m},' + Envelope']);
            xlabel('Waktu (detik)');
            ylabel('Amplitudo');
            
            grid on;
            grid minor;
            
            set(gca,...
                'FontSize',10,...
                'FontName','Times New Roman');
            
            clear varargin
            return
        end
        
    elseif contains(varargin{1},'ceps')
        judul = varargin{1};
        ceps = varargin{2};
        m = varargin{3}(1);
        n = varargin{3}(2);
        a = 1:12;
        
        n_kata2 = {'Kata Pertama ','Kata Kedua ','Kata Ketiga ','Kata Keempat '};
        plot(a,ceps(2,:),'b', a,ceps(1,:),'r');
        legend('Data Latih (Template)','Data Uji');
        
        title(['Perbandingan Nilai Ceps Pada ', n_kata2{m}, n_ayat{n}]);
        xlabel('Vektor');
        ylabel('Cepstrum');
        xlim([1 12]);
        grid on;
        grid minor;
        
        set(gca,...
            'FontSize',10,...
            'FontName','Times New Roman');
        
        cd ('.\functions');
        return
    end
    
    grid on;
    grid minor;
    
    set(gca,...
        'FontSize',10,...
        'FontName','Times New Roman');
    
    clear varargin
    cd ('.\functions');
end


