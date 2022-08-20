
module variables

!Parameters shared over the different subroutines
integer(2),parameter:: SystemL=1000 !size of the simulation box, fixed to 1000 on the paper (1 000 000 neurons)

integer,parameter:: nsize=5 !number of windows over which I record the number of Active neruons per frame
integer,dimension(nsize),parameter:: SystemW = (/ 500, 1000, 250, 125, 50 /)   !size of the observation Window size
integer,parameter:: t_start=5000 !We used 5000 in the article
integer,parameter:: t_end=100000  !We used 100000 in the article
integer,parameter:: t_interval=20  !We used 20 in the article


real(8),parameter:: Threshold=0.3180
integer:: Run=1 
integer:: seed=98176 
!Model Parameters
real(8),parameter:: r2=0.3  !d0
real(8),parameter:: r1=0.00001 !d0
integer,parameter:: Konectivity=24
real(8),parameter::pr=0.01d0
real(8),parameter::lambda=12.5 !d0


!each meuron sits on the corner of a square lattice
!Here we compute eac neuron's state:
integer(1),dimension(SystemL,SystemL)::element_state !0,1,2
integer(1),dimension(SystemL,SystemL)::element_next_state

!Network topology: for each neuron, we compute the identity of the neurons connecting to it
integer,dimension(SystemL,SystemL):: LinksIN !number of input connection of each neuron
integer(2),dimension(SystemL,SystemL,2*Konectivity):: my_neighborsX !x-coordinate of presynaptic neuron 
integer(2),dimension(SystemL,SystemL,2*Konectivity):: my_neighborsY !y-coordinate of presynaptic neuron
real(8),dimension(SystemL,SystemL,2*Konectivity):: WeightsIN_ij !Connection Weight

!observables
integer,dimension(nsize):: Activity
integer(1),dimension(SystemW(1),SystemW(1)):: photo
integer:: photo_counter=0


Real(8) p



!Filenames
character(len=10) :: file_name
character(len=10) :: file_name2
 
 
 real(8):: timet2,timet
end module


program main
use variables; use mt95
implicit none
integer::  step, x1,y1 
real(8):: mean !,mean2

!initialize random generator
call  genrand_init( put=seed)


!Make the network
call Make_network

!The next 3 lines are unnecessary for the dynamics. Deleting them will produce a different series of random numbers
do x1=1,systemL;do y1=1,systemL
call genrand_real2(p)
enddo;enddo



! Open Files. We save the state as unformatted since it is faster and weights less
write(file_name, '(i0)') Run
write(file_name2, '(i0)') int(Threshold*10000+0.5) !Add0.5 so that it is rounded properly



