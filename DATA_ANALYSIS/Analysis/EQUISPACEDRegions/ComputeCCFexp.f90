module variables
! number of neurons, time (the one use to compute), start time, and total time 
integer,parameter:: N=295
integer, parameter:: time=14400
integer,parameter:: Start_time=1
integer, parameter:: Totaltime=114099
integer,parameter:: convoltime=10
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
real(8):: norm
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

DO NX=1,BoxSize/LL,0.25
DO NY=1,BoxSize/LL,0.25
! we set the window borders
xmin=1+(NX-1)*LL
xmax=(NX)*LL
ymin=1+(NY-1)*LL
ymax=(NY)*LL
!Look for neurons inside the window
call PosicionRoutine
write(*,*) Nin,xmin,xmax,ymin,ymax
call system ('mkdir -p ResultsCorrelFOLDER')
open(33,file="ResultsCorrelFOLDER/AvgCCFALL.txt",status="unknown")
IF (Nin>10) THEN !avoid windows with very few neurons
IF (max(xmax,ymax)<Boxsize+1) THEN !avoid windows that lie outisde the system
call ActivityRoutine

!--COMPUTE PAIR CORRELATION--------------------------
PairCorr=0
tiempos=0
DO t=50,time-50
tiempos=tiempos+1
do ii=1,Nin
i=enabledlist(ii)
do jj=ii,Nin;
j=enabledlist(jj)
!write(*,*) i,j
PairCorr(i,j)=PairCorr(i,j)+NewActivity2(i,t)*NewActivity2(j,t)
enddo !JJ
enddo !ii
!ENDIF !act>0
ENDDO !tiempo
PairCorr=PairCorr/real(tiempos)
!--ASSIGN PAIR CORRELATION TO A GIVEN DISTANCE	---------------------

do ii=1,Nin
i=enabledlist(ii)
do jj=ii,Nin;
j=enabledlist(jj)
dist2=(posicion(i,1)-posicion(j,1))**2
dist2=dist2+(posicion(i,2)-posicion(j,2))**2
dist2=sqrt(dist2)
!write(*,*) dist2,Corr(int(dist2+0.5))
Pairs(int(dist2+0.5))=Pairs(int(dist2+0.5))+1
Corr(int(dist2+0.5))=Corr(int(dist2+0.5))+PairCorr(i,j)
enddo
enddo

ENDIF 
ENDIF !Nin>10

ENDDO !Nx
ENDDO !Ny

norm=real(corr(0)/real(pairs(0)))
do i=0,maxdist
if (pairs(i)>0) then
 write(33,*) i,real(corr(i)/real(pairs(i)))/norm,real(corr(i)),int(pairs(i)+0.01)
endif
enddo
call flush(33)
close (33)

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
do ct=0,convoltime!convolve with rectangular Function
 NewActivity(i,t+ct)=NewActivity(i,t+ct)+1 
enddo
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
!write(44,*) real(actCONTINUOUS(t2)), real(actCONTINUOUS(t2))/real(Nin)
actCONTINUOUS(t2)=actCONTINUOUS(t2)/real(Nin) 
NewActivity2(:,t2)=NewActivity(:,t2)-actCONTINUOUS(t2)
enddo
!close(44)
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
