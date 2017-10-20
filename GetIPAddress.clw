
   PROGRAM

   MAP
   END

  include('NetMap.inc'),once
  include('NetTalk.inc'),once
  include('NetWeb.inc'),once

  include('cwsynchc.inc'),once  ! added by NetTalk
  include('StringTheory.Inc'),ONCE
  
   
intThread LONG 

Window               WINDOW(''),AT(,,1,1),FONT('Segoe UI',8),GRAY
                     END
 
ThisWebClientIPIFY   CLASS(NetWebClient)       
ErrorTrap              PROCEDURE(string errorStr,string functionName),DERIVED
Init                   PROCEDURE(uLong Mode=NET:SimpleClient),DERIVED
PageReceived           PROCEDURE(),DERIVED
                     END
                  
                     
strIPAddressThisTime STRING(256)  
gCRMIPAddress        STRING(256)  ! IP last time
  
  CODE

  OPEN(Window)
                                               
  ThisWebClientIPIFY.SuppressErrorMsg = 1     
  ThisWebClientIPIFY.init()
  IF ThisWebClientIPIFY.error <> 0   
  END
  
  intThread = THREAD() 
  CLEAR(strIPAddressThisTime)
  ThisWebClientIPIFY.Get('https://api.ipify.org')
  
  ACCEPT
    ThisWebClientIPIFY.TakeEvent()               
    
    CASE EVENT()
       OF EVENT:Notify
          SETCLIPBOARD(CLIP(strIPAddressThisTime))
          BREAK    
    END 
    
  END
  

  CLOSE(Window)
  NetCloseCallBackWindow() 
  RETURN
  

!------------------------------------------------------------------------  
ThisWebClientIPIFY.PageReceived PROCEDURE
!------------------------------------------------------------------------

  CODE
  PARENT.PageReceived
     ThisWebClientIPIFY.RemoveHeader() 
     strIPAddressThisTime = CLIP(ThisWebClientIPIFY.ThisPage.GetValue())
     NOTIFY(1,intThread,'') 
     RETURN 
   
   
!------------------------------------------------------------------------   
ThisWebClientIPIFY.Init PROCEDURE(uLong Mode=NET:SimpleClient)
!------------------------------------------------------------------------

  CODE
  PARENT.Init(Mode)
  
!------------------------------------------------------------------------
ThisWebClientIPIFY.ErrorTrap PROCEDURE(string errorStr,string functionName)
!------------------------------------------------------------------------

  CODE
  PARENT.ErrorTrap(errorStr,functionName)  