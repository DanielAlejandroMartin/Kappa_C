program Ava
implicit none
integer:: i,act,t, area,prev_act
integer:: c_threshold
integer,parameter:: time=95000 !Change this number if larger files are used
integer tt
integer sample
real actr

integer reason

open(100,file='Tvalue.dat',status='unknown')
read(100,*) c_threshold
close(100)
!write(*,*) U, "Prog"

open(99,file='InputFile.dat',status='unknown')
read(99,*) tt, actr
act=int(actr+0.5)


open(103,file='OutputFile.dat',status="unknown")



do i=2,time
prev_act=act
read(99,*,iostat=reason) tt,actr
if (reason<0) then
write(*,*) "End of File"
goto 222
endif
act=int(actr+0.5)
!write(*,*) act, actant, i,u

if (act> c_threshold) then
area=area+act-c_threshold
t=t+1
else
if (prev_act>c_threshold) then
write(103,*) area,t
!write(*,*) area,t
endif
area=0
t=0
endif
enddo !time

222 continue

call flush(103)
close(103)

end Program

