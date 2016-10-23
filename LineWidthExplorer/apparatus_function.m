function [ out ] = apparatus_function( fcenter,LorW,GaussW,f )
out = pade2(1./LorW/pi,sqrt(2*log(2)/pi)./GaussW,f-fcenter);
out = out/max(out);
end

