;; PROBLEMA 2.2: Segundo Rover con Colaboración Paralela
;; CAMBIOS RESPECTO AL PROBLEMA ORIGINAL:
;; 1. Se añade rover1 (línea 5) con identificador rover1
;; 2. Se añade store para rover1: rover1store (línea 6)
;; 3. Se añade camera1 para rover1 (línea 8) calibrada con objective0
;; 4. Se añade batería bat1 para rover1 (línea 11)
;; 5. rover1 tiene capacidades completas de movimiento, análisis e imaging (líneas 64-78)
;; 6. rover1 iniciado en waypoint0 con batería nivel b4
;; 7. Se definen rutas específicas para rover1 diferente de rover0
;; 8. Se expanden los objetivos a 10 (4 imágenes + 3 muestras suelo + 3 muestras roca)

(define (problem rovers_parte2.2) (:domain Rover-battery)
(:objects
    general - Lander
    colour high_res low_res - Mode
    rover0 rover1 - Rover
    rover0store rover1store - Store
    waypoint0 waypoint1 waypoint2 waypoint3 - Waypoint
    camera0 camera1 - Camera
    objective0 objective1 - Objective
    b0 b1 b2 b3 b4 b5 - Blevel
    bat0 bat1 - Battery
)
(:init
    (visible waypoint1 waypoint0)
    (visible waypoint0 waypoint1)
    (visible waypoint2 waypoint0)
    (visible waypoint0 waypoint2)
    (visible waypoint2 waypoint1)
    (visible waypoint1 waypoint2)
    (visible waypoint3 waypoint0)
    (visible waypoint0 waypoint3)
    (visible waypoint3 waypoint1)
    (visible waypoint1 waypoint3)
    (visible waypoint3 waypoint2)
    (visible waypoint2 waypoint3)

    (at_soil_sample waypoint0)
    (at_rock_sample waypoint1)
    (at_soil_sample waypoint2)
    (at_rock_sample waypoint2)
    (at_soil_sample waypoint3)
    (at_rock_sample waypoint3)

    (at_lander general waypoint0)
    (channel_free general)

    ; rover0 initial
    (at rover0 waypoint3)
    (available rover0)
    (store_of rover0store rover0)
    (empty rover0store)
    (equipped_for_soil_analysis rover0)
    (equipped_for_rock_analysis rover0)
    (equipped_for_imaging rover0)
    (can_traverse rover0 waypoint3 waypoint0)
    (can_traverse rover0 waypoint0 waypoint3)
    (can_traverse rover0 waypoint3 waypoint1)
    (can_traverse rover0 waypoint1 waypoint3)
    (can_traverse rover0 waypoint1 waypoint2)
    (can_traverse rover0 waypoint2 waypoint1)
    (on_board camera0 rover0)
    (calibration_target camera0 objective1)
    (supports camera0 colour)
    (supports camera0 high_res)
    (battery_installed rover0 bat0 b4 b4)

    ;; CAMBIO 2.1: Adición de rover1
    ;; rover1 es un segundo rover con capacidades de movimiento, análisis de suelo/roca e imaging
    ;; Posición inicial: waypoint0 (diferente a rover0 que inicia en waypoint3)
    ;; Esto permite paralelizar tareas desde el inicio
    (at rover1 waypoint0)
    (available rover1)
    (store_of rover1store rover1)
    (empty rover1store)
    (equipped_for_soil_analysis rover1)
    (equipped_for_rock_analysis rover1)
    (equipped_for_imaging rover1)
    ;; CAMBIO 2.2: Rutas de traversal para rover1
    ;; Se definen rutas diferentes a rover0 para optimizar la exploración
    (can_traverse rover1 waypoint0 waypoint3)
    (can_traverse rover1 waypoint3 waypoint0)
    (can_traverse rover1 waypoint0 waypoint1)
    (can_traverse rover1 waypoint1 waypoint0)
    (can_traverse rover1 waypoint1 waypoint2)
    (can_traverse rover1 waypoint2 waypoint1)
    ;; CAMBIO 2.3: Camera y batería para rover1
    ;; camera1 calibrada con objective0 (rover0 usa camera0 con objective1)
    (on_board camera1 rover1)
    (calibration_target camera1 objective0)
    (supports camera1 colour)
    (supports camera1 high_res)
    ;; Batería de rover1 también con nivel inicial b4
    (battery_installed rover1 bat1 b4 b4)

    ;; Definición del orden parcial de niveles de batería
    ;; (usado por la acción navigate-bat para consumir energía)
    (lower b0 b1) (lower b1 b2) (lower b2 b3) (lower b3 b4) (lower b4 b5)

    ;; Definición de visibilidad de objetivos desde cada waypoint
    ;; Permite que los rovers capturen imágenes desde diferentes ubicaciones
    (visible_from objective0 waypoint0)
    (visible_from objective0 waypoint1)
    (visible_from objective0 waypoint2)
    (visible_from objective0 waypoint3)
    (visible_from objective1 waypoint0)
    (visible_from objective1 waypoint1)
    (visible_from objective1 waypoint2)
)

(:goal (and
    ;; CAMBIO 2.4: Objetivos expandidos (10 total vs 3 en problema original)
    ;; Los dos rovers deben recolectar y comunicar todas las muestras de suelo
    (communicated_soil_data waypoint0)
    (communicated_soil_data waypoint2)
    (communicated_soil_data waypoint3)
    ;; Todos los datos de muestras de roca deben ser comunicados
    (communicated_rock_data waypoint1)
    (communicated_rock_data waypoint2)
    (communicated_rock_data waypoint3)
    ;; CAMBIO 2.5: Imágenes de todos los objetivos en ambos modos
    ;; objective0 capturada por rover1 (camera1), objective1 por rover0 (camera0)
    ;; Ambos en modo colour y high_res
    (communicated_image_data objective0 colour)
    (communicated_image_data objective0 high_res)
    (communicated_image_data objective1 colour)
    (communicated_image_data objective1 high_res)
))
)
