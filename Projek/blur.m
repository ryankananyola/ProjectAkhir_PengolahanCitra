function [OUT] = blurring(I, value)
    % Fungsi untuk mengaburkan (blur) gambar berdasarkan nilai blur

    [x, y, z] = size(I); % Mendapatkan ukuran dimensi gambar (x = tinggi, y = lebar, z = jumlah kanal warna)

    % Mengatur tingkat blur/buram
    blurVal = value; % Nilai blur diambil dari parameter input 'value'

    % Melakukan pembacaan pixel sesuai dimensi gambar
    for i = 1:x % Iterasi untuk setiap baris gambar
        posisi = 1; % Menetapkan posisi awal untuk pengulangan blur
        for j = 1:y % Iterasi untuk setiap kolom gambar
            
            % Mengambil warna dari pixel awal pada setiap blurVal
            if (posisi == 1) % Jika posisi adalah 1, ambil nilai warna awal
                wrnRed = I(i,j,1); % Menyimpan nilai kanal merah dari pixel
                wrnGreen = I(i,j,2); % Menyimpan nilai kanal hijau dari pixel
                wrnBlue = I(i,j,3); % Menyimpan nilai kanal biru dari pixel
            end
            
            % Menetapkan warna ke setiap pixel dalam area blurVal
            img(i,j,1) = wrnRed; % Menetapkan nilai merah pada posisi (i,j)
            img(i,j,2) = wrnGreen; % Menetapkan nilai hijau pada posisi (i,j)
            img(i,j,3) = wrnBlue; % Menetapkan nilai biru pada posisi (i,j)
            
            % Mengupdate posisi untuk pengulangan blur
            posisi = posisi + 1; 
            if(posisi > blurVal) % Jika posisi melebihi blurVal, reset ke 1
                posisi = 1;
            end    
        end
    end

    % Mengonversi gambar ke tipe uint8 untuk ditampilkan
    OUT = uint8(img); % Menyimpan gambar hasil blur dalam variabel OUT
end
