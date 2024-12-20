function varargout = ProjekAkhir(varargin)
% PROJEKAKHIR MATLAB code for ProjekAkhir.fig
%      PROJEKAKHIR, by itself, creates a new PROJEKAKHIR or raises the existing

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProjekAkhir_OpeningFcn, ...
                   'gui_OutputFcn',  @ProjekAkhir_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ProjekAkhir is made visible.
function ProjekAkhir_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for ProjekAkhir
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
ah = axes('Units', 'normalized', 'Position', [0 0 1 1]);
set(ah, 'handleVisibility', 'off', 'visible', 'off')

% UIWAIT makes ProjekAkhir wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ProjekAkhir_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in uploadBTN.
function uploadBTN_Callback(hObject, eventdata, handles)
% hObject    handle to uploadBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
global G;
[nama, alamat] = uigetfile({'*.jpg';'*.bmp';'*.png';'*.tif'}, 'Browse Image'); %ngambil data
I = imread([alamat,nama]); %baca data yang dipilih

handles.image=I; %gambar yang dipilih disimpan ke I
guidata(hObject, handles);
axes(handles.axes3); %akses axes3
imshow(I,[]); %menampilkan gambar
G=I; %menyimpan data I ke G, jd isinya sama G dg I, nanti G yang berubah karena image processingnya
axes(handles.axes6); %akses axes6 buat histogram asal
histogramRGB(G); %nampil fungsi histogramRGB

% --- Executes on button press in resetBTN.
function resetBTN_Callback(hObject, eventdata, handles)
    % Callback untuk tombol reset

    global G; % Memanggil variabel global G (gambar hasil olahan)
    global I; % Memanggil variabel global I (gambar asli)

    citra = handles.image; % Mengambil gambar asli dari handle image
    axes(handles.axes3); % Memilih axes3 untuk menampilkan gambar asli
    cla; % Membersihkan gambar yang ada di axes3
    imshow(citra); % Menampilkan gambar asli di axes3

    axes(handles.axes4); % Memilih axes4 (tempat gambar setelah pengolahan)
    cla reset; % Membersihkan gambar dan reset properties di axes4

    axes(handles.axes7); % Memilih axes7 (tempat histogram)
    cla reset; % Membersihkan histogram dan reset properties di axes7

    G = I; % Mengembalikan variabel G ke gambar asli (I) untuk reset ke kondisi awal

    % Reset nilai sliderContrast dan tampilannya
    set(handles.sliderContrast, 'Value', 1); % Mengatur nilai sliderContrast ke 0
    set(handles.hslSliderContrast, 'String', '1'); % Mengatur tampilan hslSliderContrast ke 0

    set(handles.sliderBrightness, 'Value', 0); % Mengatur nilai sliderBrightness ke 0
    set(handles.hslSliderBrightness, 'String', '0'); % Mengatur tampilan hslSliderBrightness ke 0

    set(handles.sliderBlur, 'Value', 0); % Mengatur nilai sliderBlur ke 0
    set(handles.hslSliderBlur, 'String', '0'); % Mengatur tampilan hslSliderBlur ke 0

    set(handles.sliderSharpness, 'Value', 0); % Mengatur nilai sliderSharpness ke 0
    set(handles.hslSliderSharpness, 'String', '0'); % Mengatur tampilan hslSliderSharpness ke 0
    
    set(handles.sliderNoise, 'Value', 0); % Mengatur nilai sliderNoise ke 0
    set(handles.hslSliderNoise, 'String', '0'); % Mengatur tampilan hslSliderNoise ke 0

    guidata(hObject, handles); % Menyimpan perubahan data handles (jika ada)



% --- Executes on button press in simpanBTN.
function simpanBTN_Callback(hObject, eventdata, handles)
% Callback untuk tombol simpan

global G; % Memanggil variabel global G (gambar hasil olahan)
% Membuka dialog untuk menyimpan file dengan pilihan format PNG atau JPG
[nama, alamat] = uiputfile({'*.png','PNG (*.PNG)';'*.jpg','JPG (*.jpg)'}, 'Save Image');
% Menyimpan gambar hasil olahan (G) ke lokasi yang dipilih oleh pengguna
imwrite(G, fullfile(alamat, nama));
guidata(hObject, handles); % Menyimpan perubahan data handles (jika ada)


