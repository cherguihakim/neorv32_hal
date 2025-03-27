package Shooter_Game is 
   function randomN return Integer;
   procedure Draw_Screen;
   procedure Read_Input;
   procedure Update_Projectiles;
   procedure Update_Enemies;
   procedure Spawn_Enemies;
   procedure Check_Collisions;
   procedure Game;
end Shooter_Game;