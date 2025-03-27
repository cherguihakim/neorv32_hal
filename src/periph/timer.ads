with neorv32; use neorv32;

package Timer is
   procedure Init;
   procedure Reset;
   procedure Disable;
   procedure Wait(ms : UInt32);
end Timer;