C     path:      %P%
C     revision:  $Revision: 7.02 $
C     created:   $Date: 2003/02/10 21:21:17 $  
C     presently: %H%  %T%
c_______________________________________________________________________

      SUBROUTINE LBLDAT(HDATE)                                          
C                                                                       
      character*8 hdate
C                                                                       
      CHARACTER GDATE*10                                                
C                                                                       
      INTEGER*4 IARRAY(8)                                               

      COMMON /CVRUTL/ HANUTL,HVRUTL
C
      CHARACTER*18 HNAMUTL,HVRUTL
C

C
C     ASSIGN NAME and CVS VERSION NUMBER TO MODULE 
C
      HNAMUTL= '       util_dos.f:'
      HVRUTL = '$Revision: 7.02 $' 

C                                                                       
      CALL DATIM(IARRAY)                                                
c     
      IARRAY(8)=iarray(8)-(int(iarray(8)/100))*100
      WRITE (GDATE,900) IARRAY(8),IARRAY(7),IARRAY(6)                   
C                                                                       
      READ (GDATE,901) HDATE                                            
C                                                                       
C     GDATE AND FORMAT ARE FOR CYBER AND CRAY                           
C                                                                       
C       -- CYBER REQUIRES FORMAT (1X,A8)                                
C       -- CRAY  REQUIRES FORMAT (A8)                                   
C                                                                       
C     CHANGE THESE TO WORD SIZE AND FORMAT OF ROUTINE DATE              
C                                                                       
      RETURN                                                            
C                                                                       
  900 FORMAT (   I2.2,2('/',I2.2))
C>901 FORMAT (1X,A8)                                                    
  901 FORMAT (A8)                                                       
C                                                                       
      END                                                               
      SUBROUTINE FTIME (HTIME)                                          
C                                                                       
      DOUBLE PRECISION HTIME                                            
C                                                                       
      CHARACTER GTIME*10                                                
C                                                                       
      INTEGER*4 IARRAY(8)                                               
C                                                                       
C>>   CALL CLOCK (GTIME)                                                
C>VAX CALL TIME (GTIME)                                                 
      CALL DATIM (IARRAY)                                               
      WRITE (GTIME,900) IARRAY(5),IARRAY(4),IARRAY(3)                   
C                                                                       
      READ (GTIME,901) HTIME                                            
C                                                                       
C     GTIME AND FORMAT ARE FOR CYBER AND CRAY                           
C                                                                       
C       -- CYBER REQUIRES FORMAT (1X,A8)                                
C       -- CRAY  REQUIRES FORMAT (A8)                                   
C                                                                       
C     CHANGE THESE TO WORD SIZE AND FORMAT OF ROUTINE GTIME             
C                                                                       
      RETURN                                                            
C                                                                       
  900 FORMAT (   I2,2(':',I2.2))                                        
C>901 FORMAT (1X,A8)                                                    
  901 FORMAT (A8)                                                       
C                                                                       
      END                                                               
      SUBROUTINE CPUTIM (TIME)                                          
C                                                                       
      COMMON /TIMIN/ A1                                                 
C                                                                       
      REAL*4 ETIME                                                      
      INTEGER*4 ICODE                                                   
C                                                                       
C     THIS SUBROUTINE OBTAINS CPU TIME                                  
C                                                                       
      IF (A1.LT.0.) THEN                                                
C>>      CALL SECOND (TIME)                                             
C>VAX    A1 = SECNDS(0.0)                                               
         CALL CPUTIME(ETIME,ICODE)                                      
         A1=ETIME                                                       
         TIME=0                                                         
      ELSE                                                              
C>>      CALL SECOND (TIME)                                             
C>VAX    TIME = SECNDS(A1)                                              
         CALL CPUTIME(ETIME,ICODE)                                      
         STIME=ETIME-A1                                                 
         TIME=STIME*1.E-06                                              
C        TIME = ETIME(TARRAY)                                           
      ENDIF                                                             
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
      BLOCK DATA BTIM                                                   
