(define (problem roverprob_parte4) (:domain Rover-battery-extended)
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
    ; Definicion de tipos requeridos en Parte 4
    wheels legs - traction
    rocky normal - terrain
    )
(:init
    ; Visibilidad (igual que antes)
    (visible waypoint1 waypoint0) (visible waypoint0 waypoint1)
    (visible waypoint2 waypoint0) (visible waypoint0 waypoint2)
    (visible waypoint2 waypoint1) (visible waypoint1 waypoint2)
    (visible waypoint3 waypoint0) (visible waypoint0 waypoint3)
    (visible waypoint3 waypoint1) (visible waypoint1 waypoint3)
    (visible waypoint3 waypoint2) (visible waypoint2 waypoint3)
    
    ; Definicion del tipo de terreno de los caminos.
    (traverse_type waypoint0 waypoint3 normal)
    (traverse_type waypoint3 waypoint0 normal)
    (traverse_type waypoint3 waypoint1 normal)
    (traverse_type waypoint1 waypoint3 normal)
    
    (traverse_type waypoint1 waypoint2 rocky)
    (traverse_type waypoint2 waypoint1 rocky)

    ; Definicion de la traccion de cada rover
    (has_traction rover0 legs)   ; Rover 0 tiene patas
    (has_traction rover1 wheels) ; Rover 1 tiene ruedas
    
    ; Las patas (legs) sirven para todo
    (suitable legs rocky)
    (suitable legs normal)
    ; Las ruedas (wheels) solo sirven para camino normal
    (suitable wheels normal)

    ; Muestras y Lander
    (at_soil_sample waypoint0)
    (at_rock_sample waypoint1)
    (at_soil_sample waypoint2)
    (at_rock_sample waypoint2)
    (at_soil_sample waypoint3)
    (at_rock_sample waypoint3)
    (at_lander general waypoint0)
    (channel_free general)
    
    ; Configuracion ROVER 0 (El "Remolcador")
    (at rover0 waypoint3)
    (available rover0)
    (store_of rover0store rover0)
    (empty rover0store)
    (equipped_for_soil_analysis rover0)
    (equipped_for_rock_analysis rover0)
    (battery_installed rover0 bat0 b4 b4)

    ; Configuracion ROVER 1 (El que necesita ayuda)
    (at rover1 waypoint3)
    (available rover1)
    (store_of rover1store rover1)
    (empty rover1store)
    (equipped_for_imaging rover1)
    (battery_installed rover1 bat1 b4 b4)

    ; Camaras
    (on_board camera0 rover1)
    (calibration_target camera0 objective1)
    (supports camera0 colour)
    (supports camera0 high_res)
    
    ; Niveles de bateria
    (lower b0 b1) (lower b1 b2) (lower b2 b3) (lower b3 b4) (lower b4 b5)
    
    ; Visibilidad de objetivos
    (visible_from objective0 waypoint0)
    (visible_from objective0 waypoint1)
    (visible_from objective0 waypoint2)
    (visible_from objective0 waypoint3)
    (visible_from objective1 waypoint0)
    (visible_from objective1 waypoint1)
    (visible_from objective1 waypoint2)
)

(:goal (and
   ; OBJETIVO DEL PROBLEMA:
   ; El Rover 1 (ruedas) debe tomar una foto desde waypoint2.
   ; Pero el camino a waypoint2 es rocoso.
   ; Por tanto, Rover 0 (patas) debe remolcar a Rover 1 hasta alli.
   (communicated_image_data objective1 high_res)
   )
)
)