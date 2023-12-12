clear; 
clc; 
close all; 

%% load data %% 
fin_dat = table2array(readtable('FinData.txt'));
pos = [.065; .110; .180; .280; .394; .504; .605];
% Coefficients: 
c = .012*pi;
l = .605;
V = 40; 
R = 178;
A = pi*(.006)^2;
q = (V^2)/(R);

%% 1. Experimental Heat Transfer Coefficient (h_exp)
t_amb = fin_dat(2701,9);
t_ss = fin_dat(2701, 2:8);

y = t_ss - t_amb;
int = trapz(pos,y);

h_exp = q./(int * c);

%% 2. Theoretical Temperature Matrix 
T_amb = mean(fin_dat(1, 2:9));
k = 401;
m = sqrt((h_exp*c)/(k*A));
L = .605;
rho = 8960;
cp = 386;
alpha = k/(rho*cp);


x = transpose(pos); 
%t_ss_th = zeros(length(x), length(t)); 

for i = 1:7
    for t = 1:1:height(fin_dat)
        for n = 1:7
        %summation term
        sum_term(n) = (cos(n*pi()*x(i)/L)*exp((-n^2)*(pi()^2)*alpha*t/(L^2)))/((m^2)*(L^2)+(n^2)*(pi()^2));
        n
        end
        summ = sum(sum_term)
        % Theoretical Temp eq
        one = (exp(m*(x(i) - 2*L)) + exp(-m*x(i)))/(m*(1 - exp(-2*m*L)));
        two = -2*exp(alpha*t*(-m^2));
        three = 1/(2*(m^2)*L) + L*summ;
        
        t_th(i,t) = T_amb + (q/k)*(one + (two*three))
        i
        t
    end
end

%% uncertainty 
unc= fin_dat(1:60, 2:8); 
t95=1.96;
N=60; 
sd=std(unc);
error=sd*t95/sqrt(N);

%% 3. Plot Steady Theoretical and Experimental Temp Dist
errorbar (x,t_ss, error, "Color",'r') % experimental steady state
title('Steady Theoretical and Experimental Temperature Distribution')
hold on 

plot(x,t_th(:,end),"Color", 'b'); % theoretical temp dist
xlabel('Location along Fin (m)')
ylabel('Temperature (C)')
legend('Experimental','Theoretical')
hold off

%% 4. Transient Theoretical and Experimental Distribution
% plot temp dist from thermocouples
% plot theoretical temp dist 

% %% pt 4 
% T1=fin_dat(:,2);
% T2=fin_dat(:,3);
% T3=fin_dat(:,4);
% T4=fin_dat(:,5);
% T5=fin_dat(:,6);
% T6=fin_dat(:,7);
% T7=fin_dat(:,8);
% 
% figure 
% hold on
% xlabel('Time (s)') 
% ylabel('Temperature (C)')
% legend('Experimental','Theoretical')
% title('Transient Temperature Distribution')
% plot(t,T1,'DisplayName','Exp. 1')
% plot(t,T2,'DisplayName','Exp. 2')
% plot(t,T3,'DisplayName','Exp. 3')
% plot(t,t_th(1,:),'DisplayName','Theor. 1')
% plot(t,t_th(2,:),'DisplayName','Theor. 2')
% plot(t,t_th(3,:),'DisplayName','Theor. 3')
% legend
% hold off
% 
% figure()
% hold on
% xlabel('Time (s)') 
% ylabel('Temperature (C)')
% legend('Experimental','Theoretical')
% title('Transient Temperature Distribution')
% plot(t,T4,'DisplayName','Exp. 4')
% plot(t,T5,'DisplayName','Exp. 5')
% plot(t,t_th(4,:),'DisplayName','Theor. 4')
% plot(t,t_th(5,:),'DisplayName','Theor. 5')
% legend
% hold off
% 
% 
% figure()
% hold on
% xlabel('Time (s)') 
% ylabel('Temperature (C)')
% legend('Experimental','Theoretical')
% title('Transient Temperature Distribution')
% plot(t,T6,'DisplayName','Exp. 6')
% plot(t,T7,'DisplayName','Exp. 7')
% plot(t,t_th(6,:),'DisplayName','Theor. 6')
% plot(t,t_th(7,:),'DisplayName','Theor. 7')
% legend