pragma Style_Checks (Off);

--  This spec has been automatically generated from neorv32.svd

pragma Restrictions (No_Elaboration_Code);

with System;

--  Core local interruptor
package neorv32.CLINT is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype MSWI0_HART0_Field is neorv32.Bit;

   --  Machine software interrupt
   type MSWI0_Register is record
      --  Hart 0
      HART0         : MSWI0_HART0_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : neorv32.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MSWI0_Register use record
      HART0         at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   subtype MSWI1_HART1_Field is neorv32.Bit;

   --  Machine software interrupt
   type MSWI1_Register is record
      --  Hart 1
      HART1         : MSWI1_HART1_Field := 16#0#;
      --  unspecified
      Reserved_1_31 : neorv32.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MSWI1_Register use record
      HART1         at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Core local interruptor
   type CLINT_Peripheral is record
      --  Machine software interrupt
      MSWI0         : aliased MSWI0_Register;
      --  Machine software interrupt
      MSWI1         : aliased MSWI1_Register;
      --  Machine timer compare low word; hart0
      MTIMECMP0_LOW : aliased neorv32.UInt32;
      --  Machine timer compare low word; hart0
      MTIMECMP0_HI  : aliased neorv32.UInt32;
      --  Machine timer compare low word; hart1
      MTIMECMP1_LOW : aliased neorv32.UInt32;
      --  Machine timer compare low word; hart1
      MTIMECMP1_HI  : aliased neorv32.UInt32;
      --  Machine timer low word
      MTIME_LOW     : aliased neorv32.UInt32;
      --  Machine timer high word
      MTIME_HI      : aliased neorv32.UInt32;
   end record
     with Volatile;

   for CLINT_Peripheral use record
      MSWI0         at 16#0# range 0 .. 31;
      MSWI1         at 16#4# range 0 .. 31;
      MTIMECMP0_LOW at 16#4000# range 0 .. 31;
      MTIMECMP0_HI  at 16#4004# range 0 .. 31;
      MTIMECMP1_LOW at 16#4008# range 0 .. 31;
      MTIMECMP1_HI  at 16#400C# range 0 .. 31;
      MTIME_LOW     at 16#BFF8# range 0 .. 31;
      MTIME_HI      at 16#BFFC# range 0 .. 31;
   end record;

   --  Core local interruptor
   CLINT_Periph : aliased CLINT_Peripheral
     with Import, Address => CLINT_Base;

end neorv32.CLINT;
