% AMPLIACION DE ROBOTICA
% PRACTICA 4: Navegacion local con campos potenciales
% Evitar obstaculos

clc
clearvars
close all
%% Carga del mapa de ocupacion

map_img=imread('mapa1_150.png');
map_neg=imcomplement(map_img);
map_bin=imbinarize(map_neg);
mapa=binaryOccupancyMap(map_bin);
show(mapa);

% Marcar los puntos de inicio y destino
hold on;
title('Señala los puntos inicial y final de la trayectoria del robot');
origen=ginput(1);
plot(origen(1), origen(2), 'go','MarkerFaceColor','green');  % Dibujamos el origen
destino=ginput(1);
plot(destino(1), destino(2), 'ro','MarkerFaceColor','red');  % Dibujamos el destino

% Configuracion del sensor (laser de barrido)
max_rango=10;
angulos=-pi/2:(pi/180):pi/2; % resolucion angular barrido laser

% Caracteristicas del vehiculo y parametros del metodo
v=1;            % Velocidad del robot
D=7;           % Rango del efecto del campo de repulsión de los obstáculos
alfa=1;           % Coeficiente de la componente de atracción
beta=200;      % Coeficiente de la componente de repulsión

%% Inicialización

robot=[origen 0];     % El robot empieza en la posición de origen (orientacion cero)
path = [];                 % Se almacena el camino recorrido
path = [path; robot]; % Se añade al camino la posicion actual del robot
iteracion=0;              % Se controla el nº de iteraciones por si se entra en un minimo local

%% Calculo de la trayectoria

while norm(destino-robot(1:2)) > v && iteracion<1000    % Hasta menos de una iteración de la meta (10 cm)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    % 1. Obtener las lecturas del sensor Lidar (obstáculos locales)
    obs = SimulaLidar(robot, mapa, angulos, max_rango);
    
    % 2. Calcular la Fuerza de Atracción (hacia el destino)
    vec_atr = destino - robot(1:2);
    dist_dest = norm(vec_atr);
    
    % Fuerza proporcional a la distancia
    F_atr = alfa * vec_atr;
    
    % 3. Calcular la Fuerza de Repulsión (alejándose de los obstáculos)
    F_rep = [0, 0];
    
    % Iterar sobre cada rayo del Lidar
    for i = 1:size(obs, 1)

        if ~isnan(obs(i,1)) 

            vec_rep = robot(1:2) - obs(i, :);
            dist_obs = norm(vec_rep);
            
            if dist_obs < D && dist_obs > 0

                u_rep = vec_rep / dist_obs;
                
                mag_rep = beta * ((1/dist_obs) - (1/D)) * (1/(dist_obs^2));
                
                % Sumatorio de las fuerzas de repulsión
                F_rep = F_rep + (mag_rep * u_rep);
            end
        end
    end
    
    % 4. Calcular la Fuerza Resultante
    F_res = F_atr + F_rep;
    
    % 5. Actualizar la posición y orientación del robot
    theta = atan2(F_res(2), F_res(1));
    
    % Actualización x, y, theta
    robot(1) = robot(1) + v * cos(theta);
    robot(2) = robot(2) + v * sin(theta);
    robot(3) = theta;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

    path = [path;robot];	% Se añade la nueva posición al camino seguido
    plot(path(:,1),path(:,2),'r');
    drawnow

    iteracion=iteracion+1;
end

if iteracion==1000   % Se ha caído en un mínimo local
    fprintf('No se ha podido llegar al destino.\n')
else
    fprintf('Destino alcanzado.\n')
end

%% funcion para simular el sensor
function [obs]=SimulaLidar(robot, mapa, angulos, max_rango)
    obs=rayIntersection(mapa,robot,angulos, max_rango);
    % plot(obs(:,1),obs(:,2),'*r') % Puntos de interseccion lidar
    % plot(robot(1),robot(2),'ob') % Posicion del robot
    % for i = 1:length(angulos)
    %     plot([robot(1),obs(i,1)],...
    %         [robot(2),obs(i,2)],'-b') % Rayos de interseccion
    % end
    % % plot([robot(1),robot(1)-6*sin(angulos(4))],...
    % %     [robot(2),robot(2)+6*cos(angulos(4))],'-b') % Rayos fuera de
    % %     rango
end