# --------- Parameters ------
(define nm 1e-3)
(define CNT_r @CNT_r@) ; set CNT radius as variable in simulation
(define CNT_d (+ CNT_r CNT_r))
(define height (+ CNT_d 0.7))
(define top_g (+ height 10))
(define C_doping 1e18)
(define S_doping 1e18)
(define D_doping 1e18)
(define CNT_doping 1e20)

# ----------Draw Structure----------
(sdegeo:create-cuboid (position 0 0 0) (position 40 40 0.7) "Moly" "Channel" ) ; MoS2 Channel

(sdegeo:create-cuboid (position -20 -20 0) (position 60 60 -10) "SiO2" "Substrate") ; SiO2 substrate

(sdegeo:create-cylinder (position 20 0 (+ 0.7 CNT_r)) (position 20 40 (+ 0.7 CNT_r)) CNT_r "CNT" "Nanotube") ; CNT gate

(sdegeo:create-cuboid (position 0 0 0.0) (position 10 40 0.7) "Moly" "Source") ; MoS2 source region
(sdegeo:create-cuboid (position 30 0 0.0) (position 40 40 0.7) "Moly" "Drain") ; MoS2 drain region

(sdegeo:create-cuboid (position (- 20 CNT_r) 0 (- height 0.25)) (position (+ 20 CNT_r) 40 (+ height 0.25)) "CNT" "Gate") ;CNT gating spacer

# ----------Set Contacts----------
(sdegeo:define-contact-set "S" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "S")
(sdegeo:define-3d-contact(list(car(find-face-id (position 5 35 0.7 ))))"S")
(sdegeo:define-contact-set "D" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "D")
(sdegeo:define-3d-contact(list(car(find-face-id (position 35 35 0.7 ))))"D")
(sdegeo:define-contact-set "G" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "G")
(sdegeo:define-3d-contact(list(car(find-face-id (position 20 35 (+ height 0.25) ))))"G")

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

;--- Nanotube ---
(sdedr:define-constant-profile "dopedNT" "BoronActiveConcentration" CNT_doping )
(sdedr:define-constant-profile-region "RegionNT" "dopedNT" "Nanotube" )

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
