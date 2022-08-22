program Binary
implicit none
integer,parameter:: N=295
integer,parameter:: T=114099
real,dimension(N,T)::SpikeProb
integer,dimension(N,T)::SpikeBIN
integer:: i,tt

SpikeProb=0
SpikeBIN=0

!call system (' datamash -W transpose < ../../Files/Sp.txt  > SpT.txt')
!you may need to specify field delimiter

open(111,file='SpT.txt',status='unknown')
open(122,file='SpTBIN.txt',status='unknown')

do tt=1,T
read(111,*) SpikeProb(:,tt)

do i = 1,N
if (Spikeprob(i,tt)> 0.01) then
SpikeBIN(i,tt)=1
!if (Spikeprob(i,tt)> 1.01) write(*,*) "TOO HIGH", Spikeprob(i,tt), i, tt
!if (Spikeprob(i,tt)> 2.01) write(*,*) "TOO HIGH", Spikeprob(i,tt), i, tt

endif
enddo
write(122,*) SpikeBIN(:,tt)

enddo


end program
