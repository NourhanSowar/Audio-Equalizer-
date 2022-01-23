
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ----------------------Graphical User Interface---------------------------------
%First, Reading file name input
prompt = {'\fontsize{13} File name :'}; %Subtitles
dlgtitle = 'Equilizer'; 
size = [1 50]; 
definput = {'FilePath',}; 
opts.Interpreter = 'tex'; 
%creates a modal dialog box containing one or more text edit fields and
%returns the values entered by the user
answer = inputdlg(prompt,dlgtitle,size,definput,opts);% opts:specifies that the dialog box is resizeable 
file_name =  answer{1}; 
[y , fs] = audioread(file_name);

%Second, Gain inputs
prompt = {'Enter 1st gain in dB:','Enter 2nt gain in dB:','Enter 3rd gain in dB:','Enter 4th gain in dB:','Enter 5th gain in dB:','Enter 6th gain in dB:','Enter 7th gain in dB:','Enter 8th gain in dB:','Enter 9th gain in dB:'}; %Subtitles 
size = [1 50]; 
definput = {'0','0','0','0','0','0','0','0','0'}; 
opts.Interpreter = 'tex'; 
answer = inputdlg(prompt,dlgtitle,size,definput);
k_i1 =  str2num(answer{1}); 
k_i2 =  str2num(answer{2});
k_i3 =  str2num(answer{3});
k_i4 =  str2num(answer{4});
k_i5 =  str2num(answer{5});
k_i6 =  str2num(answer{6});
k_i7 =  str2num(answer{7});
k_i8 =  str2num(answer{8});
k_i9 =  str2num(answer{9});

%Third, Filter Type
prompt = {'Enter filters type(F for FIR / I for IIR):','Enter output sample rate:'}; 
size = [1 50]; 
definput = {'F','44100'}; 
opts.Interpreter = 'tex'; 
answer = inputdlg(prompt,dlgtitle,size,definput);
filter_type =  answer{1};
Output_sample_rate =  str2num(answer{2}); %44100

