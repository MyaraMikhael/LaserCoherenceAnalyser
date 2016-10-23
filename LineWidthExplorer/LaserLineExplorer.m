classdef LaserLineExplorer < handle
    % The core code for Linewidth vs Time Analysis
    %
    %   by M. Myara, N. Von Bandel and M. Sellahi
    %   for Optics Express 2016 Article "Time-Dependant Laser Linewidth :
    %   beat-note digital acquisition and numerical analysis",
    %   N.Von Bandel, M. Myara, M. Sellahi, T. Souici, R. Dardaillon and P.
    %   Signoret.
    %
    % This Code is under BSD Licence. 
    % Please cite our Optics Express publication if you use
    % this software or part of this software in the frame of 
    % scientific works or publications
    %
    % Please mention the three authors of this software if you reuse this 
    % code or part of this code in another software
    %
    % Input Data Files may contain two variables :
    % - dt : the time step between two samples in seconds
    % -  Y : a column vector containing the sample data
    %
    % This Code is independent from LinewidthExplorerGUI and can be used
    % without any GUI context. However, to reduce computation times, 
    % parameters may be chosen with the help of the GUI.
    
    properties

        dt;
        dataFile;
        timeData;
        LPFilter;
        HPFilter;
        maxPoints;
        LLWEstimation;
        GLWEstimation;
        maxAvgAmount;
        Pbar;
        
    end
    
    methods
        function obj =  LaserLineExplorer()
            obj.dataFile = '';
            obj.timeData=[];
            obj.dt = NaN;
            obj.maxPoints = 2000;
            obj.LPFilter = 1e9;
            obj.HPFilter = 0;
            obj.LLWEstimation = [1e4 1e6 1e8];
            obj.GLWEstimation = [1e4 1e6 1e8];
            obj.maxAvgAmount = 100;
        end
        function [minpower,maxpower] = loadData(obj)
            S = load(obj.dataFile);
            obj.timeData = double(S.Y(:,1)'); 
            obj.dt = S.dt; 
            [minpower,maxpower] = obj.calcMinMaxPower();
        end
        function [minpower,maxpower] = calcMinMaxPower(obj)
            minpower = 8;
            maxpower = floor(log2(length(obj.timeData)));
        end
        function [Y,f]=CalcPowerSpectrum(obj,y,dt)
                Tech = dt;
                Fech = 1/Tech;
                Fmax = Fech/2;
                N = length(y);
                f=linspace(0,Fmax,N/2+1);
                PowerSpectrum = abs(fft(y)).^2;
                Y = PowerSpectrum(1:N/2+1);            
        end
        function [Y,f] = CalcSubSpectrum(obj,y,dt,offset,len)
                y = y(offset+1:offset+len);
                [Y,f] = obj.CalcPowerSpectrum(y,dt);
        end
        function [Y,f] = PrepareSubSpectrumForFitting(obj,y,dt,offset,len)
               LPF = obj.LPFilter;
               HPF = obj.HPFilter;
               maxPointsLength=obj.maxPoints;
               
               [Y,f] = obj.CalcSubSpectrum(y,dt,offset,len);
               %bandwidth reduction
               idxMax = min(find(f<LPF,1,'last'),length(f)-1);
               idxMin = max(find(f>HPF,1,'first'),2);
               f =  f(idxMin:idxMax);
               Y =  Y(idxMin:idxMax);
               % downsampling
               filterOrder = ceil(length(Y)/maxPointsLength);
               Y=conv(Y,ones(1,filterOrder)/filterOrder,'same');
               f = downsample(f,filterOrder);
               Y = downsample(Y,filterOrder);
        end
        function extracted = AnalyseSubSpectrumForFitting(obj,f,A)
            % %%%% first step : try to estimate the noise on data + background noise
            % %% here we try to estimate the background noise average PSD
            % %% We can easily estimate a value stronger than or equal to the noise
            % %% However the lowest possible noise level is empirically chosen
            noiseAnalysis1 = [A(1:floor(length(A)/5))];
            noiseAnalysis2 = [A(floor(4*length(A)/5) : length(A))];
            % the Noise is tested left and right. The noise is the smallest of
            % both.
            if(mean(noiseAnalysis1)>mean(noiseAnalysis2)) noiseAnalysis = noiseAnalysis2;
            else     noiseAnalysis = noiseAnalysis1;
            end
            dataNoise = std(noiseAnalysis)*2;
            avgNoise = mean(noiseAnalysis);
            relNoise = dataNoise/avgNoise;
            if(relNoise >0.95) relNoise = 0.95; end

            backgroundNoiseMax = mean(noiseAnalysis)+dataNoise;
            backgroundNoiseMin = backgroundNoiseMax/10; %% 20 dB lower can be understood as "noise-free" signal
            backgroundNoise = (backgroundNoiseMax+backgroundNoiseMin)/2;


            % %%%% second step : search max position and value. Try it for a big amount of
            % %% values then average all
            % %% find many secondary max values by replacing the actual max by the min
            % %% value of the table
            [minVal,minPos] = min(A);
            nbTestsMax = max(floor(0.02*length(f)),3);
            maxTab = zeros(1,nbTestsMax);
            maxposTab = zeros(1,nbTestsMax);
            condition = true;  %%% tssss ... do-while not available in matlab ...
            i=0;
            while condition 
                [maxVal,maxPos] = max(A);
                maxTab(i+1) = maxVal;
                minimalNoiseOnMax =maxTab(1)/ relNoise;
                maxposTab(i+1) = maxPos;
                A(maxPos) = minVal; 
                maxStd = std(maxTab(1:i+1));
                i = i+1;
                condition = (i < nbTestsMax) && (maxStd < minimalNoiseOnMax);
            end
            % %% then rebuild initial data integrity by restoring all the secondary max
            % %% values found.s
            maxposTab = maxposTab(1:i);
            maxTab = maxTab(1:i); 
            A(maxposTab) = maxTab;


            % %% the we can estimate guess and boundary values for the cftool
            % %% here it is done for max value and center line frequency
            extracted.backgroundNoiseMax = backgroundNoiseMax;
            extracted.backgroundNoiseMin = backgroundNoiseMin;
            extracted.backgroundNoise = backgroundNoise;
            extracted.topFrequency = mean(f(maxposTab));
            extracted.topFreqMin = min(f(maxposTab));
            extracted.topFreqMax = max(f(maxposTab));
            extracted.maxVal = mean(maxTab);
            extracted.maxValMin = min(maxTab)*relNoise;
            extracted.maxValMax = max(maxTab)/relNoise;
            extracted.maxTab = maxTab;
            extracted.fMaxTab = f(maxposTab);
        end
        function plotGuessForFit(obj,handle,e,f)
            axes(handle);
            semilogy(e.fMaxTab,e.maxTab,'+r');
            line([e.topFreqMin e.topFreqMin], [e.maxValMin e.maxValMax],'Color','g');
            line([e.topFreqMin e.topFreqMax], [e.maxValMin e.maxValMin],'Color','g');
            line([e.topFreqMax e.topFreqMax], [e.maxValMin e.maxValMax],'Color','g');
            line([e.topFreqMin e.topFreqMax], [e.maxValMax e.maxValMax],'Color','g');
            line([f(1) f(length(f))], [e.backgroundNoise e.backgroundNoise],'Color','g');
            line([f(1) f(length(f))], [e.backgroundNoiseMax e.backgroundNoiseMax],'Color','g');
            line([f(1) f(length(f))], [e.backgroundNoiseMin e.backgroundNoiseMin],'Color','g');
            semilogy(e.topFrequency,e.maxVal,'*g');
        end
        function cf_ = fitSubSpectrum(obj,f,A,e)
            LorLW = obj.LLWEstimation;
            GaussLW = obj.GLWEstimation;
            fo_ = fitoptions('method','NonlinearLeastSquares','Robust','Off');
            fo_.MaxIter = 1000;
            fo_.MaxFunEvals = 2000;

            st_ = [e.maxVal    e.topFrequency LorLW(2) GaussLW(2) ]; 
            lo_ = [e.maxValMin e.topFreqMin   LorLW(1) GaussLW(1) ]; 
            up_ = [e.maxValMax e.topFreqMax   LorLW(3) GaussLW(3) ]; 

            set(fo_,'Startpoint',st_);     set(fo_,'Lower',lo_);    set(fo_,'Upper',up_); 
            str = sprintf(' maxVal*apparatus_function( topFrequency,LorLW,GaussLW, f )  ');   
            ft_ = fittype(str,'dependent',{'y'},'independent',{'f'},...
            'coefficients',{'maxVal', 'topFrequency',  'LorLW','GaussLW'});

            % %%start cftool now !
            [cf_,gof] = fit(f',A',ft_,fo_);

         end
        function plotFit(obj,cf_,handle)
            axes(handle);
            plot(cf_);
            hold off;
        end
        function [n,t]=getTimeByPower(obj,k)
            n = 2^k;
            t=n*obj.dt;
        end
        function n = getSubSpectraAmountByPower(obj,k)
            nSample = 2^k;
            n = floor(length(obj.timeData)/nSample);
        end
        function [n,t]=getSubSpectrumOffset(obj,k,numSpectrum)
             nSample = 2^k;
             n = numSpectrum*nSample;
            t=n*obj.dt;
        end
 
        function width = salehFwhm(obj,x,y,removeBack)
            if removeBack==1
                leftNoise = mean(y(1:10));
                rightNoise = mean(y(end-10:end));
                y = y - (leftNoise+rightNoise)/2;
            end
            y(y<=0)=0;
            width = (trapz(x,y).^2)/trapz(x,y.^2);
        end
        
        
        function setProgressBarHandle(obj,handle)
            obj.Pbar = handle;
        end
        
        function oneLinewidthVsTimeStepMore(obj,step,stepMax)
            uiProgressBar(obj.Pbar,step/stepMax);
        end
        
        function [data]=calcLinewidthVsTime(obj,minP,maxP,maxAvgAmount,fitLorAndGauss)
            minP = floor(minP); %% a bug in the GUI : minP provided should not be double but int
            maxP = floor(maxP);
             data.t=[];
             data.fwhm_saleh_avg=[];
             data.fwhm_saleh_stdev=[];
             data.fwhm_lor_avg=[];
             data.fwhm_lor_stdev=[];
             data.fwhm_gauss_avg=[];
             data.fwhm_gauss_stdev=[];
             data.avg_amount = [];
            
             stepMax = maxP-minP+1;
             obj.oneLinewidthVsTimeStepMore(0,stepMax);
             drawnow();
             
            for it = 1:stepMax
                k = it-1+minP;
                Nspls = obj.getSubSpectraAmountByPower(k);
                Nspls = min(Nspls,maxAvgAmount);
                fwhm_saleh=[];
                fwhm_lor=[];
                fwhm_gauss=[];
                tic
                for numSpectrum=1:Nspls
                    
                    offset=getSubSpectrumOffset(obj,k,numSpectrum-1);
                    [Y,f] = obj.PrepareSubSpectrumForFitting(obj.timeData,obj.dt,offset,2^k);
                    fwhm_saleh(end+1) = obj.salehFwhm(f,Y,1);
                    
                    if fitLorAndGauss == 1
                        extracted = AnalyseSubSpectrumForFitting(obj,f,Y);
                        fitPade = fitSubSpectrum(obj,f,Y,extracted);
                        fwhm_lor(end+1) =fitPade.LorLW;
                        fwhm_gauss(end+1) = fitPade.GaussLW;
                    end
                    if(toc> 0.2)
                        obj.oneLinewidthVsTimeStepMore((it-1+(numSpectrum-1)/Nspls),stepMax);
                        drawnow();
                        tic
                    end
                end
                data.t(end+1)=2^k*obj.dt;
                data.avg_amount(end+1)=length(fwhm_saleh);
                data.fwhm_saleh_avg(end+1)=mean(fwhm_saleh);
                data.fwhm_saleh_stdev(end+1)=std(fwhm_saleh);
                if fitLorAndGauss == 1
                    data.fwhm_lor_avg(end+1)=mean(fwhm_lor);
                    data.fwhm_lor_stdev(end+1)=std(fwhm_lor);
                    data.fwhm_gauss_avg(end+1)=mean(fwhm_gauss);
                    data.fwhm_gauss_stdev(end+1)=std(fwhm_gauss);
                end
                obj.oneLinewidthVsTimeStepMore(it,stepMax);
                drawnow();
             end
        end
    end
    
end

