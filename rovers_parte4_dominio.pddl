(define (domain Rover-battery-extended)
(:requirements :typing :strips)
(:types rover waypoint store camera mode lander objective
       blevel battery
       ; Nuevos tipos para terreno y traccion
       terrain traction
)

(:predicates (at ?x - rover ?y - waypoint) 
             (at_lander ?x - lander ?y - waypoint)
             
             ; Se elimina can_traverse simple que dependia del rover.
             ; Ahora el mapa tiene tipos de terreno especificos.
             (traverse_type ?x - waypoint ?y - waypoint ?t - terrain)
             
             ; Predicados para definir que traccion lleva el rover
             ; y si esa traccion sirve para un terreno.
             (has_traction ?r - rover ?tr - traction)
             (suitable ?tr - traction ?t - terrain)

             (equipped_for_soil_analysis ?r - rover)
             (equipped_for_rock_analysis ?r - rover)
             (equipped_for_imaging ?r - rover)
             (empty ?s - store)
             (have_rock_analysis ?r - rover ?w - waypoint)
             (have_soil_analysis ?r - rover ?w - waypoint)
             (full ?s - store)
             (calibrated ?c - camera ?r - rover) 
             (supports ?c - camera ?m - mode)
             (available ?r - rover)
             (visible ?w - waypoint ?p - waypoint)
             (have_image ?r - rover ?o - objective ?m - mode)
             (communicated_soil_data ?w - waypoint)
             (communicated_rock_data ?w - waypoint)
             (communicated_image_data ?o - objective ?m - mode)
             (at_soil_sample ?w - waypoint)
             (at_rock_sample ?w - waypoint)
             (visible_from ?o - objective ?w - waypoint)
             (store_of ?s - store ?r - rover)
             (calibration_target ?i - camera ?o - objective)
             (on_board ?i - camera ?r - rover)
             (channel_free ?l - lander)
             (battery_installed ?r - rover ?b - battery ?bmax ?bcur - blevel)
             (lower ?l1 ?l2 - blevel)
)
; Operador de movimiento modificado.
; Ahora requiere verificar (traverse_type) y (suitable) en lugar de can_traverse.
(:action navigate-bat
:parameters (?r - rover ?y - waypoint ?z - waypoint
              ?b - battery ?bmax ?bcur ?bnext - blevel
              ?t - terrain ?tr - traction
) 
:precondition (and 
                (traverse_type ?y ?z ?t)   ; El camino es de un tipo especifico
                (has_traction ?r ?tr)      ; El rover tiene una traccion concreta
                (suitable ?tr ?t)          ; La traccion es apta para ese terreno
                (available ?r) 
                (at ?r ?y) 
                (visible ?y ?z)
                (battery_installed ?r ?b ?bmax ?bcur)
                (lower ?bnext ?bcur)
        )
:effect (and (not (at ?r ?y)) (at ?r ?z)
             (not (battery_installed ?r ?b ?bmax ?bcur) )
             (battery_installed ?r ?b ?bmax ?bnext)
        )
)

; Nuevo operador de remolque (tow).
; Rover r1 remolca a Rover r2. 
; - Deben empezar en el mismo punto.
; - Solo r1 gasta bateria.
; - r2 se mueve aunque no tenga capacidad para ese terreno.
(:action navigate-tow
:parameters (?r1 - rover ?r2 - rover ?y - waypoint ?z - waypoint
              ?b - battery ?bmax ?bcur ?bnext - blevel
              ?t - terrain ?tr - traction
) 
:precondition (and 
                (at ?r1 ?y) (at ?r2 ?y)        ; Ambos rovers en el origen
                (traverse_type ?y ?z ?t)       ; Tipo de terreno del camino
                (has_traction ?r1 ?tr)         ; r1 tiene traccion
                (suitable ?tr ?t)              ; r1 SI PUEDE cruzar el terreno
                (available ?r1) (available ?r2)
                (visible ?y ?z)
                (battery_installed ?r1 ?b ?bmax ?bcur) ; Bateria de r1
                (lower ?bnext ?bcur)
        )
:effect (and 
             (not (at ?r1 ?y)) (at ?r1 ?z)     ; r1 se mueve
             (not (at ?r2 ?y)) (at ?r2 ?z)     ; r2 es arrastrado
             (not (battery_installed ?r1 ?b ?bmax ?bcur) )
             (battery_installed ?r1 ?b ?bmax ?bnext) ; r1 gasta energia
             ; La bateria de r2 no cambia
        )
)

(:action recharge
:parameters (?r - rover ?l - lander ?w - waypoint
              ?b - battery ?bmax ?bcur - blevel
) 
:precondition (and (at ?r ?w) (at_lander ?l ?w)
                (battery_installed ?r ?b ?bmax ?bcur)
        )
:effect (and 
             (not (battery_installed ?r ?b ?bmax ?bcur) )
             (battery_installed ?r ?b ?bmax ?bmax)
        )
)

(:action sample_soil
:parameters (?r - rover ?s - store ?p - waypoint)
:precondition (and (at ?r ?p) (at_soil_sample ?p) (equipped_for_soil_analysis ?r) (store_of ?s ?r) (empty ?s)
        )
:effect (and (not (empty ?s)) (full ?s) (have_soil_analysis ?r ?p) (not (at_soil_sample ?p))
        )
)

(:action sample_rock
:parameters (?r - rover ?s - store ?p - waypoint)
:precondition (and (at ?r ?p) (at_rock_sample ?p) (equipped_for_rock_analysis ?r) (store_of ?s ?r)(empty ?s)
        )
:effect (and (not (empty ?s)) (full ?s) (have_rock_analysis ?r ?p) (not (at_rock_sample ?p))
        )
)

(:action drop
:parameters (?r - rover ?s - store)
:precondition (and (store_of ?s ?r) (full ?s)
        )
:effect (and (not (full ?s)) (empty ?s)
    )
)

(:action calibrate
 :parameters (?r - rover ?i - camera ?t - objective ?w - waypoint)
 :precondition (and (equipped_for_imaging ?r) (calibration_target ?i ?t) (at ?r ?w) (visible_from ?t ?w)(on_board ?i ?r)
        )
 :effect (calibrated ?i ?r) 
)

(:action take_image
 :parameters (?r - rover ?p - waypoint ?o - objective ?i - camera ?m - mode)
 :precondition (and (calibrated ?i ?r)
             (on_board ?i ?r)
                      (equipped_for_imaging ?r)
                      (supports ?i ?m)
              (visible_from ?o ?p)
                     (at ?r ?p)
               )
 :effect (and (have_image ?r ?o ?m)(not (calibrated ?i ?r))
        )
)

(:action communicate_soil_data
 :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
 :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_soil_analysis ?r ?p) 
                   (visible ?x ?y)(available ?r)(channel_free ?l)
            )
 :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)
        (communicated_soil_data ?p)(available ?r)
    )
)

(:action communicate_rock_data
 :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
 :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_rock_analysis ?r ?p)
                   (visible ?x ?y)(available ?r)(channel_free ?l)
            )
 :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)(communicated_rock_data ?p)(available ?r)
          )
)

(:action communicate_image_data
 :parameters (?r - rover ?l - lander ?o - objective ?m - mode ?x - waypoint ?y - waypoint)
 :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_image ?r ?o ?m)(visible ?x ?y)(available ?r)(channel_free ?l)
            )
 :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)(communicated_image_data ?o ?m)(available ?r)
          )
)

)