%---------------------------------------------------------------------------------
%----------------------Convert Gain from DB-------------------------
k_i1 = 10 ^ (k_i1/20);
k_i2 = 10 ^ (k_i2/20);
k_i3 = 10 ^ (k_i3/20);
k_i4 = 10 ^ (k_i4/20);
k_i5 = 10 ^ (k_i5/20);
k_i6 = 10 ^ (k_i6/20);
k_i7 = 10 ^ (k_i7/20);
k_i8 = 10 ^ (k_i8/20);
k_i9 = 10 ^ (k_i9/20);
%---------------------------------FIR filters--------------------
if filter_type == 'F'
    
    N = 50; % Order
    fn = fs;  % freq sample of input sound
    
    %first req which is developing freq band filters
    omega0 = 1/fn;
    omega1 = 170/fn;
    omega2 = 310/fn;
    omega3 = 600/fn;
    omega4 = 1000/fn;
    omega5 = 3000/fn;
    omega6 = 6000/fn;
    omega7 = 12000/fn;
    omega8 = 14000/fn;
    omega9 = 16000/fn;
    
    %uses a Hamming window to design an nth-order lowpass, bandpass, or multiband FIR filter with linear phase.
    %The filter type depends on the number of elements of Wn.
    h1  = fir1(N ,omega1,'low');
    h2  = fir1(N ,[omega1 omega2],'bandpass');
    h3  = fir1(N ,[omega2 omega3],'bandpass');
    h4  = fir1(N ,[omega3 omega4],'bandpass');
    h5  = fir1(N ,[omega4 omega5],'bandpass');
    h6  = fir1(N ,[omega5 omega6],'bandpass');
    h7  = fir1(N ,[omega6 omega7],'bandpass');
    h8  = fir1(N ,[omega7 omega8],'bandpass');
    h9  = fir1(N ,[omega8 omega9],'bandpass');

    
    %%%%Determine the frequency response of filters
    % returns the n-point frequency response vector h and the corresponding angular frequency vector w
    %for the digital filter with transfer function coefficients stored in b and a.
    %  returns 512 points from 0 to pi. uses 512 points around the whole unit circle.
    [H1,w1]=freqz(h1,1,512);  
    [H2,w2]=freqz(h2,1,512); 
    [H3,w3]=freqz(h3,1,512); 
    [H4,w4]=freqz(h4,1,512);
    [H5,w5]=freqz(h5,1,512); 
    [H6,w6]=freqz(h6,1,512);  
    [H7,w7]=freqz(h7,1,512);  
    [H8,w8]=freqz(h8,1,512);  
    [H9,w9]=freqz(h9,1,512);  

    %returns the phase angle in the interval [-?,?] for each element.
    phase1=angle(H1)*180/pi;
    phase2=angle(H2)*180/pi;
    phase3=angle(H3)*180/pi;
    phase4=angle(H4)*180/pi;
    phase5=angle(H5)*180/pi;
    phase6=angle(H6)*180/pi;
    phase7=angle(H7)*180/pi;
    phase8=angle(H8)*180/pi;
    phase9=angle(H9)*180/pi;

    % Get zeros, poles,gain to plot them
    [z1,p1,k1]=tf2zpk(h1,1);
    [z2,p2,k2]=tf2zpk(h2,1);
    [z3,p3,k3]=tf2zpk(h3,1);
    [z4,p4,k4]=tf2zpk(h4,1);
    [z5,p5,k5]=tf2zpk(h5,1);
    [z6,p6,k6]=tf2zpk(h6,1);
    [z7,p7,k7]=tf2zpk(h7,1);
    [z8,p8,k8]=tf2zpk(h8,1);
    [z9,p9,k9]=tf2zpk(h9,1);
    
    % get system using tf function by enter numorator and demonrator 
    sys1= tf(h1,ones(1,51))
    sys2= tf(h2,ones(1,51));
    sys3= tf(h3,ones(1,51));
    sys4= tf(h4,ones(1,51));
    sys5= tf(h5,ones(1,51));
    sys6= tf(h6,ones(1,51));
    sys7= tf(h7,ones(1,51));
    sys8= tf(h8,ones(1,51));
    sys9= tf(h9,ones(1,51));
    
else
    %---------------------------------IIR filters--------------------
   N = 50; %Order of the used IIR Filters
    fn = fs;
    omega0 = 1/fn;
    omega1 = 170/fn;
    omega2 = 310/fn;
    omega3 = 600/fn;
    omega4 = 1000/fn;
    omega5 = 3000/fn;
    omega6 = 6000/fn;
    omega7 = 12000/fn;
    omega8 = 14000/fn;
    omega9 = 16000/fn;
    % IIR filter
    %return coff
   [h1,den1]=butter(N, omega1); 
   [h2,den2]=butter(N,[omega1 omega2]);  
   [h3,den3]=butter(N,[omega2 omega3]); 
   [h4,den4]=butter(N,[omega3 omega4]);
   [h5,den5]=butter(N ,[omega4 omega5]);
   [h6,den6]=butter(N,[omega5 omega6]);
   [h7,den7]=butter(N,[omega6 omega7]);
   [h8,den8]=butter(N,[omega7 omega8]); 
   [h9,den9]=butter(N,[omega8 omega9]); 
   
   
   
   [H1,w1]=freqz(h1,den1); 
   [H2,w2]=freqz(h2,den2); 
   [H3,w3]=freqz(h3,den3); 
   [H4,w4]=freqz(h4,den4); 
   [H5,w5]=freqz(h5,den5); 
   [H6,w6]=freqz(h6,den6); 
   [H7,w7]=freqz(h7,den7); 
   [H8,w8]=freqz(h8,den8); 
   [H9,w9]=freqz(h9,den9); 
   
   mag1=abs(H1);  
   mag2=abs(H2); 
   mag3=abs(H3); 
   mag4=abs(H4); 
   mag5=abs(H5); 
   mag6=abs(H6); 
   mag7=abs(H7); 
   mag8=abs(H8); 
   mag9=abs(H9); 
   
   
   phase1=angle(H1)*180/pi; 
   phase2=angle(H2)*180/pi;  
   phase3=angle(H3)*180/pi;  
   phase4=angle(H4)*180/pi;  
   phase5=angle(H5)*180/pi;  
   phase6=angle(H6)*180/pi;  
   phase7=angle(H7)*180/pi;  
   phase8=angle(H8)*180/pi;  
   phase9=angle(H9)*180/pi;
   
   [z1,p1,k1]=butter(N, omega1);  
   [z2,p2,k2]=butter(N,[omega1 omega2]);  
   [z3,p3,k3]=butter(N,[omega2 omega3]);
   [z4,p4,k4]=butter(N,[omega3 omega4]);
   [z5,p5,k5]=butter(N ,[omega4 omega5]);
   [z6,p6,k6]=butter(N,[omega5 omega6]);
   [z7,p7,k7]=butter(N,[omega6 omega7]);
   [z8,p8,k8]=butter(N,[omega7 omega8]); 
   [z9,p9,k9]=butter(N,[omega8 omega9]); 
   
   
   sys1=tf(h1,den1);
   sys2=tf(h2,den2); 
   sys3=tf(h3,den3); 
   sys4=tf(h4,den4); 
   sys5=tf(h5,den5);
   sys6=tf(h6,den6); 
   sys7=tf(h7,den7); 
   sys8=tf(h8,den8);
   sys9=tf(h9,den9); 
   