% --- Executes on slider movement.
function sliderContrast_Callback(hObject, eventdata, handles)
    % Callback untuk slider kontras

    global G; % Memanggil variabel global G untuk menyimpan gambar hasil olahan
    valueCon = get(handles.sliderContrast, 'Value'); % Mendapatkan nilai kontras dari slider
    valueBri = get(handles.sliderBrightness, 'Value'); % Mendapatkan nilai kecerahan dari slider
    valueBlur = get(handles.sliderBlur, 'Value'); % Mendapatkan nilai blur dari slider
    valueSharp = get(handles.sliderSharpness, 'Value'); % Mendapatkan nilai ketajaman dari slider
    set(handles.hslSliderContrast, 'String', valueCon); % Menampilkan nilai kontras di GUI
    valueNoise = get(handles.sliderNoise, 'Value'); % Mendapatkan nilai noise dari slider
    
    % Ambil gambar asli dari handles.image
    citra = handles.image;

    % Tambahkan kecerahan pada gambar asli berdasarkan nilai brightness
    brightImage = citra + valueBri;

    % Tambahkan noise "salt & pepper" secara manual pada gambar yang sudah diberi kecerahan
    noise = brightImage;
    [rows, cols, channels] = size(noise);
    for c = 1:channels
        for i = 1:rows
            for j = 1:cols
                randValue = rand(); % Nilai acak antara 0 dan 1
                if randValue < valueNoise / 2
                    noise(i, j, c) = 0; % Salt (hitam)
                elseif randValue < valueNoise
                    noise(i, j, c) = 255; % Pepper (putih)
                end
            end
        end
    end

    % Terapkan efek blur pada gambar dengan menggunakan nilai blur
    blurImage = blur(noise, valueBlur);

    % Sharpen gambar menggunakan fungsi imsharpen dengan radius dan amount yang sesuai
    sharpenedImage = imsharpen(blurImage, 'Radius', 2, 'Amount', valueSharp);

    % Terapkan kontras pada gambar yang sudah diberi efek sharpen
    kontras = valueCon * sharpenedImage;
    
    % Simpan hasil akhir ke variabel global G
    G = kontras;
    axes(handles.axes4); % Menampilkan gambar hasil di axes4
    guidata(hObject, handles); % Menyimpan perubahan data handles
    
    % Menampilkan gambar dengan scaling otomatis di axes4
    imshow(G, []); 
    
    % Menampilkan histogram RGB dari gambar hasil olahan di axes7
    axes(handles.axes7);
    histogramRGB(G); % Fungsi untuk menampilkan histogram RGB

    

