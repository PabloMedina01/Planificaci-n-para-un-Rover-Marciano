# Planificación para un Rover Marciano
**Razonamiento y Planificación Automática - Actividad 2**  
Fecha de Entrega: 26/01/2026

---

## EJERCICIO 2: 

### Parte 2.1: Nuevo Waypoint con Muestras Múltiples
**Fichero**: [rovers_parte2.1_problema.pddl](rovers_parte2.1_problema.pddl)

#### Cambios en el Código:

1. **Nuevo Waypoint (waypoint4)** - Línea 8
   - Se agrega `waypoint4` a la lista de objetos
   - Conectado bidireccionalemente con `waypoint1` y `waypoint2`
   - Definidas relaciones de visibilidad: `(visible waypoint4 waypoint1)`, `(visible waypoint1 waypoint4)`, etc.

2. **Muestras en waypoint4** - Líneas 39-40
   - Muestra de suelo: `(at_soil_sample waypoint4)`
   - Muestra de roca: `(at_rock_sample waypoint4)`

3. **Rutas de Traversal** - Líneas 57-59
   - `(can_traverse rover0 waypoint1 waypoint4)`
   - `(can_traverse rover0 waypoint4 waypoint1)`
   - `(can_traverse rover0 waypoint2 waypoint4)` 
   - `(can_traverse rover0 waypoint4 waypoint2)`

4. **Nuevos Objetivos** - Líneas 83-86
   - Comunicar datos de suelo: `(communicated_soil_data waypoint4)`
   - Comunicar datos de roca: `(communicated_rock_data waypoint4)`
   - Posición final del rover: `(at rover0 waypoint1)`

---

### Parte 2.2: Segundo Rover con Colaboración
**Fichero**: [rovers_parte2.2_problema.pddl](rovers_parte2.2_problema.pddl)

#### Cambios en el Código:

1. **Nuevo Rover (rover1)** - Línea 5
   - Se agrega `rover1` a la lista de rovers: `rover0 rover1 - Rover`
   - Posición inicial: `waypoint0`

2. **Equipamiento de rover1** - Líneas 6, 8, 11
   - Store asociado: `rover1store`
   - Cámara: `camera1` (calibrada con `objective0`)
   - Batería: `bat1` con nivel inicial `b4`

3. **Capacidades de rover1** - Líneas 64-73
   - Análisis de suelo: `(equipped_for_soil_analysis rover1)`
   - Análisis de roca: `(equipped_for_rock_analysis rover1)`
   - Capacidad de imaging: `(equipped_for_imaging rover1)`

4. **Rutas de Traversal para rover1** - Líneas 74-81
   - `waypoint0 ↔ waypoint3`
   - `waypoint0 ↔ waypoint1`
   - `waypoint1 ↔ waypoint2`
   - (Diferentes a rover0 para optimizar la exploración)

5. **Objetivos Expandidos** - Líneas 113-126
   - **Muestras de suelo**: `waypoint0`, `waypoint2`, `waypoint3`
   - **Muestras de roca**: `waypoint1`, `waypoint2`, `waypoint3`
   - **Imágenes en ambos modos**: 
     - `objective0` en `colour` y `high_res`
     - `objective1` en `colour` y `high_res`
   - **Total**: 10 objetivos (vs 3 en problema original)

---

## Comparación de Complejidad

| Aspecto | 2.1 | 2.2 |
|---------|-----|-----|
| Rovers | 1 | 2 |
| Waypoints | 4 + 1 nuevo = 5 | 4 |
| Cámaras | 1 | 2 |
| Baterías | 1 | 2 |
| Objetivos del Goal | 5 | 10 |
| Pasos del Plan | 18 | 32 |

---

