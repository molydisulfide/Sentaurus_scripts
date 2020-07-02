# --------- Parameters ------
(define nm 1e-3)
(define CNT_r @CNT_r@) ; set CNT radius as variable in simulation
(define CNT_d (+ CNT_r CNT_r))
(define CNT_shell 0.25)
(define height (+ CNT_d 0.7 (* 2 CNT_shell)))
(define top_g (+ height 10))
(define C_doping 1e18)
(define S_doping 1e18)
(define D_doping 1e18)
(define CNT_doping 1e20)


# ----------Draw Structure----------
(sdegeo:create-cuboid (position 0 0 -0.25) (position 40 40 0.45) "Moly" "Channel" ) ; MoS2 Channel

(sdegeo:create-cuboid (position -20 -20 -0.25) (position 60 60 -10) "SiO2" "Substrate") ; SiO2 substrate

(sdegeo:create-cylinder (position 20 0 (+ 0.7 CNT_r)) (position 20 40 (+ 0.7 CNT_r)) CNT_r "Moly" "Core") ; CNT core

(sdegeo:set-default-boolean "BAB")

(sdegeo:create-cylinder (position 20 0 (+ 0.7 CNT_r)) (position 20 40 (+ 0.7 CNT_r)) (+ CNT_r CNT_shell) "CNT" "Nanotube") ; CNT shell

(sdegeo:create-cylinder (position 20 40 (+ 0.7 CNT_r)) (position 20 50 (+ 0.7 CNT_r)) (- CNT_r 0.5) "Moly" "HighLead") ; HIGH lead sticking out of CNT core
(sdegeo:create-cuboid (position 10 47 0.0) (position 30 53 5) "Moly" "HighPad") ; HIGH pad

(sdegeo:create-cylinder (position 20 0 (+ 0.7 CNT_r)) (position 20 -10 (+ 0.7 CNT_r)) (- CNT_r 0.5) "Moly" "LowLead") ; LOW lead sticking out of CNT core
(sdegeo:create-cuboid (position 10 -7 0.0) (position 30 -13 5) "Moly" "LowPad") ; LOW pad

(sdegeo:create-cuboid (position 0 0 0.0) (position 10 40 0.7) "Moly" "Source") ; MoS2 source region
(sdegeo:create-cuboid (position 30 0 0.0) (position 40 40 0.7) "Moly" "Drain") ; MoS2 drain region

(sdegeo:create-cuboid (position (- 20 CNT_r) 0 (- height 0.25)) (position (+ 20 CNT_r) 40 (+ height 0.25)) "CNT" "Gate") ; CNT gating spacer

# ----------Set Contacts----------

# Moly JFET contacts 

(sdegeo:define-contact-set "S" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "S")
(sdegeo:define-3d-contact(list(car(find-face-id (position 5 35 0.7 ))))"S")
(sdegeo:define-contact-set "D" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "D")
(sdegeo:define-3d-contact(list(car(find-face-id (position 35 35 0.7 ))))"D")
(sdegeo:define-contact-set "G" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "G")
(sdegeo:define-3d-contact(list(car(find-face-id (position 20 35 (+ height 0.25) ))))"G")

# Ionic Current Contacts

(sdegeo:define-contact-set "S" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "S")
(sdegeo:define-3d-contact(list(car(find-face-id (position 20 -13 5.0 ))))"S")

(sdegeo:define-contact-set "D" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "D")
(sdegeo:define-3d-contact(list(car(find-face-id (position 20 53 5.0 ))))"D")

#(set-interface-contact "TopSiO2" "nImplant" "bias1")
#(set-interface-contact "TopSiO2" "nImplant1" "bias2")

;-----DOPING------;

;--- Channel ---
(sdedr:define-constant-profile "dopedC" "PhosphorusActiveConcentration" C_doping )
(sdedr:define-constant-profile-region "RegionC" "dopedC" "Channel" )

;--- Source ---
(sdedr:define-constant-profile "dopedS" "PhosphorusActiveConcentration" S_doping )
(sdedr:define-constant-profile-region "RegionS" "dopedS" "Source" )

;--- Drain ---
(sdedr:define-constant-profile "dopedD" "PhosphorusActiveConcentration" D_doping )
(sdedr:define-constant-profile-region "RegionD" "dopedD" "Drain" )

;--- Gate ---
(sdedr:define-constant-profile "dopedGt" "BoronActiveConcentration" CNT_doping )
(sdedr:define-constant-profile-region "RegionGt" "dopedGt" "Gate" )

;--- CNT Shell ---
(sdedr:define-constant-profile "dopedNT" "BoronActiveConcentration" CNT_doping )
(sdedr:define-constant-profile-region "RegionNT" "dopedNT" "Nanotube" )

;--- CNT Core ---
(sdedr:define-constant-profile "dopedC" "PhosphorusActiveConcentration" C_doping )
(sdedr:define-constant-profile-region "RegionCore" "dopedC" "Core" )

;--- High Lead ---
(sdedr:define-constant-profile "dopedC" "PhosphorusActiveConcentration" C_doping )
(sdedr:define-constant-profile-region "RegionHL" "dopedC" "HighLead" )

;--- Low Lead ---
(sdedr:define-constant-profile "dopedC" "PhosphorusActiveConcentration" C_doping )
(sdedr:define-constant-profile-region "RegionLL" "dopedC" "LowLead" )

;--- High Pad ---
(sdedr:define-constant-profile "dopedC" "PhosphorusActiveConcentration" C_doping )
(sdedr:define-constant-profile-region "RegionHP" "dopedC" "HighPad" )

;--- Low Pad ---
(sdedr:define-constant-profile "dopedC" "PhosphorusActiveConcentration" C_doping )
(sdedr:define-constant-profile-region "RegionLP" "dopedC" "LowPad" )

;----- MESHING------;

(sdedr:define-refeval-window "RefEvalWin_1" "Cuboid"  (position 0.05 0.05 0.05)  (position 2 2 2) )

(sdedr:define-refinement-size "RefinementDefinition_1"   )

(sdedr:define-refinement-placement "RefinementPlacement_1" "RefinementDefinition_1" (list "window" "RefEvalWin_1" ) )

(sdedr:define-refinement-function "RefinementDefinition_1" "MaxLenInt" "Moly" "CNT" 0.008 1.4)


;----- (6). Save (BND and CMD and rescale to nm) -----;

(sde:assign-material-and-region-names (get-body-list) )
(sdeio:save-tdr-bnd (get-body-list) "n@node@_nm.tdr")
(sdedr:write-scaled-cmd-file "n@node@_msh.cmd" nm)
(define sde:scale-tdr-bnd
(lambda (tdrin sf tdrout)
	(sde:clear)
	(sdegeo:set-default-boolean "XX")
	(sdeio:read-tdr-bnd tdrin)
	(entity:scale (get-body-list) sf)
	(sdeio:save-tdr-bnd (get-body-list) tdrout)
	)
)
(sde:scale-tdr-bnd "n@node@_nm.tdr" nm "n@node@_bnd.tdr")


