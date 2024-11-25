function histogramRGB(I)
    % Fungsi untuk menampilkan histogram RGB dari citra dengan membersihkan histogram lama

    cla; % Membersihkan histogram sebelumnya di axes aktif

    if(size(I,3) ~= 3) % Mengecek apakah gambar bukan citra RGB
        imhist(I); % Jika gambar bukan RGB, tampilkan histogram grayscale
    else
        nBins = 256; % Menentukan jumlah bins untuk histogram

        % Menghitung histogram untuk masing-masing kanal warna
        rHist = imhist(I(:,:,1), nBins); % Histogram untuk kanal merah
        gHist = imhist(I(:,:,2), nBins); % Histogram untuk kanal hijau
        bHist = imhist(I(:,:,3), nBins); % Histogram untuk kanal biru

        % Menentukan batas y-axis maksimum yang optimal
        % Mengabaikan puncak nilai yang sangat tinggi untuk zoom
        maxHistValue = max([max(rHist), max(gHist), max(bHist)]);
        scaledMaxValue = min(maxHistValue, 800); % Batas maksimum, misal di sini 1000 untuk zoom optimal

        % Menampilkan histogram untuk masing-masing kanal warna
        area(1:nBins, rHist, 'FaceColor', 'r'); hold on; % Menampilkan histogram merah
        area(1:nBins, gHist, 'FaceColor', 'g'); hold on; % Menampilkan histogram hijau
        area(1:nBins, bHist, 'FaceColor', 'b'); hold on; % Menampilkan histogram biru

        % Atur batas sumbu y untuk zoom optimal
        ylim([0, scaledMaxValue]); % Batas y-axis diatur agar histogram lebih terlihat

        hold off; % Melepaskan hold agar perubahan selanjutnya tidak menumpuk
    end
end