% --- Executes during object creation, after setting all properties.
function sliderContrast_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderBrightness_Callback(hObject, eventdata, handles)
    % Callback untuk slider brightness (kecerahan)

    global G; % Memanggil variabel global G untuk menyimpan gambar hasil olahan
    
    % Mendapatkan nilai dari slider yang berbeda
    valueCon = get(handles.sliderContrast, 'Value');    % Nilai kontras dari slider
    valueBri = get(handles.sliderBrightness, 'Value');  % Nilai brightness dari slider
    valueSharp = get(handles.sliderSharpness, 'Value'); % Nilai ketajaman dari slider
    valueNoise = get(handles.sliderNoise, 'Value');     % Nilai noise dari slider
    valueBlur = get(handles.sliderBlur, 'Value');       % Nilai blur dari slider
    
    % Menampilkan nilai brightness di GUI
    set(handles.hslSliderBrightness, 'String', valueBri); 

    % Ambil gambar asli dari handles.image
    citra = handles.image;
    
    % Tambahkan noise 'salt & pepper' secara manual berdasarkan nilai dari slider noise
    noise = citra;
    [rows, cols, channels] = size(noise);
    for c = 1:channels
        for i = 1:rows
            for j = 1:cols
                randValue = rand(); % Nilai acak antara 0 dan 1
                if randValue < valueNoise / 2
                    noise(i, j, c) = 0; % Salt (hitam)
                elseif randValue < valueNoise
                    noise(i, j, c) = 255; % Pepper (putih)
                end
            end
        end
    end

    % Mengatur kontras gambar dengan mengalikan noise + brightness dengan nilai kontras
    kontras = valueCon * (noise + valueBri);
    
    % Menerapkan efek blur pada gambar yang sudah diatur kontrasnya
    blurImage = blur(kontras, valueBlur);
    
    % Meningkatkan ketajaman gambar dengan radius dan amount yang sesuai
    sharpenedImage = imsharpen(blurImage, 'Radius', 2, 'Amount', valueSharp);
    
    % Menambahkan efek brightness pada gambar yang sudah ditingkatkan ketajamannya
    cerah = sharpenedImage + valueBri;
    
    % Menyimpan hasil akhir di variabel global G
    G = cerah;
    
    % Menampilkan gambar hasil di axes4
    axes(handles.axes4); 
    guidata(hObject, handles); % Menyimpan perubahan data handles
    
    % Menampilkan gambar dengan scaling otomatis di axes4
    imshow(G, []);
    
    % Menampilkan histogram RGB dari gambar hasil olahan di axes7
    axes(handles.axes7);
    histogramRGB(G); % Fungsi untuk menampilkan histogram RGB
    


% --- Executes during object creation, after setting all properties.
function sliderBrightness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderBrightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in grayScale.
function grayScale_Callback(hObject, eventdata, handles)
    % Callback untuk tombol grayscale

    global G; % Memanggil variabel global G untuk menyimpan gambar hasil olahan
    
    % Akses axes4 untuk menampilkan gambar hasil olahan di GUI
    axes(handles.axes4);

    % Perhitungan manual untuk mengubah gambar menjadi grayscale
    % Asumsikan G adalah gambar RGB dengan dimensi MxNx3
    if size(G, 3) == 3 % Memastikan gambar memiliki tiga channel (RGB)
        % Menggunakan rumus luminance standar: Y = 0.2989 * R + 0.5870 * G + 0.1140 * B
        R = G(:, :, 1); % Channel merah
        G_channel = G(:, :, 2); % Channel hijau
        B = G(:, :, 3); % Channel biru
        
        % Menghitung nilai grayscale
        G = uint8(0.2989 * double(R) + 0.5870 * double(G_channel) + 0.1140 * double(B));
    end

    % Menyimpan data handles jika ada perubahan
    guidata(hObject, handles);

    % Menampilkan gambar grayscale di axes4 dengan scaling otomatis
    imshow(G, []);

    % Akses axes7 untuk menampilkan histogram dari gambar hasil olahan
    axes(handles.axes7);

    % Menampilkan histogram RGB dari gambar grayscale di axes7
    histogramRGB(G);


% --- Executes on button press in negatif.
function negatif_Callback(hObject, eventdata, handles)
% Callback untuk tombol negatif

    global G; % Mendeklarasikan variabel global G yang akan digunakan dalam fungsi
    axes(handles.axes4); % Mengatur axes yang aktif menjadi axes4

    % Perhitungan manual untuk membuat citra negatif
    if size(G, 3) == 3 % Jika gambar memiliki 3 channel (RGB)
        R = G(:, :, 1); % Channel merah
        G_channel = G(:, :, 2); % Channel hijau
        B = G(:, :, 3); % Channel biru

        % Menghitung nilai negatif untuk setiap channel
        R_neg = 255 - R;
        G_neg = 255 - G_channel;
        B_neg = 255 - B;

        % Menggabungkan kembali channel untuk menghasilkan gambar negatif
        G = cat(3, R_neg, G_neg, B_neg);
    else % Untuk gambar grayscale
        G = 255 - G;
    end

    guidata(hObject, handles); % Menyimpan perubahan data ke objek handle

    % Menampilkan citra negatif pada axes yang telah diatur
    imshow(G, []);

    axes(handles.axes7); % Mengatur axes yang aktif menjadi axes7
    histogramRGB(G);