C                                                                       
      COMMON /TIMIN/ A1                                                 
C                                                                       
      DATA A1 /-1. /                                                    
C                                                                       
      END                                                               

      SUBROUTINE BUFIN (IFILE,IEOF,IARRAY,IWORDS)                       
C                                                                       
C     THIS SUBROUTINE BUFFERS IN (READS) IWORDS INTO  IARRAY STARTING   
C     AT LOCATION IARRAY                                                
C                                                                       
C     IFILE IS THE FILE DESIGNATION                                     
C                                                                       
      DATA i_4 / 4 /    
C                                                                       
      DIMENSION IARRAY(IWORDS)                                          

      IEOF = 1                                                          
C                                                                       
C#    BUFFER IN (IFILE,1) (IARRAY(ILO),IARRAY(IHI))                     
C#    IF (UNIT(IFILE).EQ.0.) GO TO 10                                   
C                                                                       
      READ (IFILE,END=10) IARRAY                                        
      ITEST = MIN(IWORDS,i_4)                                           
      IF (IARRAY(ITEST).EQ.-99) IEOF = -99                              
C                                                                       
      RETURN                                                            
C                                                                       
   10 IEOF = 0                                                          
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c         note the name change

      SUBROUTINE BUFIN_sgl (IFILE,IEOF,IARRAY,IWORDS)
C
C     THIS SUBROUTINE BUFFERS IN (READS) IWORDS INTO  IARRAY STARTING
C     AT LOCATION IARRAY
C
C     IFILE IS THE FILE DESIGNATION
C                                  

      implicit integer*4 (i-n)
      implicit real*4    (a-h,o-z)

      DATA i_4 / 4 /    

      DIMENSION IARRAY(IWORDS)
C                                                                       
      IEOF = 1             
C                          
C#    BUFFER IN (IFILE,1) (IARRAY(ILO),IARRAY(IHI))
C#    IF (UNIT(IFILE).EQ.0.) GO TO 10              
C                                               
      READ (IFILE,END=10) IARRAY
      ITEST = MIN(IWORDS,i_4)                 
      IF (IARRAY(ITEST).EQ.-99) IEOF = -99      
C                                               
      RETURN                                    
C                                               
   10 IEOF = 0                                  
C                                               
      RETURN                                    
C                                               
      END                                       
c_______________________________________________________________________

      SUBROUTINE BUFOUT (IFILE,IARRAY,IWORDS)                           
C                                                                       
C     THIS SUBROUTINE BUFFERS OUT (WRITES) IWORDS FROM IARRAY STARTING  
C     AT LOCATION IARRAY                                                
C                                                                       
C     IFILE IS THE FILE DESIGNATION                                     
C                                                                       
      DIMENSION IARRAY(IWORDS)                                          
C                                                                       
C#    BUFFER OUT (IFILE,1) (IARRAY(ILO),IARRAY(IHI))                    
C#    IF (UNIT(IFILE).EQ.0.) STOP ' ERROR IN BUFOUT '                   
C                                                                       
      WRITE (IFILE) IARRAY                                              
C                                                                       
      RETURN                                                            
C                                                                       
      END                                                               
c_______________________________________________________________________

      SUBROUTINE BUFOUT_sgl (IFILE,IARRAY,IWORDS)
C                                                 
C     THIS SUBROUTINE BUFFERS OUT (WRITES) IWORDS FROM IARRAY STARTING
C     AT LOCATION IARRAY                                                
C                                                                     
C     IFILE IS THE FILE DESIGNATION                                   
C                                                                     
c
      implicit integer*4 (i-n)
      implicit real*4    (a-h,o-z)
c
      DIMENSION IARRAY(IWORDS)
C                                                   
C#    BUFFER OUT (IFILE,1) (IARRAY(ILO),IARRAY(IHI))
C#    IF (UNIT(IFILE).EQ.0.) STOP ' ERROR IN BUFOUT '
C                                                    
      WRITE (IFILE) IARRAY
C                                                    
      RETURN                                         
C                                                    
      END                                            
