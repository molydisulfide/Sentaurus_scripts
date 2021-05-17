# --------- Parameters ------
(define nm 1e-3)
(define CNT_r @CNT_r@) ; set CNT radius as variable in simulation
(define CNT_d (+ CNT_r CNT_r))
(define height (+ CNT_d 1.2))
(define top_g (+ height 1.2))
(define M_doping 1e18)
(define S_doping 1e19)
(define D_doping 1e19)
(define CNT_doping 1e19)
(define Si_doping 1e12)
(define vdW (+ CNT_d 0.1))

# ----------Draw Structure----------

#(sdegeo:create-cuboid (position 10 0 0.7) (position 30 40 1.2) "Silicon" "Dielectric" ) ; HfO2 gate dielectric

(sdegeo:create-cuboid (position -20 -20 0) (position 60 60 (- CNT_d)) "SiO2" "Substrate") ; SiO2 substrate

(sdegeo:create-cylinder (position 20 -10 CNT_r) (position 20 50 CNT_r) CNT_r "CNT" "Nanotube"); CNT channel

(sdegeo:create-cylinder (position 20 -10 CNT_r) (position 20 -5 CNT_r) CNT_r "CNT" "Source") ; CNT source electrode

(sdegeo:create-cylinder (position 20 45 CNT_r) (position 20 50 CNT_r) CNT_r "CNT" "Drain") ; CNT drain electrode

(sdegeo:create-cuboid (position 17 5 CNT_d) (position 23 35 (+ CNT_d 0.7)) "Moly" "Gate" ) ; MoS2 gate

(sdegeo:create-cuboid (position 0 5 0) (position 17 35 0.7) "Moly" "GateFlat1" ) ; MoS2 gate flat 1

(sdegeo:create-cuboid (position 23 5 0) (position 40 35 0.7) "Moly" "GateFlat2" ) ; MoS2 gate flat 2

(sdegeo:create-cuboid (position 17 5 0) (position 18 35 (+ CNT_d 0.7)) "Moly" "GateWall1" ) ; MoS2 gate wall 1

(sdegeo:create-cuboid (position 22 5 0) (position 23 35 (+ CNT_d 0.7)) "Moly" "GateWall2" ) ; MoS2 gate wall 2

(sdegeo:create-cuboid (position 0 5 0) (position 10 35 0.7) "Moly" "Gate_Electrode") ; MoS2 gate region



# ----------Set Contacts----------
(sdegeo:define-contact-set "S" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "S")
(sdegeo:define-3d-contact(list(car(find-face-id (position 20 -10 CNT_r ))))"S")

(sdegeo:define-contact-set "D" 4.0 (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-current-contact-set "D")
(sdegeo:define-3d-contact(list(car(find-face-id (position 20 50 CNT_r ))))"D")


(sdegeo:define-contact-set "G" 4.0 (color:rgb 0.5 0.7 0.3 ) "##" )
(sdegeo:set-current-contact-set "G")
(sdegeo:define-3d-contact(list(car(find-face-id (position 5 20 0.7 ))))"G")


#(set-interface-contact "TopSiO2" "nImplant" "bias1")
#(set-interface-contact "TopSiO2" "nImplant1" "bias2")

;-----DOPING------;


;--- Nanotube ---
(sdedr:define-constant-profile "dopedNT" "BoronActiveConcentration" CNT_doping )
(sdedr:define-constant-profile-region "RegionNT" "dopedNT" "Nanotube" )

;--- Source ---
(sdedr:define-constant-profile "dopedS" "BoronActiveConcentration" S_doping )
(sdedr:define-constant-profile-region "RegionS" "dopedS" "Source" )

;--- Drain ---
(sdedr:define-constant-profile "dopedD" "BoronActiveConcentration" D_doping )
(sdedr:define-constant-profile-region "RegionD" "dopedD" "Drain" )

;--- Moly ---
(sdedr:define-constant-profile "dopedC" "PhosphorusActiveConcentration" M_doping )
(sdedr:define-constant-profile-region "RegionC" "dopedC" "Gate" )

;--- MolyFlat1 ---
(sdedr:define-constant-profile "dopedF1" "PhosphorusActiveConcentration" M_doping )
(sdedr:define-constant-profile-region "RegionF1" "dopedF1" "GateFlat1" )

;--- MolyFlat2 ---
(sdedr:define-constant-profile "dopedF2" "PhosphorusActiveConcentration" M_doping )
(sdedr:define-constant-profile-region "RegionF2" "dopedF2" "GateFlat2" )

;--- MolyWall1 ---
(sdedr:define-constant-profile "dopedW1" "PhosphorusActiveConcentration" M_doping )
(sdedr:define-constant-profile-region "RegionW1" "dopedW1" "GateWall1" )

;--- MolyWall1 ---
(sdedr:define-constant-profile "dopedW2" "PhosphorusActiveConcentration" M_doping )
(sdedr:define-constant-profile-region "RegionW2" "dopedW2" "GateWall2" )

;--- Gate ---
(sdedr:define-constant-profile "dopedGt" "PhosphorusActiveConcentration" M_doping )
(sdedr:define-constant-profile-region "RegionGt" "dopedGt" "Gate_Electrode" )




;--- Spacer ---
#(sdedr:define-constant-profile "dopedSpc" "PhosphorusActiveConcentration" Si_doping )
#(sdedr:define-constant-profile-region "RegionSpc" "dopedSpc" "Dielectric" )

;----- MESHING------;

(sdedr:define-refeval-window "RefEvalWin_1" "Cuboid"  (position 0.05 0.05 0.05)  (position 7 7 7) )

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
