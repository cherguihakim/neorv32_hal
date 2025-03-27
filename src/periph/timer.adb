with neorv32.GPTMR; use neorv32.GPTMR;
with Neorv32.Uart0;
with Uart0;
with Ada.Text_IO; use Ada.Text_IO;
with Sysinfo; 

package body Timer is
   procedure Init is
      begin
         GPTMR_PERIPH.CTRL.GPTMR_CTRL_EN := 1;
         GPTMR_Periph.CTRL.GPTMR_CTRL_IRQ_CLR := 1;
      end;
   
   procedure Reset is
   begin
      GPTMR_Periph.CTRL.GPTMR_CTRL_EN := 0;
      GPTMR_Periph.CTRL.GPTMR_CTRL_PRSC := 0;
      GPTMR_Periph.CTRL.GPTMR_CTRL_MODE := 0;
      GPTMR_Periph.CTRL.GPTMR_CTRL_IRQ_CLR := 1;
      GPTMR_Periph.CTRL.GPTMR_CTRL_IRQ_PND := 0;
      GPTMR_PERIPH.COUNT := 0;
      GPTMR_Periph.THRES := 0;
   end;

   procedure Disable is
   begin
      GPTMR_PERIPH.CTRL.GPTMR_CTRL_EN := 0;
   end;

   -- Whenever the counter register COUNT equals the programmable threshold value THRES 
   -- the module’s interrupt signal becomes pending (indicated by GPTMR_CTRL_IRQ_PND being set). 
   -- In this case the COUNT register is automatically reset and restarts incrementing from zero. 
   -- Note that a pending interrupt has to be cleared manually by writing a 1 to GPTMR_CTRL_IRQ_CLR.

   procedure Wait(ms : UInt32) is
      clk_freq : constant Uint32 := Uint32(Sysinfo.Clk);
      prescaler : constant UInt3 := 4;
      threshold  : UInt32 := (clk_freq / (2**(Integer(Prescaler) + 1))) * ms / 1000;
      thres : UInt32 := 10;
   begin
      GPTMR_Periph.CTRL.GPTMR_CTRL_PRSC := prescaler;
      GPTMR_Periph.THRES := threshold;
      while GPTMR_Periph.COUNT /= GPTMR_Periph.THRES loop
         -- Put_Line("Waiting for timer to expire, still " & GPTMR_Periph.COUNT'Image & " cycles to go");
         null;
      end loop;
      GPTMR_Periph.CTRL.GPTMR_CTRL_IRQ_CLR := 1;
      Reset;
   end;

end Timer;