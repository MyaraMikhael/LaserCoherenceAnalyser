function p = pade1(tau_L,tau_G,nu)

pade=[-1.2150,1.2359,-0.3085,0.0210;-1.3509,0.3786,0.5906,-1.1858;-1.2150,-1.2359,-0.3085,-0.0210;-1.3509,-0.3786,0.5906,1.1858] ;

% definition des différents paramètres 
% ------------------------------------
% tau_G=3;
% tau_L=30;
% aa=tau_G*sqrt(2);
% sigma=1./(2.*tau_G.*sqrt(pi)) ;
% z=tau_G./(tau_L.*sqrt(2.*pi)) ; % z=1./(2.*pi.*tau_L.*sigma.*sqrt(2))
% ------------------------------------
% en bon matlab ci-dessous

%i = 1:4 ;p=sum(aa*((z-pade(i,1)).*pade(i,3) + (nu./(sigma.*sqrt(2))-pade(i,2)).*pade(i,4))./((z-pade(i,1)).^2 + (nu./(sigma.*sqrt(2))-pade(i,2)).^2)) ;

i = 1:4 ;p=sum((tau_G*sqrt(2))*(((tau_G./(tau_L.*sqrt(2.*pi)))-pade(i,1)).*pade(i,3) + (nu./((1./(2.*tau_G.*sqrt(pi))).*sqrt(2))-pade(i,2)).*pade(i,4))./(((tau_G./(tau_L.*sqrt(2.*pi)))-pade(i,1)).^2 + (nu./((1./(2.*tau_G.*sqrt(pi))).*sqrt(2))-pade(i,2)).^2)) ;


 