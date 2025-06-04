-- Symmetric multiprocessing (SMP) library in Ada -- 

with RISCV.CSR;
with neorv32; use neorv32;
with neorv32.SYSINFO; use neorv32.SYSINFO;
with neorv32.CLINT; use neorv32.CLINT;
with System;
with System.Storage_Elements; use System.Storage_Elements;
with Interfaces; use Interfaces;

package body SMP is 
   function smp_launch(Entry_Point : Function_T; Stack_Memory : Stack_T) return SMP_T is 
   Stack_Begin        : UInt32 := UInt32 (To_Integer (Stack_Memory'Address));
   Stack_Memory_size  : UInt32 := Stack_Memory'Size / 8; -- in bytes
   Stack_End          : UInt32 := (Stack_Begin + Stack_Memory_size - 1) and 16#FFFFFFF0#; -- in bytes
   Timeout            : UInt32 := 2048;
   begin
      if smp_get_hart_id /= 0 -- this can be executed on core 0 only  
      or SYSINFO_Periph.MEM.SYSINFO_MISC_DMEM < 2 -- core not available 
      or SYSINFO_Periph.SOC.SYSINFO_SOC_IO_CLINT = 0 then -- we need the CLINT
         return -1;
      end if; 

      CLINT_Periph.MTIMECMP1_LOW := (Stack_End); -- top of core's stack
      CLINT_Periph.MTIMECMP1_HI := UInt32(To_Integer (Entry_Point'Address)); -- entry point

      -- start core by trigerring its software interrupt
      CLINT_Periph.MSWI1.HART1 := 1;

      -- wait for core to start
      while (Timeout /= 0) loop 
         if CLINT_Periph.MSWI1.HART1 = 0 then 
            return 0;
         end if;
         Timeout := Timeout - 1;
      end loop;

      return -2; -- core did not respond
   end smp_launch;

   function smp_get_hart_id return Harts_T is
   begin
      return Harts_T (RISCV.CSR.MHARTID.Read);
   end smp_get_hart_id;

end SMP;