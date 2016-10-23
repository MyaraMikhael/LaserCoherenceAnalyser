
function  [outWindow,outCalibrationFactor] = calcFFTWindow( NFFT,inWindow)
t=0:NFFT-1;
    switch(inWindow)    
        case 'Hanning'
            outWindow = 1/2 - (cos(2*pi*t/(NFFT)))/2; 
        case 'Nuttal4b'
             a0 = 0.355768; a1 = -0.487396; a2 = 0.144232; a3 = -0.012604;
             outWindow = a0 + a1*cos(2*pi*t/NFFT)+ a2*cos(4*pi*t/NFFT)+a3*cos(6*pi*t/NFFT); 
        case 'Blackmann-Harris'
             a0 = 0.35875;   a1 = 0.48829;    a2 = 0.14128;    a3 = 0.01168;
            outWindow = a0 - a1*cos(2*pi*t/(NFFT-1)) + a2*cos(4*pi*t/(NFFT-1)) -a3*cos(6*pi*t/(NFFT-1));%Blackman Harris
        otherwise   %rectangular case
           outWindow = ones(1,NFFT); 
    end
      outCalibrationFactor = sum(outWindow.*outWindow); %see Heinzel2002 et al. pages 16 and 12
   
    % guidata(handles.fftScopeGUI_Dialog,handles);
    
    

end

