;; PROBLEMA 2.1: Nuevo Waypoint con Muestras Múltiples
;; CAMBIOS RESPECTO AL PROBLEMA ORIGINAL:
;; 1. Se añade waypoint4 (línea 8) conectado a waypoint1 y waypoint2
;; 2. waypoint4 contiene muestras de suelo y roca (líneas 39-40)
;; 3. Se definen rutas de traversal a/desde waypoint4 (líneas 57-59)
;; 4. Se añaden objetivos para comunicar ambas muestras de waypoint4 (líneas 83-84)
;; 5. Se añade objetivo para que rover0 termine en waypoint1 (línea 86)

(define (problem rovers_parte2.1) (:domain Rover-battery)
(:objects
    general - Lander
    colour high_res low_res - Mode
    rover0 - Rover
    rover0store - Store
    waypoint0 waypoint1 waypoint2 waypoint3 waypoint4 - Waypoint
    camera0 - Camera
    objective0 objective1 - Objective
    b0 b1 b2 b3 b4 b5 - Blevel
    bat0 - Battery
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
    ;; CAMBIO 1.1: Conectividad de waypoint4
    ;; Se añade visibilidad bidireccional entre waypoint4 y sus vecinos
    (visible waypoint4 waypoint1)
    (visible waypoint1 waypoint4)
    (visible waypoint4 waypoint2)
    (visible waypoint2 waypoint4)

    (at_soil_sample waypoint0)
    (at_rock_sample waypoint1)
    (at_soil_sample waypoint2)
    (at_rock_sample waypoint2)
    (at_soil_sample waypoint3)
    (at_rock_sample waypoint3)
    ;; CAMBIO 1.2: Muestras en waypoint4
    ;; Se añaden muestras de suelo y roca que el rover debe recolectar
    (at_soil_sample waypoint4)
    (at_rock_sample waypoint4)

    (at_lander general waypoint0)
    (channel_free general)
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
    ;; CAMBIO 1.3: Rutas de traversal a waypoint4
    ;; Se definen caminos bidireccionales desde waypoint1 y waypoint2 hacia waypoint4
    (can_traverse rover0 waypoint1 waypoint4)
    (can_traverse rover0 waypoint4 waypoint1)
    (can_traverse rover0 waypoint2 waypoint4)
    (can_traverse rover0 waypoint4 waypoint2)

    (on_board camera0 rover0)
    (calibration_target camera0 objective1)
    (supports camera0 colour)
    (supports camera0 high_res)
    ;; Batería de rover0 con nivel inicial b4
    (battery_installed rover0 bat0 b4 b4)
    (lower b0 b1) (lower b1 b2) (lower b2 b3) (lower b3 b4) (lower b4 b5)
    (visible_from objective0 waypoint0)
    (visible_from objective0 waypoint1)
    (visible_from objective0 waypoint2)
    (visible_from objective0 waypoint3)
    (visible_from objective1 waypoint0)
    (visible_from objective1 waypoint1)
    (visible_from objective1 waypoint2)
)

(:goal (and
    ;; Objetivos originales del problema
    (communicated_soil_data waypoint2)
    (communicated_rock_data waypoint3)
    (communicated_image_data objective1 high_res)
    ;; CAMBIO 1.4: Nuevos objetivos para waypoint4
    ;; Se requiere comunicar las muestras de suelo y roca recolectadas en waypoint4
    (communicated_soil_data waypoint4)
    (communicated_rock_data waypoint4)
    ;; CAMBIO 1.5: Objetivo de posición final
    ;; El rover debe terminar en waypoint1 después de completar todas las tareas
    (at rover0 waypoint1)
))
)
