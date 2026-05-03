package §_-pvp§
{
   import §_-22Q§.§_-5sS§;
   import §_-2iP§.§_-1Vi§;
   import §_-4o§.createTextField;
   import §_-5T8§.§_-0bU§;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import penzville.city.§_-0yo§;
   
   public class PvPArenaMainDialog extends §_-5sS§
   {
      
      private static const WIDTH:int = 450;
      
      private static const HEIGHT:int = 350;
       
      
      public function PvPArenaMainDialog()
      {
         super(WIDTH,HEIGHT,"PvP Арена");
      }
      
      override protected function createSkin() : §_-1Vi§
      {
         return new PvPArenaDialogSkin();
      }
      
      override public function init() : void
      {
         super.init();
         createMainUI();
      }
      
      private function createMainUI() : void
      {
         // Заголовок
         var title:TextField = createTextField(WIDTH / 2 - 100,30,"Добро пожаловать на PvP Арену!",0xFFFF00,20);
         title.textAlign = "center";
         addChild(title);
         
         // Описание
         var desc:TextField = createTextField(20,70,"Сражайтесь с другими игроками, поднимайте рейтинг и становитесь лучшим бойцом!",0xCCCCCC,14);
         desc.width = WIDTH - 40;
         desc.multiline = true;
         addChild(desc);
         
         // Кнопка создания комнаты
         var createBtn:§_-4Tm§ = new §_-4Tm§("Создать комнату",180,40);
         createBtn.x = WIDTH / 2 - 180;
         createBtn.y = 150;
         createBtn.addEventListener(MouseEvent.CLICK,onCreatePublic);
         addChild(createBtn);
         
         // Кнопка вступления в публичную
         var joinPublicBtn:§_-4Tm§ = new §_-4Tm§("Найти бой",180,40);
         joinPublicBtn.x = WIDTH / 2;
         joinPublicBtn.y = 150;
         joinPublicBtn.addEventListener(MouseEvent.CLICK,onJoinPublic);
         addChild(joinPublicBtn);
         
         // Кнопка приватной комнаты
         var joinPrivateBtn:§_-4Tm§ = new §_-4Tm§("Вступить по коду",150,30);
         joinPrivateBtn.x = WIDTH / 2 - 75;
         joinPrivateBtn.y = 220;
         joinPrivateBtn.addEventListener(MouseEvent.CLICK,onJoinPrivate);
         addChild(joinPrivateBtn);
         
         // Кнопка лидерборда
         var leaderboardBtn:§_-4Tm§ = new §_-4Tm§("Топ игроков",150,30);
         leaderboardBtn.x = WIDTH / 2 - 75;
         leaderboardBtn.y = 270;
         leaderboardBtn.addEventListener(MouseEvent.CLICK,onLeaderboard);
         addChild(leaderboardBtn);
      }
      
      private function onCreatePublic(event:MouseEvent) : void
      {
         var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
         if(module)
         {
            module.joinArena("public");
         }
         close();
      }
      
      private function onJoinPublic(event:MouseEvent) : void
      {
         var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
         if(module)
         {
            module.joinArena("public");
         }
         close();
      }
      
      private function onJoinPrivate(event:MouseEvent) : void
      {
         // Открыть диалог ввода кода
         var codeDialog:PvPArenaEnterCodeDialog = new PvPArenaEnterCodeDialog();
         §_-00j§.§_-1pL§(codeDialog);
         close();
      }
      
      private function onLeaderboard(event:MouseEvent) : void
      {
         var dialog:PvPArenaLeaderboardDialog = new PvPArenaLeaderboardDialog();
         §_-00j§.§_-1pL§(dialog);
         close();
      }
   }
}