% --- Executes on button press in binary.
function binary_Callback(hObject, eventdata, handles)
% Callback untuk tombol binary

    global G; % Mendeklarasikan variabel global G yang akan digunakan dalam fungsi
    axes(handles.axes4); % Mengatur axes yang aktif menjadi axes4

    % Perhitungan manual untuk mengubah citra menjadi biner
    threshold = 128; % Ambang batas untuk konversi biner (0-255)

    if size(G, 3) == 3 % Jika gambar memiliki 3 channel (RGB)
        % Konversi ke grayscale terlebih dahulu
        R = G(:, :, 1); % Channel merah
        G_channel = G(:, :, 2); % Channel hijau
        B = G(:, :, 3); % Channel biru
        
        % Menggunakan rumus luminance standar untuk grayscale
        grayscale = uint8(0.2989 * double(R) + 0.5870 * double(G_channel) + 0.1140 * double(B));
    else
        grayscale = G; % Jika sudah grayscale
    end

    % Mengubah ke citra biner berdasarkan ambang batas
    G = uint8(grayscale >= threshold) * 255; % 255 untuk putih, 0 untuk hitam

    guidata(hObject, handles); % Menyimpan perubahan data ke objek handle

    % Menampilkan citra biner pada axes4 dengan skala array untuk efek langsung
    imshow(G, []);

    axes(handles.axes7); % Mengatur axes yang aktif menjadi axes7
    histogramRGB(G); % Menampilkan histogram RGB dari citra biner G



% --- Executes on button press in equalBTN.
function equalBTN_Callback(hObject, eventdata, handles)
% Callback untuk tombol equalization (penyetaraan histogram) tanpa slider

global G; % Memanggil variabel global G (gambar hasil olahan)
axes(handles.axes4); % Memilih axes4 untuk menampilkan hasil
% Cek apakah gambar memiliki 3 kanal warna (RGB)
if size(G, 3) == 3
    % Terapkan histogram equalization pada setiap kanal warna
    G_eq(:,:,1) = histeq(G(:,:,1)); % Equalization pada kanal R
    G_eq(:,:,2) = histeq(G(:,:,2)); % Equalization pada kanal G
    G_eq(:,:,3) = histeq(G(:,:,3)); % Equalization pada kanal B
else
    % Jika gambar sudah grayscale, langsung lakukan equalization
    G_eq = histeq(G);
end
% Memperbarui variabel global G dengan gambar hasil equalization
G = G_eq;
guidata(hObject, handles); % Menyimpan perubahan data handles (jika ada)
% Menampilkan gambar hasil equalization di axes4
imshow(G, []);
% Menampilkan histogram RGB dari gambar hasil equalization
axes(handles.axes7); % Memilih axes7 untuk menampilkan histogram
histogramRGB(G); % Menampilkan histogram dari gambar equalization berwarna


% --- Executes on slider movement.
function sliderSharpness_Callback(hObject, eventdata, handles)

global G; % Mendeklarasikan variabel global G yang akan digunakan dalam fungsi

% Ambil nilai slider dari GUI untuk berbagai parameter
valueSharp = get(handles.sliderSharpness, 'Value'); % Mengambil nilai sharpness dari slider sharpness
set(handles.hslSliderSharpness, 'String', valueSharp); % Menampilkan nilai sharpness pada GUI
valueCon = get(handles.sliderContrast, 'Value'); % Mengambil nilai kontras dari slider contrast
valueBri = get(handles.sliderBrightness, 'Value'); % Mengambil nilai brightness dari slider brightness
valueBlur = get(handles.sliderBlur, 'Value'); % Mengambil nilai blur dari slider blur
valueNoise = get(handles.sliderNoise, 'Value'); % Mengambil nilai noise dari slider noise

% Ambil gambar asli dari GUI
citra = handles.image; % Mengambil gambar asli dari handles.image

% Tambahkan efek brightness
cerah = citra + valueBri; % Menambahkan nilai brightness sesuai nilai slider

