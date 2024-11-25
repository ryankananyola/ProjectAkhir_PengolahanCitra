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
    
    % Tambahkan noise 'salt & pepper' pada gambar yang sudah diberi kecerahan
    noise = imnoise(brightImage, 'salt & pepper', valueNoise);

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
    
    % Tambahkan noise 'salt & pepper' berdasarkan nilai dari slider noise
    noise = imnoise(citra, 'salt & pepper', valueNoise);
    
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
    
    % Mengubah gambar menjadi grayscale menggunakan fungsi rgb2gray
    G = rgb2gray(G);
    
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
G = imcomplement(G); % Membuat citra negatif dari G menggunakan fungsi imcomplement
guidata(hObject,handles); % Menyimpan perubahan data ke objek handle
imshow(G,[]); % Menampilkan citra negatif pada axes yang telah diatur
axes(handles.axes7); % Mengatur axes yang aktif menjadi axes7
histogramRGB(G); % Menampilkan histogram RGB dari citra negatif



% --- Executes on button press in binary.
function binary_Callback(hObject, eventdata, handles)
% Callback untuk tombol binary

global G; % Mendeklarasikan variabel global G yang akan digunakan dalam fungsi
axes(handles.axes4); % Mengatur axes yang aktif menjadi axes4
G = im2bw(G); % Mengubah citra menjadi biner (hitam-putih) menggunakan fungsi im2bw
guidata(hObject,handles); % Menyimpan perubahan data ke objek handle
imshow(G,[]); % Menampilkan citra biner pada axes4 dengan skala array untuk efek langsung
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

% Tambahkan noise dengan tipe salt & pepper
noisyImage = imnoise(sharpenedImage, 'salt & pepper', valueNoise); % Menambahkan noise tipe salt & pepper

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

    % Tambahkan noise ke gambar
    noise = imnoise(citra, 'salt & pepper', valueNoise); % Menambahkan noise tipe salt & pepper pada gambar

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

    % Tambahkan noise jenis salt & pepper sesuai nilai slider noise
    noise = imnoise(citra, 'salt & pepper', valueNoise); % Menambahkan noise salt & pepper pada citra

    % Operasi kontras pada citra dengan nilai kontras dari slider
    kontras = valueCon * (noise + valueBri); % Menerapkan kontras sesuai nilai slider dan menambah kecerahan

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

switch x
    case 1 % Pilihan 1: deteksi tepi metode Canny
        imagedouble = double(rgb2gray(G)); % Konversi gambar menjadi grayscale, lalu menjadi tipe double
        G = edge(imagedouble, 'canny'); % Terapkan deteksi tepi menggunakan metode Canny
    case 2 % Pilihan 2: deteksi tepi metode Sobel
        imagedouble = double(rgb2gray(G)); % Konversi gambar ke grayscale dan tipe double
        G = edge(imagedouble, 'sobel'); % Terapkan deteksi tepi menggunakan metode Sobel
    case 3 % Pilihan 3: deteksi tepi metode Prewitt
        imagedouble = double(rgb2gray(G)); % Konversi gambar ke grayscale dan tipe double
        G = edge(imagedouble, 'prewitt'); % Terapkan deteksi tepi menggunakan metode Prewitt
end

guidata(hObject, handles); % Simpan perubahan pada handles
imshow(G, []); % Tampilkan gambar hasil deteksi tepi pada axes yang ditentukan
axes(handles.axes7); % Pilih axes untuk histogram
histogramRGB(G); % Tampilkan histogram RGB gambar


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


% --- Executes on button press in camBTN.
function camBTN_Callback(hObject, eventdata, handles)
% hObject    handle to camBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid; % Variabel global untuk objek video
    vid = videoinput('winvideo', 1); % Inisialisasi kamera (pastikan tipe adaptor sesuai)
    set(vid, 'ReturnedColorSpace', 'rgb'); % Set warna ke RGB
    vid.FramesPerTrigger = 1; % Set jumlah frame per trigger
    start(vid); % Mulai kamera
    
    while ishandle(hObject) % Loop untuk real-time feed
        % Ambil gambar dari kamera
        frame = getsnapshot(vid); 
        
        % Terapkan fitur yang dipilih
        feature = getSelectedFeature(handles); % Dapatkan fitur yang dipilih
        
        switch feature
            case 'Grayscale'
                frameProcessed = rgb2gray(frame);
            case 'Negatif'
                frameProcessed = imcomplement(frame);
            case 'Binary'
                frameProcessed = imbinarize(rgb2gray(frame), 0.5);
            case 'Red'
                frameProcessed = frame(:,:,1); % Hanya kanal merah
            case 'Green'
                frameProcessed = frame(:,:,2); % Hanya kanal hijau
            case 'Blue'
                frameProcessed = frame(:,:,3); % Hanya kanal biru
            % Tambahkan fitur lain sesuai kebutuhan
            otherwise
                frameProcessed = frame; % Default tanpa efek
        end
        
        % Tampilkan gambar asli di axes3
        axes(handles.axes3);
        imshow(frame);
        
        % Tampilkan gambar dengan fitur di axes4
        axes(handles.axes4);
        imshow(frameProcessed);
        
        % Perbarui GUI
        drawnow;
    end
    
    % Fungsi untuk mendapatkan fitur yang dipilih
    function feature = getSelectedFeature(handles)
        % Dapatkan fitur yang dipilih berdasarkan tombol atau dropdown yang aktif
        if get(handles.radioButtonGrayscale, 'Value')
            feature = 'Grayscale';
        elseif get(handles.radioButtonNegatif, 'Value')
            feature = 'Negatif';
        elseif get(handles.radioButtonBinary, 'Value')
            feature = 'Binary';
        elseif get(handles.radioButtonRed, 'Value')
            feature = 'Red';
        elseif get(handles.radioButtonGreen, 'Value')
            feature = 'Green';
        elseif get(handles.radioButtonBlue, 'Value')
            feature = 'Blue';
        else
            feature = 'Original';
        end
    