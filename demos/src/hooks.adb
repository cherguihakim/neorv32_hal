with Ada.Text_IO; use Ada.Text_IO;
--with Ada.Integer_Text_IO; 
with Ada.Characters.Handling; use Ada.Characters.Handling;

with Neorv32.Uart0;
with Neorv32.GPIO;
with Neorv32;
with Uart0;
with GPIO; 
with Random;
with timer;
with Shooter_Game;

with Sysinfo;
with System;

package body Hooks is

   type Cmd_T is (Echo, Infos, Reload, Help, Leds, Button, Number, Wait, Game, Traffic, Your, Counter, Unknown);
   Cmd : Cmd_T := Unknown;

   Pink_Bold : constant String := ASCII.ESC & "[1;38;2;255;0;255m";
   Cyan      : constant String := ASCII.ESC & "[38;2;0;255;255m";
   Blue      : constant String := ASCII.ESC & "[38;2;85;170;255m";
   Purple    : constant String := ASCII.ESC & "[38;2;170;85;255m";
   Pink      : constant String := ASCII.ESC & "[38;2;255;0;255m";
   Green     : constant String := ASCII.ESC & "[38;2;57;255;20m";

   Reset   : constant String := ASCII.ESC & "[0m";

   procedure Neorv32_Ada_Art is
   begin
      Put_Line (Cyan   & " _______                          ______ ______ " & Reset);
      Put_Line (Blue   & "|    |  |.-----.-----.----.--.--.|__    |__    |" & Reset);
      Put_Line (Purple & "|       ||  -__|  _  |   _|  |  ||__    |  " & Reset & Green & " ___" & Reset & Purple & "|" & Reset & Green & "_   _     ");
      Put_Line (Pink   & "|__|____||_____|_____|__|  \___/ |______|__" & Reset & Green & "|  _  |_| |___ ");
      Put_Line (         "                                           " & Reset & Green & "|     | . | .'|");
      Put_Line (         "                                           " & Reset & Green & "|__|__|___|__,|" & Reset);
   end Neorv32_Ada_Art;

   procedure Show_Choice_Prompt is
   begin
      Put (Pink & "Enter your choice >" & Reset);
   end Show_Choice_Prompt;

   procedure Show_Menu is
   begin
      New_Line;
      Put_Line ("========= Available Commands =========");
      Put_Line (" e: Echo your input");
      Put_Line (" i: System Infos.");
      Put_Line (" h: Help on commands.");
      Put_Line (" l: Turn ON LEDs and OFF in a pattern, then click button to light LED.");
      Put_Line (" b: Wait for button press.");
      Put_Line (" n: Random Number.");
      Put_Line (" w: Wait for 5 seconds.");
      Put_Line (" g: Play the retro-shooter game.");
      Put_Line (" r: Reload the program.");
      Put_Line (" t: traffic light");
      Put_Line (" y: your user code");
      Put_Line (" c: counter  ");
      Put_Line ("======================================");
      Show_Choice_Prompt;
   end Show_Menu;

   procedure Show_Input_Prompt is
   begin
      New_Line;
      Put (Pink & ">" & Reset);
   end Show_Input_Prompt;

   procedure Show_ReLoad is
   begin
      New_Line;
      Neorv32_Ada_Art;
      Show_Menu;
   end Show_ReLoad;

   procedure Show_Infos is
   begin
      New_Line;
      Put_Line ("Main Clock Frequency: " & Sysinfo.Clk'Image);
      Show_Choice_Prompt;
   end Show_Infos;

   procedure Show_Unknown_Command is
   begin
      New_Line;
      Put_Line ("Unknown command! 'h' for help.");
      Show_Choice_Prompt;
   end Show_Unknown_Command;

   procedure Show_Button (Pin : Natural) is
   begin
      while GPIO.Read_Pin (Pin) = False loop
         --New_Line;
         null;
         --Ada.Integer_Text_IO.Put(Item => Neorv32.GPIO.GPIO_Periph.INPUT0, Base => 2);
         --New_Line;
      end loop;
      New_Line;
      Put_Line("Button pressed");
      New_Line;
      Put_Line("GPIO Input Register is : " & Neorv32.GPIO.GPIO_Periph.INPUT0'Image);
      New_Line;
      Show_Choice_Prompt;
   end Show_Button;

   procedure Show_Random_number is
   begin
      Put_Line ("Random number: " & Random.Random'Image);
      Show_Choice_Prompt;
   end Show_Random_number;

   procedure Show_Timer is 
   begin
      Timer.Init;
      Timer.Wait(5000);
      Put_Line ("Timer expired");
      Show_Choice_Prompt;
   end Show_Timer;

   procedure Show_YourCode is
   begin
      --start user code

      --end user code
      New_Line;
      Show_Choice_Prompt;
   end Show_Your;

   procedure Show_Leds is 
      state : Boolean := True;
   begin
   GPIO.Set_Pin (8, GPIO.HIGH);
   Timer.Init;
   Timer.Wait(1000);
   GPIO.Set_Pin (8, GPIO.LOW);
   GPIO.Set_Pin (9, GPIO.HIGH);
   Timer.Init;
   Timer.Wait(1000);
   GPIO.Set_Pin (9, GPIO.LOW);
   GPIO.Set_Pin (10, GPIO.HIGH);
   Timer.Init;
   Timer.Wait(1000);
   GPIO.Set_Pin (10, GPIO.LOW);
   while (state) loop
         if GPIO.Read_Pin (0) then 
            GPIO.Set_Pin (8, GPIO.HIGH);
            Timer.Init;
            Timer.Wait(1000);
            GPIO.Set_Pin (8, GPIO.LOW);
         elsif GPIO.Read_Pin (1) then 
            GPIO.Set_Pin (9, GPIO.HIGH);
            Timer.Init;
            Timer.Wait(1000);
            GPIO.Set_Pin (9, GPIO.LOW);
         elsif GPIO.Read_Pin (2) then 
            GPIO.Set_Pin (10, GPIO.HIGH);
            Timer.Init;
            Timer.Wait(1000);
            GPIO.Set_Pin (10, GPIO.LOW);
         elsif GPIO.Read_Pin (3) then
            state := False;
         end if;
      end loop;
      Show_Choice_Prompt;
   end Show_Leds;

   procedure Show_Game is  
   begin 
      Shooter_Game.Game;
      Show_Choice_Prompt;
   end Show_Game;

   procedure Show_Traffic is
      state : Boolean := True;
   begin
      -- red pedestrian light       0
      -- green pedestrian light     1
      -- Red Main Light             2
      -- yellow main light          3
      -- green main light           4
      GPIO.Set_Pin (0, GPIO.LOW);
      GPIO.Set_Pin (1, GPIO.LOW);
      GPIO.Set_Pin (2, GPIO.LOW);
      GPIO.Set_Pin (3, GPIO.LOW);
      GPIO.Set_Pin (4, GPIO.LOW);
      while (state) loop
         GPIO.Set_Pin (0, GPIO.HIGH); --rp
         GPIO.Set_Pin (1, GPIO.LOW); --gp
         GPIO.Set_Pin (2, GPIO.LOW); --r
         GPIO.Set_Pin (3, GPIO.LOW); --y
         GPIO.Set_Pin (4, GPIO.HIGH); --g
         if (GPIO.Read_Pin (0) ) then
            GPIO.Set_Pin (0, GPIO.HIGH); --rp
            GPIO.Set_Pin (1, GPIO.LOW); --gp
            GPIO.Set_Pin (2, GPIO.LOW); --r
            GPIO.Set_Pin (3, GPIO.HIGH); --y
            GPIO.Set_Pin (4, GPIO.LOW); --g
            Timer.Init;
            Timer.Wait(3000);
            GPIO.Set_Pin (0, GPIO.HIGH); --rp
            GPIO.Set_Pin (1, GPIO.LOW); --gp
            GPIO.Set_Pin (2, GPIO.HIGH); --r
            GPIO.Set_Pin (3, GPIO.LOW); --y
            GPIO.Set_Pin (4, GPIO.LOW); --g
            Timer.Init;
            Timer.Wait(1000);
            GPIO.Set_Pin (0, GPIO.LOW); --rp
            GPIO.Set_Pin (1, GPIO.HIGH); --gp
            GPIO.Set_Pin (2, GPIO.HIGH); --r
            GPIO.Set_Pin (3, GPIO.LOW); --y
            GPIO.Set_Pin (4, GPIO.LOW); --g
            Timer.Init;
            Timer.Wait(10000);
            GPIO.Set_Pin (0, GPIO.HIGH); --rp
            GPIO.Set_Pin (1, GPIO.LOW); --gp
            GPIO.Set_Pin (2, GPIO.HIGH); --r
            GPIO.Set_Pin (3, GPIO.LOW); --y
            GPIO.Set_Pin (4, GPIO.LOW); --g
            Timer.Init;
            Timer.Wait(1000);
            GPIO.Set_Pin (0, GPIO.HIGH); --rp
            GPIO.Set_Pin (1, GPIO.LOW); --gp
            GPIO.Set_Pin (2, GPIO.HIGH); --r
            GPIO.Set_Pin (3, GPIO.HIGH); --y
            GPIO.Set_Pin (4, GPIO.LOW); --g
            Timer.Init;
            Timer.Wait(2000);
         end if;

         if GPIO.Read_Pin (3) then
            state := False;
         end if;
      end loop;
      Show_Choice_Prompt;
   end Show_Traffic;

   procedure Show_Counter is
      state : Boolean := True;
   begin
      GPIO.Set_Pin (8, GPIO.LOW);
      GPIO.Set_Pin (9, GPIO.LOW);
      GPIO.Set_Pin (10, GPIO.HIGH);
      Timer.Init;
      Timer.Wait(1000);
      GPIO.Set_Pin (8, GPIO.LOW);
      GPIO.Set_Pin (9, GPIO.HIGH);
      GPIO.Set_Pin (10, GPIO.LOW);
      Timer.Init;
      Timer.Wait(1000);
      GPIO.Set_Pin (8, GPIO.LOW);
      GPIO.Set_Pin (9, GPIO.HIGH);
      GPIO.Set_Pin (10, GPIO.HIGH);
      Timer.Init;
      Timer.Wait(1000);
      GPIO.Set_Pin (8, GPIO.HIGH);
      GPIO.Set_Pin (9, GPIO.LOW);
      GPIO.Set_Pin (10, GPIO.LOW);
      Timer.Init;
      Timer.Wait(1000);
      GPIO.Set_Pin (8, GPIO.HIGH);
      GPIO.Set_Pin (9, GPIO.LOW);
      GPIO.Set_Pin (10, GPIO.HIGH);
      Timer.Init;
      Timer.Wait(1000);
      GPIO.Set_Pin (8, GPIO.HIGH);
      GPIO.Set_Pin (9, GPIO.HIGH);
      GPIO.Set_Pin (10, GPIO.LOW);
      Timer.Init;
      Timer.Wait(1000);
      GPIO.Set_Pin (8, GPIO.HIGH);
      GPIO.Set_Pin (9, GPIO.HIGH);
      GPIO.Set_Pin (10, GPIO.HIGH);
      Timer.Init;
      Timer.Wait(1000);
      GPIO.Set_Pin (8, GPIO.LOW);
      GPIO.Set_Pin (9, GPIO.LOW);
      GPIO.Set_Pin (10, GPIO.LOW);
   end Show_Counter;

   procedure Parse_Cmd (Hart : Harts_T; Trap_Code : Trap_Code_T) is
      pragma Unreferenced (Hart);
      pragma Unreferenced (Trap_Code);
      use Neorv32;
      Choice : Character;
      Command : Cmd_T := Unknown;
   begin
      loop
         if Neorv32.Uart0.UART0_Periph.CTRL.UART_CTRL_RX_NEMPTY = 1 then
            Choice := Uart0.Read_RX;
            if Cmd = Echo then
               Put_Line (Choice'Image);
               Cmd := Unknown;
               Show_Choice_Prompt;
            else
               Put (Choice);
               for C in Cmd_T'Range loop
                  declare
                     C_Str : constant String := C'Image;
                  begin
                     if Choice = To_Lower (C_Str (1)) then
                        Command := C;
                        exit;
                     end if;
                  end;
               end loop;
               case Command is
                  when Echo =>
                     Show_Input_Prompt;
                     Cmd := Echo;
                  when Infos =>
                     Show_Infos;
                  when Reload =>
                     Show_Reload;
                  when Help =>
                     Show_Menu;
                  when Button =>
                     Show_Button (3);
                  when Number =>
                     New_Line;
                     Show_Random_number;
                  when Wait =>
                     New_Line;
                     Show_Timer;
                  when Leds =>
                     New_Line;
                     Show_Leds;
                  when Game =>
                     New_Line;
                     Show_Game;
                  when Traffic =>
                     New_Line;
                     Show_Traffic;
                  when Your =>
                     New_Line;
                     Show_YourCode;
                  when Counter =>
                     New_Line;
                     Show_Counter;
                  when others =>
                     Show_Unknown_Command;
               end case;
            end if;
            exit;
         end if; 
      end loop;
   end Parse_Cmd;

   procedure Exit_Handler is
   begin
      loop
         null;  -- Stay in an infinite loop
      end loop;
   end Exit_Handler;
end Hooks;