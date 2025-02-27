function [Xpunto]=generacion_trayectorias(pi,pf)
    i = 1;
    j=1;
    m=1;
    lambda = 0;
    dlambda = 0.01;
    while lambda<1 
        p(i,:) = pi + (pf-pi)*lambda;%Interpolacion lineal de los puntos
        lambda = lambda + dlambda;
        rx=[1 0 0;0 cos(p(i,4)) -sin(p(i,4));0 sin(p(i,4)) cos(p(i,4))];
        ry=[cos(p(i,5)) 0 sin(p(i,5));0 1 0;-sin(p(i,5)) 0 cos(p(i,5))];
        rz=[cos(p(i,6)) -sin(p(i,6)) 0; sin(p(i,6)) cos(p(i,6)) 0;0 0 1];
        R{i}=rx*ry*rz; %matriz de matrices de rotaci�n
        i = i + 1; 
    end
    vx=diff(p(:,1)); %velocidad lineal=derivada de los vectores de posicion
    vy=diff(p(:,2));
    vz=diff(p(:,3));
    w=velocidades_angulares(R);%Scrip de las velocidades angulares
    while j<99
        wx(j)=w{j}(3,2);
        wy(j)=w{j}(1,3);
        wz(j)=w{j}(2,1);
        j=j+1;
    end
    %Montamos el vector Xpunto
    while m<99
        Xpunto(:,m)=[vx(m) vy(m) vz(m) wx(m) wy(m) wz(m)].';  
        m=m+1;
    end
end