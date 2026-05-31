# Práctica 4: Navegación Local con Campos Potenciales 🤖
Ampliación de Robótica. Repositorio con la implementación de un módulo de navegación reactiva en tiempo real para evitar obstáculos utilizando el método de campos potenciales.

## 📋 Índice
1. [Tecnologías y Entorno 🛠️](#tecnologias)
2. [Instalación y Ejecución 🎮](#instalacion)
3. [Descripción del Algoritmo 🧠](#descripcion)
4. [Resultados y Demostraciones 📉](#resultados)
5. [Análisis de Mínimos Locales y Parámetros ⚠️](#analisis)

---

<a id="tecnologias"></a>
## Tecnologías y Entorno 🛠️
* **Entorno:** MATLAB
* **Toolboxes requeridos:** Navigation Toolbox, Image Processing Toolbox
* **Técnica:** Campos Potenciales Artificiales (Navegación Local/Reactiva)

<a id="instalacion"></a>
## Instalación y Ejecución 🎮
1. Clona este repositorio en tu equipo local ejecutando el siguiente comando en tu terminal:
  ```bash
  git clone https://github.com/rumonru05-byte/practicas-nav-campos-potenciales.git
  ```

2. Abre MATLAB y navega hasta la carpeta del repositorio.
3. Abre el script `plantilla_campos_potenciales.m` y haz clic en Run (Ejecutar).
4. En la figura que se abrirá, haz clic izquierdo una vez para marcar el punto de Origen (verde) y otra vez para marcar el punto de Destino (rojo). El robot comenzará a navegar automáticamente.

---

<a id="descripcion"></a>
## Descripción del Algoritmo 🧠
El script simula un sensor LiDAR con un rango máximo definido (`max_rango`). En cada iteración, el robot calcula su próximo movimiento basándose únicamente en la información de su entorno local inmediato, evaluando dos componentes principales:

* **Fuerza de Atracción:** Un vector que tira del robot hacia el punto de destino, modulado por el parámetro `alfa`.
* **Fuerza de Repulsión:** Vectores generados por los obstáculos detectados dentro de un radio de seguridad `D`, modulados por el parámetro `beta`. La fuerza aumenta inversamente al cuadrado de la distancia al obstáculo.

La dirección final del robot se obtiene sumando ambas fuerzas y calculando el ángulo de la fuerza resultante en cada iteración de tiempo.


<a id="resultados"></a>
## Resultados y Demostraciones 📉
A continuación, se muestran varios recorridos exitosos partiendo desde diferentes puntos del mapa, demostrando la capacidad del algoritmo para evadir obstáculos en tiempo real y alcanzar el objetivo de forma suave.

### Navegación Exitosa (Diferentes Orígenes/Destinos)
<p align="center">
  <img src="videos/exito1.gif" width="33%" />
  <img src="videos/exito2.gif" width="33%" />
  <img src="videos/exito3.gif" width="33%" />
</p>


<a id="analisis"></a>
## Análisis de Mínimos Locales y Parámetros ⚠️

El método de campos potenciales es puramente reactivo y carece de planificación global, lo que lo hace susceptible a caer en mínimos locales (situaciones de trampa). 


### Mínimos Locales
Cuando el robot se encuentra frente a una pared ancha perpendicular a su destino, o dentro de un obstáculo en forma de "U", la suma de las fuerzas de repulsión iguala y anula exactamente a la fuerza de atracción ($F_res = 0$).

<p align="center">
  <img src="videos/exito1.gif" width="33%" />
  <img src="videos/exito2.gif" width="33%" />
  <img src="videos/exito3.gif" width="33%" />
</p>

**¿Es posible salir de esta situación modificando solo alfa y beta?**
No. Modificar la atracción o la repulsión únicamente desplazará las coordenadas exactas del punto de equilibrio (el robot se detendrá ligeramente más cerca o más lejos del obstáculo), pero el algoritmo no tiene capacidad de rodear el obstáculo por sí mismo sin implementar heurísticas adicionales (como wall-following o movimientos aleatorios).

### Impacto de los Parámetros del Entorno
Un ajuste correcto de las variables es crítico para la estabilidad del movimiento. A continuación se demuestra el comportamiento del robot al someter el algoritmo a parámetros subóptimos:

#### 1. Efecto de la Distancia de Repulsión (D)
<p align="center">
  <img src="videos/exito1.gif" width="33%" />
  <img src="videos/exito2.gif" width="33%" />
  <img src="videos/exito3.gif" width="33%" />
</p>
* (Explica aquí tu vídeo: Si el rango D es muy pequeño, el robot reacciona demasiado tarde y roza peligrosamente los obstáculos. Si es adecuado, el campo de fuerza lo aparta a tiempo trazando curvas amplias).

#### 2. Efecto de la Velocidad / Tamaño de paso (v)
<p align="center">
  <img src="videos/exito1.gif" width="33%" />
  <img src="videos/exito2.gif" width="33%" />
  <img src="videos/exito3.gif" width="33%" />
</p>
* (Explica aquí tu vídeo: Un tamaño de paso demasiado grande provoca oscilaciones graves o "chattering" al entrar y salir bruscamente de las zonas de repulsión de las paredes. Reducir la velocidad estabiliza la trayectoria).

#### 3. Equilibrio de Fuerzas (alfa frente a beta)
<p align="center">
  <img src="videos/exito1.gif" width="33%" />
  <img src="videos/exito2.gif" width="33%" />
  <img src="videos/exito3.gif" width="33%" />
</p>
* (Explica aquí tu vídeo: Si el parámetro de atracción alfa es desproporcionadamente alto frente a la repulsión beta, el deseo del robot por llegar a la meta vence a su sistema de seguridad, provocando choques inminentes contra las paredes).
