with Ada.Text_IO; use Ada.Text_IO;

with RISCV.Types; use RISCV.Types;
with RISCV.CSR; use RISCV.CSR;

with System.Storage_Elements; use System.Storage_Elements;

with System.Machine_Code; use System.Machine_Code;
with System; use System;

with Ada.Text_IO; use Ada.Text_IO;

package body Interrupts is

   procedure Default_Handler (Hart : Harts_T; Trap_Code : Trap_Code_T) is
   begin
      Put_Line ("Default handler. Called from hart: " & Hart'Image & 
                " with trap code: " & Trap_Code'Image);
   end Default_Handler;

   type Handlers_T is array (Harts_T, Trap_Code_T) of Interrupt_Handler;
   Handlers : Handlers_T := (others => (others => Default_Handler'Access));

   procedure Install_Uart0_Rx_Interrupt_Handler (Hart: Harts_T; Handler : Interrupt_Handler) is
   begin
      Handlers (Hart, Fast_Interrupt_2) := Handler;
   end Install_Uart0_Rx_Interrupt_Handler;

   procedure Call_Handler is
      Hart_Id : Harts_T := Harts_T (RISCV.CSR.MHARTID.Read); 
      Trap_Code : Trap_Code_T := Trap_Code_T'Enum_Val (RISCV.CSR.MCAUSE.Read);
   begin
      Handlers (Hart_Id, Trap_Code).all (Hart_Id, Trap_Code);
   end Call_Handler;

   function Is_Exception return Boolean is
      (Shift_Right(RISCV.CSR.MCAUSE.Read, 31) = 0 and 
       Trap_Code_T'Enum_Val (RISCV.CSR.MCAUSE.Read) /= Instruction_Access);

   procedure Compute_Return_Address is
      Epc : UInt32 := RISCV.CSR.MEPC.Read + 4;
      ISA : UInt32 := RISCV.CSR.MISA.Read;
   begin
      if (ISA and 2#100#) = 1 then
         declare
            TINST : UInt32 := RISCV.CSR.MTINST.Read;
         begin
            if (TINST and 2#11#) /= 3 then
               Epc := @ - 2;
            end if;
         end;
      end if;
      RISCV.CSR.MEPC.Write (Epc);
   end Compute_Return_Address;

   procedure Isr with
     Export, Convention => C, External_Name => "isr";

   procedure Isr is
   begin
      Call_Handler;
      if Is_Exception then
         Compute_Return_Address;
      end if;
   end Isr;

   procedure Trap_Entry
   with Import, Convention => C, External_Name => "trap_entry";

   procedure Init is
   begin
      RISCV.CSR.Mstatus.Set_Bits (2#11000_00000000#);
      RISCV.CSR.Mtvec.Write (UInt32 (To_Integer (trap_entry'Address)));
      RISCV.CSR.Mie.Write (0);
      Asm ("fence");
   end Init;

   procedure Global_Machine_Interrupt_Enable is
   begin
      Mstatus.Set_Bits (2#1000#);
   end Global_Machine_Interrupt_Enable;

end Interrupts;