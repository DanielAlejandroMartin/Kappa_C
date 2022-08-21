module variables
! number of neurons, time (the one use to compute), start time, and total time 
integer,parameter:: N=295
integer, parameter:: time=14400
integer,parameter:: Start_time=1
integer, parameter:: Totaltime=114099
integer,parameter:: convoltime=0
!box size and borders
real(4),parameter::LL=448 !Window Size
real:: NX, NY
real(4):: xmin, ymin, xmax, ymax
! Number of neurons in the box
integer Nin
integer t2
!Neuron Position
real(8),dimension(N,2):: Posicion
integer,dimension(N):: enabledlist=0
!Maximum distance that we compute
integer,parameter::maxdist=LL/2
!Activity and New Activity
real(4),dimension(N,Totaltime):: Activity
real(4),dimension(N,time+convoltime):: NewActivity 
real(4),dimension(N,time):: NewActivity2

real(8):: dist2x,dist2y,dist2

real(8),dimension(0:1000):: Pairs,Corr
real(8),dimension(N,N):: PairCorr

real(8),dimension(time):: actCONTINUOUS

real(4),parameter::BoxSize=512-60 !box size 
end module

program CCFdiscrete
use variables
implicit none
integer:: i,j,t,tiempos,ii,jj
integer:: nn
call JustOnce
posicion=posicion-30 !we cut 30 px in each border to avoid isseus with neurons close to the border


! we set the window borders
xmin=1
xmax=448
ymin=1
ymax=448
!Look for neurons inside the window
call PosicionRoutine

call system ('mkdir -p ResultsActivityFOLDER')
open(44,file="ResultsActivityFOLDER/ActivityALL.txt",status="unknown")
call ActivityRoutine

end program

!***********************************************************************

subroutine JustOnce
use variables
implicit none
integer:: t,i,ii,ct
integer tt

open(101,file="../../Files/coords.txt",status="unknown")
! We read the positions
do i=1,N
read(101,*) Posicion(i,1),posicion(i,2)
enddo
close(101)

open(102,file="../../Files/Sp.txt",status="unknown")
do i=1,N
read(102,*) Activity(i,:)
enddo
close(102)

NewActivity=0
do t=1,time
do i=1,N
if ( Activity(i,t+Start_time)>0.01) then
 NewActivity(i,t)=NewActivity(i,t)+1 
endif
enddo ! neurons
enddo !time
write(*,*) "End Read"
end subroutine

!****************************************************

subroutine ActivityRoutine
use variables
implicit none
integer:: i,ii

!open(44,file='timeseries4.txt',status='unknown')
do t2=1,time
actCONTINUOUS(t2)=0
do ii=1,Nin
i=enabledlist(ii)
actCONTINUOUS(t2)=actCONTINUOUS(t2)+NewActivity(i,t2)
enddo
write(44,*) t2,real(actCONTINUOUS(t2))
actCONTINUOUS(t2)=actCONTINUOUS(t2)/real(Nin) 
NewActivity2(:,t2)=NewActivity(:,t2)-actCONTINUOUS(t2)
enddo
close(44)
end subroutine

!***********************************************************************

subroutine PosicionRoutine
use variables
implicit none
integer:: i
! We Look for neurons inside the window
enabledlist=0
Nin=0
do i=1,N
if ((posicion(i,1).ge. xmin) .and. (posicion(i,1) .le. xmax)) then
if ((posicion(i,2).ge. ymin) .and. (posicion(i,2) .le. ymax)) then
Nin=Nin+1
enabledlist(Nin)=i
endif
endif
enddo
write(*,*) "End Positions"
end subroutine