% Blur gambar dengan fungsi blur sesuai nilai slider
blurImage = blur(cerah, valueBlur); % Menerapkan efek blur dengan nilai blur dari slider

% Tambahkan kontras pada gambar yang telah diblur
kontras = valueCon * blurImage; % Menambahkan kontras dengan mengalikan nilai kontras slider

% Tambahkan sharpness (ketajaman) dengan nilai sesuai slider
sharpenedImage = imsharpen(kontras, 'Radius', 2, 'Amount', valueSharp); % Menerapkan ketajaman pada gambar

% Tambahkan noise tipe salt & pepper secara manual
noisyImage = sharpenedImage;
[rows, cols, channels] = size(noisyImage);
for c = 1:channels
    for i = 1:rows
        for j = 1:cols
            randValue = rand(); % Nilai acak antara 0 dan 1
            if randValue < valueNoise / 2
                noisyImage(i, j, c) = 0; % Salt (hitam)
            elseif randValue < valueNoise
                noisyImage(i, j, c) = 255; % Pepper (putih)
            end
        end
    end
end

% Menyimpan hasil akhir pada variabel global G
G = noisyImage; % Mengatur gambar akhir sebagai G

axes(handles.axes4); % Memilih axes4 untuk menampilkan gambar hasil
guidata(hObject, handles); % Menyimpan perubahan pada handles
imshow(G, []); % Menampilkan gambar hasil dengan scaling otomatis

% Tampilkan histogram RGB dari gambar akhir di axes7
axes(handles.axes7); % Memilih axes7 untuk menampilkan histogram RGB
histogramRGB(G); % Menampilkan histogram RGB dari gambar hasil

    
% --- Executes during object creation, after setting all properties.
function sliderSharpness_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderBlur_Callback(hObject, eventdata, handles)
    % Callback untuk slider blur

    global G; % Variabel global untuk menyimpan gambar hasil akhir
    citra = handles.image; % Mengambil gambar asli dari GUI
    
    axes(handles.axes4); % Mengatur axes yang aktif menjadi axes4
    
    valueBlur = get(handles.sliderBlur, 'Value'); % Mengambil nilai blur dari slider blur
    valueSharp = get(handles.sliderSharpness, 'Value'); % Mengambil nilai sharpness dari slider sharpness
    set(handles.hslSliderBlur, 'String', valueBlur); % Menampilkan nilai blur pada GUI

    valueNoise = get(handles.sliderNoise, 'Value'); % Mengambil nilai noise dari slider noise
    valueCon = get(handles.sliderContrast, 'Value'); % Mengambil nilai kontras dari slider contrast
    valueBri = get(handles.sliderBrightness, 'Value'); % Mengambil nilai brightness dari slider brightness

    % Tambahkan noise tipe salt & pepper secara manual
    noise = citra;
    [rows, cols, channels] = size(noise);
    for c = 1:channels
        for i = 1:rows
            for j = 1:cols
                randValue = rand(); % Nilai acak antara 0 dan 1
                if randValue < valueNoise / 2
                    noise(i, j, c) = 0; % Salt (hitam)
                elseif randValue < valueNoise
                    noise(i, j, c) = 255; % Pepper (putih)
                end
            end
        end
    end

    % Tambahkan efek kontras menggunakan imadjust
    kontras = valueCon * (noise + valueBri); % Menambahkan efek kontras dengan mengalikan noise dengan nilai kontras

    % Tambahkan efek brightness
    cerah = kontras + valueBri; % Menerapkan nilai brightness pada gambar yang sudah diberi kontras

    % Tambahkan efek sharpness
    sharpenedImage = imsharpen(cerah, 'Radius', 2, 'Amount', valueSharp); % Menambah ketajaman gambar

    % Blur gambar menggunakan fungsi blur yang telah diperbaiki
    blurredImage = blur(sharpenedImage, valueBlur); % Menerapkan efek blur dengan nilai dari slider

    % Simpan hasil akhir ke variabel global G dan tampilkan di GUI
    G = blurredImage; % Menyimpan gambar hasil akhir pada variabel global G
    guidata(hObject, handles); % Menyimpan perubahan data ke objek handle
    imshow(G, []); % Menampilkan gambar dengan scaling otomatis

    % Tampilkan histogram RGB dari gambar akhir di axes7
    axes(handles.axes7); % Mengatur axes yang aktif menjadi axes7
    histogramRGB(G); % Menampilkan histogram RGB dari gambar hasil akhir


