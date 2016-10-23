function p=pade2(tau_L,tau_G,nu) 

p = arrayfun(@(a,b,c) pade1(a,b,c),tau_L*ones(size(nu)),tau_G*ones(size(nu)),nu);
 