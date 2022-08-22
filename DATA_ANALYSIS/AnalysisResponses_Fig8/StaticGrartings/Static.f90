program Select
implicit none
integer,parameter:: N=295
integer,parameter:: T=114099
integer,parameter:: Nmovies=6
integer,parameter:: Nblocks=3
integer:: movie, Freq, Phase, StartT,EndT

real(8),dimension(Nmovies,N,Nblocks):: Selectivity,SelectivityPREV

real(8),dimension(Nmovies,N):: SelectivityAVG,SelectivityPREVAVG
integer,dimension(Nmovies,Nblocks):: TotalShows
integer,dimension(0:T-1,Nmovies):: movieVector
integer,dimension(N):: Spikes
integer:: tt,t2,i,j,st,tblock
integer,parameter:: startdelay=0
integer,parameter:: enddelay=0

!ThirdPart: DSI computation
real:: maxR, maxIndex, ortogIndex, ortogR,dsi

integer:: V1,V2

TotalShows=0
Selectivity=0
SelectivityAVG=0

SelectivityPREV=0
SelectivityPREVAVG=0


movieVector=-10
open(101,file='ImprovedStatic.txt', status='unknown')
open(202,file='../0-SeriesProcessing/SpTBIN.txt', status='unknown')



open(400,file='DSI.txt',status='unknown')
open(401,file='DSI1.txt',status='unknown')
open(402,file='DSI2.txt',status='unknown')
open(403,file='DSI3.txt',status='unknown')



do tt=1,5808
read(101,*) movie, V1,V2, StartT,EndT

do t2=StartT+startdelay, ENdT+enddelay
movieVector(t2,movie) = 1
enddo
do t2=2*StartT-EndT-1, StartT+startdelay-1
movieVector(t2,movie) = -1
enddo

enddo

!Second Part

do tt=0,T-1
tblock=2
if (tt< 40000) tblock=1
if (tt> 80000) tblock=3
read(202,*) Spikes

do movie= 1, Nmovies

if (movieVector(tt,movie)==1) then
TotalShows(movie,tblock)=TotalShows(movie,tblock)+1
Selectivity(movie,:,tblock)=Selectivity(movie,:,tblock)+Spikes
SelectivityAVG(movie,:)=SelectivityAVG(movie,:)+Spikes
endif

if (movieVector(tt,movie)==-1) then
SelectivityPREV(movie,:,tblock)=SelectivityPREV(movie,:,tblock)+Spikes
SelectivityPREVAVG(movie,:)=SelectivityPREVAVG(movie,:)+Spikes
endif

enddo


enddo
!Normalization
do i=1,Nmovies
do tblock=1,Nblocks
Selectivity(i,:,tblock)=Selectivity(i,:,tblock)/real(TotalShows(i,tblock))
SelectivityPREV(i,:,tblock)=SelectivityPREV(i,:,tblock)/real(TotalShows(i,tblock))
enddo
SelectivityAVG(i,:)=SelectivityAVG(i,:)/real(TotalShows(i,1)+TotalShows(i,2)+TotalShows(i,3))
SelectivityPREVAVG(i,:)=SelectivityPREVAVG(i,:)/real(TotalShows(i,1)+TotalShows(i,2)+TotalShows(i,3))
enddo


!END

!do i=1,n
!write(333,*) Selectivity(:,i),i
!enddo

!No more use
!do i=1,Nmovies
!write(301,*) Selectivity(i,:,1),SelectivityPREV(i,:,1)
!write(302,*) Selectivity(i,:,2),SelectivityPREV(i,:,2)
!write(303,*) Selectivity(i,:,3),SelectivityPREV(i,:,3)
!write(300,*) SelectivityAVG(i,:)
!write(66,*) TotalShows(i,1),TotalShows(i,2),TotalShows(i,3),SelectivityAVG(i,289)
!enddo
!Third Part

do i=1,N
maxR=SelectivityAVG(1,i)-SelectivityPREVAVG(1,i)
maxIndex=1
do j=2,Nmovies
if (SelectivityAVG(j,i)-SelectivityPREVAVG(j,i) > maxR) then
maxR=SelectivityAVG(j,i)-SelectivityPREVAVG(j,i)
maxindex=j
endif
enddo
write(400,*) i,maxindex,SelectivityAVG(maxindex,i),SelectivityPREVAVG(maxindex,i),maxR

do tblock=1,3

write(400+tblock,*) i,maxindex, Selectivity(maxindex,i,tblock),SelectivityPREV(maxindex,i,tblock)
enddo

enddo


end program