% --- Executes during object creation, after setting all properties.
function sliderBlur_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function hslSliderBlur_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function hslSliderBlur_CreateFcn(hObject, eventdata, handles)
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderNoise_Callback(hObject, eventdata, handles)
    % Callback untuk slider noise

    global G; % Variabel global untuk menyimpan gambar akhir
    citra = handles.image; % Mengambil citra asli dari handles
    axes(handles.axes4); % Mengatur axes yang aktif menjadi axes4 untuk menampilkan gambar

    valueSharp = get(handles.sliderSharpness, 'Value'); % Mengambil nilai slider ketajaman
    valueNoise = get(handles.sliderNoise, 'Value'); % Mengambil nilai slider noise
    valueCon = get(handles.sliderContrast, 'Value'); % Mengambil nilai slider kontras
    valueBri = get(handles.sliderBrightness, 'Value'); % Mengambil nilai slider kecerahan

    % Perhitungan manual untuk menambahkan noise "salt & pepper"
    [rows, cols, channels] = size(citra);
    noiseDensity = valueNoise; % Kepadatan noise berdasarkan nilai slider

    % Buat masker untuk noise salt & pepper
    numNoisePixels = round(noiseDensity * rows * cols); % Hitung jumlah piksel yang akan diberi noise
    saltMask = rand(rows, cols) < (noiseDensity / 2); % Masker untuk "salt"
    pepperMask = rand(rows, cols) < (noiseDensity / 2); % Masker untuk "pepper"

    % Terapkan noise pada gambar
    noisyImage = citra;
    for c = 1:channels
        channel = noisyImage(:, :, c);
        channel(saltMask) = 255; % Terapkan "salt" (putih)
        channel(pepperMask) = 0;  % Terapkan "pepper" (hitam)
        noisyImage(:, :, c) = channel;
    end

    % Operasi kontras pada citra dengan nilai kontras dari slider
    kontras = valueCon * (double(noisyImage) + valueBri); % Menerapkan kontras sesuai nilai slider dan menambah kecerahan

    % Tambahkan kecerahan sesuai nilai slider kecerahan
    cerah = kontras + valueBri; % Menambahkan efek kecerahan pada citra yang sudah diberikan kontras

    % Tambahkan ketajaman pada gambar
    sharpen = imsharpen(cerah, 'Radius', 2, 'Amount', valueSharp); % Menajamkan gambar dengan radius 2 dan amount sesuai slider ketajaman

    % Simpan gambar hasil akhir pada variabel global G
    G = sharpen; % Menyimpan gambar akhir ke variabel global G

    % Update nilai slider noise ke teks salt_txt di GUI
    set(handles.hslSliderNoise, 'String', valueNoise); % Menampilkan nilai slider noise di GUI

    % Simpan perubahan pada handles
    guidata(hObject, handles); % Menyimpan perubahan data ke objek handle

    % Tampilkan gambar pada axes yang ditentukan
    imshow(G, []); % Menampilkan gambar akhir dengan scaling otomatis

    % Tentukan ulang axes untuk histogram
    axes(handles.axes7); % Mengatur axes yang aktif menjadi axes7 untuk menampilkan histogram RGB

    % Tampilkan histogram RGB gambar akhir
    histogramRGB(G); % Menampilkan histogram RGB dari gambar hasil akhir