end

 %----------------------------------------------------------------------
    %Plotting zeros, polse
    figure('Name','zeros &polse of FIR');    
     
    subplot(5,2,1);zplane(z1,p1);grid on;  
    subplot(5,2,2);zplane(z2,p2);grid on;
    subplot(5,2,3);zplane(z3,p3);grid on;
    subplot(5,2,4);zplane(z4,p4);grid on;
    subplot(5,2,5);zplane(z5,p5);grid on; 
    subplot(5,2,6);zplane(z6,p6);grid on;
    subplot(5,2,7);zplane(z7,p7);grid on;  
    subplot(5,2,8);zplane(z8,p8);grid on;   
    subplot(5,2,9);zplane(z9,p9);grid on;
    
    
    %Plotting Magnitude and Phase of filters
    figure('Name','Magnitude and Phase of FIR FILTERS');    
    subplot(9,2,1);plot(w1/pi,abs(H1),'linewidth',1.25);grid on;title('Filter 1 Magnitude');
    subplot(9,2,2);plot(w1/pi,phase1,'linewidth',1.25);grid on;title('Filter 1 Phase');    
    subplot(9,2,3);plot(w2/pi,abs(H2),'linewidth',1.25);grid on;title('Filter 2 Magnitude');
    subplot(9,2,4);plot(w2/pi,phase2,'linewidth',1.25);grid on;title('Filter 2 Phase');
    subplot(9,2,5);plot(w3/pi,abs(H3),'linewidth',1.25);grid on;title('Filter 3 Magnitude');
    subplot(9,2,6);plot(w3/pi,phase3,'linewidth',1.25);grid on;title('Filter 3 Phase');
    subplot(9,2,7);plot(w4/pi,abs(H4),'linewidth',1.25);grid on;title('Filter 4 Magnitude');
    subplot(9,2,8);plot(w4/pi,phase4,'linewidth',1.25);grid on;title('Filter 4 Phase'); 
    subplot(9,2,9);plot(w5/pi,abs(H5),'linewidth',1.25);grid on;title('Filter 5 Magnitude');
    subplot(9,2,10);plot(w5/pi,phase5,'linewidth',1.25);grid on;title('Filter 5 Phase');
    subplot(9,2,11);plot(w6/pi,abs(H6),'linewidth',1.25);grid on;title('Filter 6 Magnitude');
    subplot(9,2,12);plot(w6/pi,phase6,'linewidth',1.25);grid on;title('Filter 6 Phase');
    subplot(9,2,13);plot(w7/pi,abs(H7),'linewidth',1.25);grid on;title('Filter 7 Magnitude');
    subplot(9,2,14);plot(w7/pi,phase7,'linewidth',1.25);grid on;title('Filter 7 Phase');
    subplot(9,2,15);plot(w8/pi,abs(H8),'linewidth',1.25);grid on;title('Filter 8 Magnitude');
    subplot(9,2,16);plot(w8/pi,phase8,'linewidth',1.25);grid on;title('Filter 8 Phase');
    subplot(9,2,17);plot(w9/pi,abs(H9),'linewidth',1.25);grid on;title('Filter 9 Magnitude');
    subplot(9,2,18);plot(w9/pi,phase9,'linewidth',1.25);grid on;title('Filter 9 Phase'); 
    
    
    %Plotting Impulse Responce and step responce of FIR Fitlers
 
    figure('Name','Impulse Responceof FIR FILTERS');    
     
    subplot(5,2,1);impulse(sys1);grid on;  
    subplot(5,2,2);impulse(sys2);grid on;
    subplot(5,2,3);impulse(sys3);grid on;
    subplot(5,2,4);impulse(sys4);grid on;
    subplot(5,2,5);impulse(sys5);grid on; 
    subplot(5,2,6);impulse(sys6);grid on;
    subplot(5,2,7);impulse(sys7);grid on;  
    subplot(5,2,8);impulse(sys8);grid on;   
    subplot(5,2,9);impulse(sys9);grid on;
    
    figure('Name','Step Responce of FIR FILTERS'); 
    subplot(5,2,1);step(sys1);grid on;
    subplot(5,2,2);step(sys2);grid on; 
    subplot(5,2,3);step(sys3);grid on; 
    subplot(5,2,4);step(sys4);grid on;
    subplot(5,2,5);step(sys5);grid on; 
    subplot(5,2,6);step(sys6);grid on; 
    subplot(5,2,7);step(sys7);grid on; 
    subplot(5,2,8);step(sys8);grid on; 
    subplot(5,2,9);step(sys9);grid on; 
    
    %-------------------------------------------------------------------------------
    %%%%%% get output signals after filter 
    f_h1_out = filter(h1,1,y);
    f_h2_out = filter(h2,1,y);
    f_h3_out = filter(h3,1,y);
    f_h4_out = filter(h4,1,y);
    f_h5_out = filter(h5,1,y);
    f_h6_out = filter(h6,1,y);
    f_h7_out = filter(h7,1,y);
    f_h8_out = filter(h8,1,y);
    f_h9_out = filter(h9,1,y);
    
    
    figure('Name','plot outputfiltered sginals after filter in time domain');    
     
    subplot(5,2,1);plot(f_h1_out);grid on;  
    subplot(5,2,2);plot(f_h2_out);grid on;
    subplot(5,2,3);plot(f_h3_out);grid on;
    subplot(5,2,4);plot(f_h4_out);grid on;
    subplot(5,2,5);plot(f_h5_out);grid on; 
    subplot(5,2,6);plot(f_h6_out);grid on;
    subplot(5,2,7);plot(f_h7_out);grid on;  
    subplot(5,2,8);plot(f_h8_out);grid on;   
    subplot(5,2,9);plot(f_h9_out);grid on;
    
    %%%%%% output filtetred  signals after filter and amplifiaction
       
    % Apply output filters (h1:h9) to the input sound-----
    f_h1 = k_i1*filter(h1,1,y);
    f_h2 = k_i2*filter(h2,1,y);
    f_h3 = k_i3*filter(h3,1,y);
    f_h4 = k_i4*filter(h4,1,y);
    f_h5 = k_i5*filter(h5,1,y);
    f_h6 = k_i6*filter(h6,1,y);
    f_h7 = k_i7*filter(h7,1,y);
    f_h8 = k_i8*filter(h8,1,y);
    f_h9 = k_i9*filter(h9,1,y);
    
    % plotting output sginals after amplifiaction in time domain
    
     figure('Name','plot output sginals after amplifiaction in time domain');    
     
    subplot(5,2,1);plot(f_h1);grid on;  
    subplot(5,2,2);plot(f_h2);grid on;
    subplot(5,2,3);plot(f_h3);grid on;
    subplot(5,2,4);plot(f_h4);grid on;
    subplot(5,2,5);plot(f_h5);grid on; 
    subplot(5,2,6);plot(f_h6);grid on;
    subplot(5,2,7);plot(f_h7);grid on;  
    subplot(5,2,8);plot(f_h8);grid on;   
    subplot(5,2,9);plot(f_h9);grid on;
    

   
   %%%%%%%%%freq domain of output sginals after amplifiaction
   f_h1_freq= abs (fftshift(fft(f_h1)));
   f_h2_freq= abs (fftshift(fft(f_h2)));
   f_h3_freq= abs (fftshift(fft(f_h3)));
   f_h4_freq= abs (fftshift(fft(f_h4)));
   f_h5_freq= abs (fftshift(fft(f_h5)));
   f_h6_freq= abs (fftshift(fft(f_h6)));
   f_h7_freq= abs (fftshift(fft(f_h7)));
   f_h8_freq= abs (fftshift(fft(f_h8)));
   f_h9_freq= abs (fftshift(fft(f_h9)));
   
   F1= linspace(-fs/2,fs/2,length(f_h1));
   F2= linspace(-fs/2,fs/2,length(f_h2));
   F3= linspace(-fs/2,fs/2,length(f_h3));
   F4= linspace(-fs/2,fs/2,length(f_h4));
   F5= linspace(-fs/2,fs/2,length(f_h5));
   F6= linspace(-fs/2,fs/2,length(f_h6));
   F7= linspace(-fs/2,fs/2,length(f_h7));
   F8= linspace(-fs/2,fs/2,length(f_h8));
   F9= linspace(-fs/2,fs/2,length(f_h9));

   
    % plotting output sginals after amplifiaction in time domain
    
    figure('Name','plot output sginals after amplifiaction in freq domain');    
     
    subplot(5,2,1);plot(F1,f_h1_freq);grid on;  
    subplot(5,2,2);plot(F2,f_h2_freq);grid on;
    subplot(5,2,3);plot(F3,f_h3_freq);grid on;
    subplot(5,2,4);plot(F4,f_h4_freq);grid on;
    subplot(5,2,5);plot(F5,f_h5_freq);grid on; 
    subplot(5,2,6);plot(F6,f_h6_freq);grid on;
    subplot(5,2,7);plot(F7,f_h7_freq);grid on;  
    subplot(5,2,8);plot(F8,f_h8_freq);grid on;   
    subplot(5,2,9);plot(F9,f_h9_freq);grid on;
    
    %--------------------------------------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%req 6
    xt= f_h1+f_h2+f_h3+f_h4+f_h5+f_h6+f_h7+f_h8+f_h9;
    % Draw and compare the composite signal with the original signal in time domain 
    figure('Name','Comparing the Composite with the Original in Time Domain');
    subplot(2,1,1);stem(xt);grid on;title('Composite Signal in Time Domain');ylabel('Amplitude');xlabel('Time');
    subplot(2,1,2);stem(y);grid on;title('Original Signal in Time Domain');ylabel('Amplitude');xlabel('Time'); 
    
    %%%freq domain
    xt_freq= abs (fftshift(fft(xt)));
    y_freq= abs (fftshift(fft(y)));
    
    Ft= linspace(-fs/2,fs/2,length(xt_freq));
    Fy= linspace(-fs/2,fs/2,length(y_freq));

     % Draw and compare the composite signal with the original signal in freq domain 
    figure('Name','Comparing the Composite with the Original in freq Domain');
    subplot(2,1,1); stem(Ft,xt_freq);grid on;title('Composite Signal in freq Domain');ylabel('Amplitude');xlabel('freq');
    subplot(2,1,2);stem(Fy,y_freq);grid on;title('Original Signal in freq Domain');ylabel('Amplitude');xlabel('freq'); 
    
    %-------------------------------------------------------------------------------------
   %%%%%%%%%%%%%%%%%%%%%%%%5play sound
%   sound(y, fs);

   %sound(xt, Output_sample_rate);
   load handel.mat
   filename = 'C:\Users\TARGET\OneDrive\Desktop\Audio-Equalizer\Audio Equalizer\handel.wav';
   audiowrite(filename,xt,Output_sample_rate);