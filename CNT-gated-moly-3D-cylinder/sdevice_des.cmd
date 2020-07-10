# SDEVICE code to run the simulation. #

Device JFET {

Electrode{
{name="D" voltage=0.0 Schottky Barrier = 0.33 
eRecVelocity = 3766000 hRecVelocity = 3766000}
{name="S" voltage=0.0}
}

File{
Grid="@tdr@"
Plot="@tdrdat@"
Current="@plot@"
*Output="@log@"
parameter="@parameter@"
}

Physics (Material="Moly"){
Mobility( DopingDep HighFieldSaturation Enormal )
EffectiveIntrinsicDensity( OldSlotboom )
Recombination( SRH(DopingDep) )
eQuantumPotential
Traps(
	(eNeutral Table=(-0.1 1.2e18 -0.2 6e18 -0.3 6e18) fromCondBand
	eXsection=1e-9 hXsection=1e-10)
  )
}

Physics (Material="CNT"){
Mobility( DopingDep HighFieldSaturation Enormal )
EffectiveIntrinsicDensity( OldSlotboom )
Recombination( SRH(DopingDep) )
eQuantumPotential
}
}

Device Ionic {

Electrode{
{name="ID" voltage=-0.1}
{name="IS" voltage=0.0}
{name="G" voltage=0.0 WorkFunction=@WK@}
}

File{
Grid="@tdr@"
Plot="@tdrdat@"
Current="@plot@"
*Output="@log@"
parameter="@parameter@"
}

Physics (Material="Moly"){
Mobility( DopingDep HighFieldSaturation Enormal )
EffectiveIntrinsicDensity( OldSlotboom )
Recombination( SRH(DopingDep) )
eQuantumPotential
Traps(
	(eNeutral Table=(-0.1 1.2e18 -0.2 6e18 -0.3 6e18) fromCondBand
	eXsection=1e-9 hXsection=1e-10)
  )
}

Physics (Material="CNT"){
Mobility( DopingDep HighFieldSaturation Enormal )
EffectiveIntrinsicDensity( OldSlotboom )
Recombination( SRH(DopingDep) )
eQuantumPotential
}
}


Math{
-CheckUndefinedModels
Number_Of_Threads=4
Extrapolate
Derivatives
* Avalderivatives
RelErrControl
Digits=5
ErRef(electron)=1.e10
ErRef(hole)=1.e10
Notdamped=50
Iterations=150
Directcurrent
Method=ParDiSo
Parallel= 2
NaturalBoxMethod
}

Plot{
eDensity hDensity
eCurrent hCurrent
TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
eMobility hMobility
eVelocity hVelocity
eEnormal hEnormal
ElectricField/Vector Potential SpaceCharge
eQuasiFermi hQuasiFermi
Potential Doping SpaceCharge
SRH Auger
AvalancheGeneration
DonorConcentration AcceptorConcentration
Doping
eGradQuasiFermi/Vector hGradQuasiFermi/Vector
eEparallel hEparalllel
eTrappedCharge
BandGap
BandGapNarrowing
Affinity
ConductionBand ValenceBand
eQuantumPotential
}

System {

Vsource_pset vd (Vd 0) { dc = 0.0 }
Vsource_pset vi (Vi 0) { dc = -0.1 }
Vsource_pset vg (Vg 0) { dc = 0.0 }
 
JFET jfet ( "S"=0 "D"=Vd )
Ionic ionic ( "IS"=0 "ID"=Vi "G"=Vg )

Plot "n@node@_sys_des.plt" (time() v(Vi) v(Vd) v(Vg) i(jfet,Vd) i(ionic,Vi), i(jfet, 0), i(ionic,0))
}


Solve {

Coupled ( Iterations= 1060){ Poisson eQuantumPotential Electron Hole Contact Circuit}


Quasistationary(
InitialStep= 1e-5 Increment= 1.2
MinStep= 1e-199 MaxStep= 0.95
#Goal{Parameter= vd.dc Voltage=@Vd@ }

){ Coupled { jfet.poisson jfet.electron jfet.hole jfet.contact ionic.poisson ionic.electron ionic.hole ionic.contact circuit}}

Quasistationary(
InitialStep= 1e-5 Increment= 1.2
MinStep= 1e-199 MaxStep= 0.95
#Goal {Parameter= vi.dc Voltage=@Vi@ }
Goal {Parameter= vg.dc Voltage=@Vg@ }
){ Coupled { jfet.poisson jfet.electron jfet.hole jfet.contact ionic.poisson ionic.electron ionic.hole ionic.contact circuit} }
}
#----------------------------------- END --------------------------------------#


