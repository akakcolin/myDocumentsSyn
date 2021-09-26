subroutine EnergyForces(Pos, L, rc, PEnergy, Forces, Dim, NAtom)
  implicit none
  integer, intent(in) :: Dim, NAtom
  real(8), intent(in), dimension(0:NAtom-1, 0:Dim-1) :: Pos
  real(8), intent(in) :: L, rc
  real(8), intent(out) :: PEnergy
  real(8), intent(inout), dimension(0:NAtom-1, 0:Dim-1) :: Forces
  !f2py intent(in, out) :: Forces
  real(8), dimension(Dim) :: rij, Fij, Posi
  real(8) :: d2, id2, id6, id12
  real(8) :: rc2, Shift
  integer :: i, j
  PEnergy = 0.
  Forces = 0.
  Shift = -4. * (rc**(-12) - rc**(-6))
  rc2 = rc * rc
  do i = 0, NAtom - 1
     !store Pos(i,:) in a temporary array for faster access in j loop
     Posi = Pos(i,:)
     do j = i + 1, NAtom - 1
        rij = Pos(j,:) - Posi
        rij = rij - L * dnint(rij / L)
        !compute only the squared distance and compare to squared cut
        d2 = sum(rij * rij)
        if (d2 > rc2) then 
           cycle
        end if
        id2 = 1. / d2 !inverse squared distance
        id6 = id2 * id2 * id2 !inverse sixth distance
        id12 = id6 * id6 !inverse twelvth distance
        PEnergy = PEnergy + 4. * (id12 - id6) + Shift
        Fij = rij * ((-48. * id12 + 24. * id6) * id2)
        Forces(i,:) = Forces(i,:) + Fij
        Forces(j,:) = Forces(j,:) - Fij
     enddo
  enddo
end subroutine EnergyForces

subroutine VVIntegrate(Pos, Vel, Accel, L, CutSq, dt, KEnergy, PEnergy, Dim, NAtom)
  implicit none
  integer, intent(in) :: Dim, NAtom
  real(8), intent(in) :: L, CutSq, dt
  real(8), intent(inout), dimension(0:NAtom-1, 0:Dim-1) :: Pos, Vel, Accel
  !f2py intent(in, out) :: Pos, Vel, Accel
  real(8), intent(out) :: KEnergy, PEnergy
  external :: EnergyForces
  Pos = Pos + dt * Vel + 0.5 * dt*dt * Accel
  Vel = Vel + 0.5 * dt * Accel
  call EnergyForces(Pos, L, CutSq, PEnergy, Accel, Dim, NAtom)
  Vel = Vel + 0.5 * dt * Accel
  KEnergy = 0.5 * sum(Vel*Vel)
end subroutine VVIntegrate

