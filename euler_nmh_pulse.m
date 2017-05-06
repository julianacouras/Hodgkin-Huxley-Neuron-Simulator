function [n m h JL JK JNa gKv gNav V] = euler_nmh_pulse(t,JE)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%definir as constantes
Ve = -65; %mV voltagem de membrana em repouso
cm = 0.010; %capacidade por unidade de área (uF/mm^2)
gL = 0.003; %mS/mm^2
EL = -54.387; %mV
gK = 0.36; %mS/mm^2
EK = -77; %mV
gNa = 1.2; %mS/mm^2
ENa = 50; %mV


An0 = alfa_n(Ve);
Am0 = alfa_m(Ve);
Ah0 = alfa_h(Ve);

Bn0 = beta_n(Ve);
Bm0 = beta_m(Ve);
Bh0 = beta_h(Ve);

dt = t(2);

n = zeros(1,length(t));
m = zeros(1,length(t));
h = zeros(1,length(t));

V = zeros(1,length(t));

JL = zeros(1,length(t));
JK = zeros(1,length(t));
JNa = zeros(1,length(t));

n(1) = HHv(An0,Bn0);
m(1) = HHv(Am0,Bm0);
h(1) = HHv(Ah0,Bh0);

JL(1) = gL*(Ve-EL);
JK(1) = gK*(Ve-EK)*n(1)^4;
JNa(1) = gNa*(Ve-ENa)*h(1)*m(1)^3;

% V(1) = Ve + (dt/cm) *(- JL(1) - JK(1) - JNa(1) + JE(1));
V(1) = Ve;
for i = 1:(length(t)-1)
    n(i+1) = n(i) + dt*(alfa_n(V(i))*(1-n(i)) - (beta_n(V(i))*n(i)));
    m(i+1) = m(i) + dt*(alfa_m(V(i))*(1-m(i)) - (beta_m(V(i))*m(i)));
    h(i+1) = h(i) + dt*(alfa_h(V(i))*(1-h(i)) - (beta_h(V(i))*h(i)));
    JL(i+1) = gL*(V(i)-EL);
    JK(i+1) = gK*(V(i)-EK)*n(i+1)^4;
    JNa(i+1) = gNa*(V(i)-ENa)*h(i+1)*m(i+1)^3;
    V(i+1) = V(i) + (dt/cm)* (-JL(i+1)-JK(i+1)-JNa(i+1)+ JE(i+1));
    
end

gKv = gK*n.^4;
gNav = gNa*h.*m.^3;
end

