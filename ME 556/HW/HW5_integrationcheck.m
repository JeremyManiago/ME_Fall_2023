clc
clear
close all

syms Q z mu pi Ri Re L rho g H

Rz = Ri - (Ri - Re)*(z/L)
gradz = (8*mu*Q)/(pi*(Rz)^4)
intz = int(gradz, z)
zero = subs(intz, z, 0)
length = simplify(subs(intz, z, L))
f0 = -rho*g*H == simplify(length - zero)
f1 = solve(isolate(f0, Q), Q)
check1 = subs(f1, {mu,pi,Ri,Re,L,rho,g,H}, {2,3.14,10,2,20,1000,9.81,30})

f2 = Q == ( (3*pi*rho*g*H)/(8*mu*L) ) * ((Re - Ri)/(Re^(-3) - Ri^(-3)))

f3 = solve(f2, Q)
check2 = subs(f3, {mu,pi,Ri,Re,L,rho,g,H}, {2,3.14,10,2,20,1000,9.81,30})

tf = isequal(f1,f3)
check_tf = isequal(check1,check2)