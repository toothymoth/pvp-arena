package §_-pvp§
{
   import §_-2iP§.§_-1Vi§;
   import §_-4o§.createTextField;
   import §_-4o§.§_-4o§;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class PvPArenaBattleDialog extends PvPArenaDialog
   {
      
      private static const WIDTH:int = 800;
      
      private static const HEIGHT:int = 600;
       
      
      private var _battleState:Object = null;
      
      private var _playerStates:Object = null;
      
      private var _timeout:int = 0;
      
      private var _timerText:TextField = null;
      
      private var _attackButtons:Sprite = null;
      
      private var _healthBars:Sprite = null;
      
      public function PvPArenaBattleDialog(battleData:Object)
      {
         super(WIDTH,HEIGHT,"PvP Битва");
         this._battleState = battleData;
         this._playerStates = battleData.players;
         this._timeout = battleData.timeout || 180;
      }
      
      override public function init() : void
      {
         super.init();
         createBattleUI();
         startTimer();
      }
      
      private function createBattleUI() : void
      {
         // Таймер
         this._timerText = createTextField(WIDTH / 2 - 30,20,"3:00",0xFFFFFF,24);
         this._timerText.textAlign = "center";
         addChild(this._timerText);
         
         // Здоровье игроков
         this._healthBars = createHealthBars();
         this._healthBars.y = 70;
         addChild(this._healthBars);
         
         // Информация о боях
         var battleInfo:TextField = createTextField(20,300,"Атакуйте противника!",0xCCCCCC,16);
         battleInfo.width = WIDTH - 40;
         battleInfo.textAlign = "center";
         addChild(battleInfo);
         
         // Кнопки действий
         this._attackButtons = createActionButtons();
         this._attackButtons.y = HEIGHT - 120;
         addChild(this._attackButtons);
      }
      
      private function createHealthBars() : Sprite
      {
         var container:Sprite = new Sprite();
         var players:Array = [];
         
         for(var uid:String in this._playerStates)
         {
            players.push(uid);
         }
         
         var barWidth:int = (WIDTH - 100) / players.length;
         
         for(var i:int = 0; i < players.length; i++)
         {
            var uid:String = players[i];
            var state:Object = this._playerStates[uid];
            
            // Имя игрока
            var nameText:TextField = createTextField(50 + i * barWidth,10,uid,0xFFFFFF,12);
            nameText.width = barWidth;
            nameText.textAlign = "center";
            container.addChild(nameText);
            
            // Фон полоски здоровья
            var bg:Sprite = new Sprite();
            bg.graphics.beginFill(0x333333);
            bg.graphics.drawRect(0,30,barWidth - 20,20);
            bg.graphics.endFill();
            bg.x = 50 + i * barWidth;
            bg.y = 30;
            container.addChild(bg);
            
            // Здоровье
            var hpPercent:Number = state.hp / state.max_hp;
            var hpColor:uint = hpPercent > 0.5 ? 0x00FF00 : (hpPercent > 0.25 ? 0xFFFF00 : 0xFF0000);
            
            var hpBar:Sprite = new Sprite();
            hpBar.graphics.beginFill(hpColor);
            hpBar.graphics.drawRect(0,30,(barWidth - 20) * hpPercent,20);
            hpBar.graphics.endFill();
            hpBar.x = 50 + i * barWidth;
            hpBar.y = 30;
            container.addChild(hpBar);
            
            // Цифры HP
            var hpText:TextField = createTextField(50 + i * barWidth,55,state.hp + "/" + state.max_hp,0xFFFFFF,12);
            hpText.width = barWidth;
            hpText.textAlign = "center";
            container.addChild(hpText);
         }
         
         return container;
      }
      
      private function createActionButtons() : Sprite
      {
         var container:Sprite = new Sprite();
         var myUid:String = §_-0yo§.§_-Gq§.id;
         var players:Array = [];
         
         for(var uid:String in this._playerStates)
         {
            if(uid != myUid)
            {
               players.push(uid);
            }
         }
         
         var btnWidth:int = 100;
         var btnHeight:int = 40;
         var spacing:int = 20;
         var startX:int = (WIDTH - (players.length * (btnWidth + spacing))) / 2;
         
         // Кнопка атаки
         var attackBtn:§_-4Tm§ = createButton("Атака",btnWidth,btnHeight,0xFF6600);
         attackBtn.x = startX + (players.length > 1 ? btnWidth + spacing : 0);
         attackBtn.y = 0;
         attackBtn.addEventListener(MouseEvent.CLICK,onAttackClick);
         container.addChild(attackBtn);
         
         // Кнопка блока
         var blockBtn:§_-4Tm§ = createButton("Блок",btnWidth,btnHeight,0x6666FF);
         blockBtn.x = attackBtn.x + btnWidth + spacing;
         blockBtn.y = 0;
         blockBtn.addEventListener(MouseEvent.CLICK,onBlockClick);
         container.addChild(blockBtn);
         
         // Кнопка ультимейта
         var ultBtn:§_-4Tm§ = createButton("Ульта",btnWidth,btnHeight,0xCC00FF);
         ultBtn.x = blockBtn.x + btnWidth + spacing;
         ultBtn.y = 0;
         ultBtn.addEventListener(MouseEvent.CLICK,onUltimateClick);
         container.addChild(ultBtn);
         
         // Сохраняем ссылки для обновления
         this.attackBtn = attackBtn;
         this.blockBtn = blockBtn;
         this.ultBtn = ultBtn;
         this.targetPlayers = players;
         
         return container;
      }
      
      private var attackBtn:§_-4Tm§;
      
      private var blockBtn:§_-4Tm§;
      
      private var ultBtn:§_-4Tm§;
      
      private var targetPlayers:Array;
      
      private function createButton(title:String,width:int,height:int,color:uint = 0x444444) : §_-4Tm§
      {
         var btn:§_-4Tm§ = new §_-4Tm§(title,width,height);
         return btn;
      }
      
      public function updateBattleState(data:Object) : void
      {
         this._playerStates = data.states;
         
         // Обновляем полоски здоровья
         if(this._healthBars)
         {
            removeChild(this._healthBars);
            this._healthBars = createHealthBars();
            this._healthBars.y = 70;
            addChildAt(this._healthBars,0);
         }
         
         // Показываем информацию об атаке
         if(data.damage > 0)
         {
            showDamageEffect(data.attacker, data.target, data.damage);
         }
      }
      
      private function showDamageEffect(attacker:String, target:String, damage:int) : void
      {
         var damageText:TextField = createTextField(WIDTH / 2 - 30,HEIGHT / 2,"-" + damage,0xFF0000,32);
         damageText.textAlign = "center";
         damageText.alpha = 1;
         addChild(damageText);
         
         // Простая анимация исчезновения
         var frames:int = 0;
         var updateFunc:Function = function():void
         {
            frames++;
            damageText.alpha -= 0.05;
            damageText.y -= 1;
            if(damageText.alpha <= 0)
            {
               removeChild(damageText);
            }
            if(frames < 20)
            {
               setTimeout(updateFunc,50);
            }
         };
         updateFunc();
      }
      
      private var _timer:int = 0;
      
      private function startTimer() : void
      {
         this._timer = this._timeout;
         updateTimerText();
         
         var timerFunc:Function = function():void
         {
            this._timer--;
            updateTimerText();
            if(this._timer > 0)
            {
               setTimeout(timerFunc,1000);
            }
            else
            {
               // Таймер истёк
               var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
               if(module)
               {
                  module.finishBattle(this._battleState.room);
               }
            }
         };
         timerFunc();
      }
      
      private function updateTimerText() : void
      {
         var minutes:int = int(this._timer / 60);
         var seconds:int = this._timer % 60;
         this._timerText.text = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
      }
      
      private function onAttackClick(event:MouseEvent) : void
      {
         if(this.targetPlayers.length > 0)
         {
            // Атаковать первого доступного противника
            var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
            if(module)
            {
               module.attack(this.targetPlayers[0]);
            }
         }
      }
      
      private function onBlockClick(event:MouseEvent) : void
      {
         var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
         if(module)
         {
            module.block();
         }
      }
      
      private function onUltimateClick(event:MouseEvent) : void
      {
         if(this.targetPlayers.length > 0)
         {
            var module:PvPArenaModule = §_-6VA§.instance.§_-1OU§(PvPArenaModule.MODULE_ID) as PvPArenaModule;
            if(module)
            {
               module.useUltimate(this.targetPlayers[0]);
            }
         }
      }
      
      override public function destroy() : void
      {
         if(destroyed)
         {
            return;
         }
         if(this._attackButtons)
         {
            this._attackButtons.removeEventListener(MouseEvent.CLICK,onAttackClick);
         }
         super.destroy();
      }
   }
}