!open(103,file='AllSalida/salidaTr' // trim(adjustl(file_id2)) // &
! 'RUN'// trim(adjustl(file_id3)) // 'ETAPA' // trim(adjustl(file_id)) // '.dat',status="unknown")
 
call system ('mkdir -p ResultsActivity;mkdir -p ResultsState; mkdir -p Finished') !This line can be commented if you make the Folders/Directories on your own
open(102,file='ResultsActivity/ActivityRun'// trim(adjustl(file_name))// '-Tr0.'  &
& // trim(adjustl(file_name2))// '.dat' , status="unknown")
! We save the state as unformatted since it is faster and weights less
!Since format is unformatted, recl=SystemW*SystemW
open(103,file='ResultsState/StateRun' // trim(adjustl(file_name))// '-Tr0.'  &
& // trim(adjustl(file_name2))// '.dat' , access='DIRECT', recl=250000)

!Yo can change by '' open(103,file="ResultsState/State.dat",status="unknown") ''

call cpu_time(timet)
do step=1,t_end
call make_step

! check time consumption
if (step==1000*int(step/1000)) then
call cpu_time(timet2)
write(*,*) "step=", step, "time=", real(timet2-timet)
endif

write(102,*) step,Activity

element_state=element_next_state
		!Only save the state of one frame every 20 (=t_interval), after 5000 (=t_start) steps
        if ((step>t_start) .and. (step==t_interval*Int(step/t_interval))) then 
        call SaveState
        endif

enddo 

call flush(102)
call flush(103)
close(102)
close(103)

open(104,file='Finished/Run' // trim(adjustl(file_name))// '-Tr0.'  &
& // trim(adjustl(file_name2))// '.dat' , status="unknown")
write(104,*) "Everything Finished Properly"
write(*,*) "Everything Finished Properly"
call flush (104)
close(104)
end program

!***************************************************
!SUBROUTINE to save the state
!***************************************************

subroutine SaveState
use variables;
implicit none
integer:: x1,y1
photo_counter=photo_counter+1
do x1=1,SystemW(1); do y1=1,SystemW(1);
photo(x1,y1)=element_state(x1,y1)
enddo; enddo;
write(103,rec=photo_counter) photo
end subroutine



!***************************************************
!SUBROUTINE Make the network
!***************************************************

subroutine Make_network
use variables; use mt95
implicit none
integer(2):: i,j

integer(2):: x1,x2,y1,y2

linksIN=0
WeightsIN_ij=0
!Choose  output connections for each neuron 
do x1=1,systemL; do y1=1,systemL
!First choose trivial, nearest neighbors
do i=-2,2; do j=-2,2
!Avoid Connection to itself
if (i*i+j*j==0) goto 999


x2=x1+i;y2=y1+j
!Peridoc BCs
if (x2<1) x2=x2+systemL; if (x2>systemL) x2=x2-systemL
if (y2<1) y2=y2+systemL; if (y2>systemL) y2=y2-systemL


!Low probability of rewiring:
call genrand_real2(p) !replace it by other RNG
if (p<pr) then
	call genrand_real2(p) 
	x2=int2(p*systemL+1)
	call genrand_real2(p)
	y2=int2(p*systemL+1)
endif
!Add neuron (x1,y1) to the INPUT connections of neuron (x2,y2)
linksIN(x2,y2)=linksIN(x2,y2)+1
my_neighborsX(x2,y2,linksIN(x2,y2))=x1
my_neighborsY(x2,y2,linksIN(x2,y2))=y1
call genrand_real2(p) 
WeightsIN_ij(x2,y2,linksIN(x2,y2))= -log(p)/lambda

999 continue
enddo;enddo !24 neighbors
enddo;enddo !x1,y1

end subroutine

!***************************************************
!SUBROUTINE Make a Step
!***************************************************

subroutine make_step
use variables; use mt95
implicit none
integer:: x1,y1,neighborX,neighborY,ii
integer links
real(8) T

Activity=0
!We run over all neurons. Compute element_next_state from element_state
do x1=1,systemL
do y1=1,systemL

!If the neuron is refractary, attempt to make it susceptible.
if (element_state(x1,y1)==2) then;
call genrand_real2(p)
if (r2>p) element_next_state(x1,y1)=0
endif

!If it is active, sum to instantaneous activity and uptate to refractary
if (element_state(x1,y1)==1) then


do ii=1,nsize
if (max(x1,y1)<systemW(ii)+1) then
Activity(ii)=Activity(ii)+1
endif
enddo

element_next_state(x1,y1)=2
endif

!If it is susceptible, attempt to make it active
if (element_state(x1,y1)==0) then;
call genrand_real2(p)
if (r1>p) element_next_state(x1,y1)=1
T=0
do links=1, LinksIN(x1,y1)
neighborX=  my_neighborsX(x1,y1,links)
neighborY=  my_neighborsY(x1,y1,links)
if (element_state(neighborX,neighborY)==1) T=T+WeightsIN_ij(x1,y1,links)
enddo
If (T>Threshold) element_next_state(x1,y1)=1

endif

enddo; enddo !End neuron loop

end subroutine

