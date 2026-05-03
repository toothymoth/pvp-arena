package §_-pvp§
{
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    /**
     * Анимации персонажей в бою
     */
    public class PvPCharacterAnimation extends Sprite
    {
        private var _targetX:Number;
        private var _targetY:Number;
        private var _element:String;
        private var _isEnemy:Boolean;
        
        public function PvPCharacterAnimation(x:Number, y:Number, element:String = "fire", isEnemy:Boolean = false)
        {
            super();
            this._targetX = x;
            this._targetY = y;
            this._element = element;
            this._isEnemy = isEnemy;
            
            createCharacter();
        }
        
        private function createCharacter():void
        {
            var color:uint = PvPElement.COLORS[this._element] || 0xFF0000;
            
            // Тело персонажа
            var body:Sprite = new Sprite();
            body.graphics.beginFill(color);
            body.graphics.drawRoundedRect(-20, -40, 40, 80, 10);
            body.graphics.endFill();
            
            // Голова
            var head:Sprite = new Sprite();
            head.graphics.beginFill(color);
            head.graphics.drawCircle(0, -50, 15);
            head.graphics.endFill();
            
            // Глаза
            var eyeColor:uint = this._isEnemy ? 0xFF0000 : 0xFFFFFF;
            var leftEye:Sprite = new Sprite();
            leftEye.graphics.beginFill(eyeColor);
            leftEye.graphics.drawCircle(-6, -52, 4);
            leftEye.graphics.endFill();
            
            var rightEye:Sprite = new Sprite();
            rightEye.graphics.beginFill(eyeColor);
            rightEye.graphics.drawCircle(6, -52, 4);
            rightEye.graphics.endFill();
            
            // Оружие/магический шар
            var weapon:Sprite = new Sprite();
            weapon.graphics.beginFill(0xFFFF00);
            weapon.graphics.drawCircle(25, -20, 12);
            weapon.graphics.endFill();
            
            weapon.x = this._isEnemy ? -30 : 30;
            weapon.y = -20;
            
            // Наносим на сцену
            addChild(body);
            addChild(head);
            addChild(leftEye);
            addChild(rightEye);
            addChild(weapon);
            
            // Свечение вокруг
            addGlow(color);
        }
        
        private function addGlow(color:uint):void
        {
            var glow:Sprite = new Sprite();
            glow.graphics.beginFill(color, 0.3);
            glow.graphics.drawCircle(0, -10, 50);
            glow.graphics.endFill();
            
            glow.alpha = 0.5;
            addChildAt(glow, 0);
            
            // Анимация пульсации
            var frame:int = 0;
            var pulse:Function = function():void {
                frame++;
                var scale:Number = 1 + Math.sin(frame * 0.1) * 0.1;
                glow.scaleX = scale;
                glow.scaleY = scale;
                
                if(!glow.parent) return;
                setTimeout(pulse, 50);
            };
            pulse();
        }
        
        /**
         * Анимация атаки
         */
        public function attackAnimation(targetX:Number, targetY:Number):void
        {
            var frame:int = 0;
            var direction:Number = this._isEnemy ? -1 : 1;
            
            var animate:Function = function():void {
                frame++;
                
                if(frame < 10) {
                    // Рывок вперёд
                    this.x += direction * 5;
                } else if(frame < 20) {
                    // Возврат
                    this.x -= direction * 3;
                } else {
                    // Возврат на место
                    this.x += (this._targetX - this.x) * 0.2;
                    this.y += (this._targetY - this.y) * 0.2;
                }
                
                if(frame < 30) {
                    setTimeout(animate, 30);
                }
            };
            animate();
        }
        
        /**
         * Анимация получения урона
         */
        public function takeDamageAnimation():void
        {
            var frame:int = 0;
            var shake:Function = function():void {
                frame++;
                this.x += (Math.random() - 0.5) * 10;
                this.y += (Math.random() - 0.5) * 5;
                
                if(frame < 10) {
                    setTimeout(shake, 30);
                } else {
                    this.x = this._targetX;
                    this.y = this._targetY;
                }
            };
            shake();
        }
        
        /**
         * Анимация защиты
         */
        public function blockAnimation():void
        {
            var shield:Sprite = new Sprite();
            shield.graphics.beginFill(0x4169E1, 0.5);
            shield.graphics.drawCircle(0, 0, 50);
            shield.graphics.endFill();
            
            shield.graphics.lineStyle(3, 0x4169E1);
            shield.graphics.drawCircle(0, 0, 50);
            
            addChild(shield);
            
            var frame:int = 0;
            var animate:Function = function():void {
                frame++;
                shield.alpha -= 0.05;
                
                if(frame < 15) {
                    setTimeout(animate, 30);
                } else {
                    removeChild(shield);
                }
            };
            animate();
        }
        
        /**
         * Анимация ультимейта
         */
        public function ultimateAnimation():void
        {
            // Зарядка
            var charge:Sprite = new Sprite();
            charge.graphics.beginFill(0xFFD700, 0.8);
            charge.graphics.drawCircle(0, 0, 30);
            charge.graphics.endFill();
            
            addChild(charge);
            
            var frame:int = 0;
            var chargeAnim:Function = function():void {
                frame++;
                charge.scaleX += 0.1;
                charge.scaleY += 0.1;
                charge.alpha -= 0.05;
                
                if(frame < 15) {
                    setTimeout(chargeAnim, 30);
                } else {
                    removeChild(charge);
                    
                    // Взрыв
                    var explosion:PVPEffects = new PVPEffects();
                    explosion.showUltimate(0, 0);
                    addChild(explosion);
                }
            };
            chargeAnim();
        }
        
        /**
         * Обновление позиции
         */
        public function updatePosition(x:Number, y:Number):void
        {
            this._targetX = x;
            this._targetY = y;
            this.x = x;
            this.y = y;
        }
    }
}
