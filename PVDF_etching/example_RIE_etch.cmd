define_structure material=Silicon point_min= {0 0 0} point_max= {0.1 0.1 0.01}

fill material=Oxide thickness=0.15
fill material=Photoresist thickness=0.02
save

define_shape type=cube point_min= {0.05 0.05 0.16} point_max= {0.1 0.1 0.18} \
	name=subtract
etch shape=subtract

save

define_etch_machine model=rie2 exponent=100

add_material material=Photoresist rate=0.0 anisotropy=0.0 sticking=1.0 \
	reflection=@refl@
add_material material=Oxide rate=0.1 anisotropy=0.8 sticking=0.5 \
	reflection=@refl@
  
let parallel=true

etch spacing={0.0025 0.0025 0.0025} time=0.3 plot_interval=0.1 \
	engine=monte_carlo integration_samples=700
  
save