% --- Executes during object creation, after setting all properties.
function sliderNoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderNoise (see GCBO)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function hslSliderNoise_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function hslSliderNoise_CreateFcn(hObject, eventdata, handles)
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popUpMenuED.
function popUpMenuED_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popUpMenuED_CreateFcn(hObject, eventdata, handles)
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in applyEDBtn.
function applyEDBtn_Callback(hObject, eventdata, handles)
% hObject    handle to applyEDBtn (lihat GCBO)
% eventdata  reservasi - akan didefinisikan di versi MATLAB mendatang
% handles    struktur dengan handles dan data pengguna (lihat GUIDATA)

    global G; % Variabel global untuk menyimpan gambar
    axes(handles.axes4); % Pilih axes tempat gambar akan ditampilkan
    x = get(handles.popUpMenuED, 'Value'); % Ambil nilai dari pop-up menu (pilihan metode deteksi tepi)

    % Konversi gambar ke grayscale jika RGB
    if size(G, 3) == 3
        grayscale = double(rgb2gray(G));
    else
        grayscale = double(G);
    end

    % Inisialisasi kernel untuk Sobel dan Prewitt
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = [-1 -2 -1; 0 0 0; 1 2 1];

    prewittX = [-1 0 1; -1 0 1; -1 0 1];
    prewittY = [-1 -1 -1; 0 0 0; 1 1 1];

    switch x
        case 1 % Pilihan 1: deteksi tepi metode Canny (manual belum diimplementasikan)
            G = edge(grayscale, 'canny'); % Tetap menggunakan metode bawaan untuk Canny
        case 2 % Pilihan 2: deteksi tepi metode Sobel
            gradX = conv2(grayscale, sobelX, 'same'); % Konvolusi dengan kernel Sobel X
            gradY = conv2(grayscale, sobelY, 'same'); % Konvolusi dengan kernel Sobel Y
            G = sqrt(gradX.^2 + gradY.^2); % Magnitudo gradien
            G = uint8(G / max(G(:)) * 255); % Normalisasi ke rentang 0-255
        case 3 % Pilihan 3: deteksi tepi metode Prewitt
            gradX = conv2(grayscale, prewittX, 'same'); % Konvolusi dengan kernel Prewitt X
            gradY = conv2(grayscale, prewittY, 'same'); % Konvolusi dengan kernel Prewitt Y
            G = sqrt(gradX.^2 + gradY.^2); % Magnitudo gradien
            G = uint8(G / max(G(:)) * 255); % Normalisasi ke rentang 0-255
    end

    guidata(hObject, handles); % Simpan perubahan pada handles

    % Tampilkan gambar hasil deteksi tepi pada axes yang ditentukan
    imshow(G, []);

    axes(handles.axes7); % Pilih axes untuk histogram
    histogramRGB(G);


% --- Executes on button press in redBTN.
function redBTN_Callback(hObject, eventdata, handles)
% hObject    handle to redBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
axes(handles.axes4);
red = G(:,:,1);

var = zeros(size(G, 1), size(G, 2), 'uint8');
% Create color versions of the individual color channels.
just_red = cat(3, red, var, var);
guidata(hObject,handles);
imshow(just_red);
axes(handles.axes7);
histogram(G(:),256,'FaceColor','r','EdgeColor','r')

% --- Executes on button press in greenBTN.
function greenBTN_Callback(hObject, eventdata, handles)
% hObject    handle to greenBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global G;
axes(handles.axes4);
green = G(:,:,2); % Green channel
% Create an all black channel.
var = zeros(size(G, 1), size(G, 2), 'uint8');
% Create color versions of the individual color channels.
just_green = cat(3, var, green, var);
guidata(hObject,handles);
imshow(just_green);
axes(handles.axes7);
%histogramRGB(G);
histogram(G(:),256,'FaceColor','g','EdgeColor','g')

% --- Executes on button press in blueBTN.
function blueBTN_Callback(hObject, eventdata, handles)
% hObject    handle to blueBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global G;
axes(handles.axes4);
blue = G(:,:,3); % Blue channel
% Create an all black channel.
var = zeros(size(G, 1), size(G, 2), 'uint8');
% Create color versions of the individual color channels.
just_blue = cat(3, var, var, blue);
guidata(hObject,handles);
imshow(just_blue);
axes(handles.axes7);
%histogramRGB(G);
histogram(G(:),256,'FaceColor','b','EdgeColor','b')

