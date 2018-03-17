int num = 360000;//size的宽度*高度
Particle[] particles = new Particle[num];
PImage imgcolor;
PImage img;
float noiseScale = 800;//数字越小粒子扭动越厉害
float noiseStrength = 2;


void setup() {
  size(600, 600);//屏幕尺寸，最好图片和size的大小一样
  imgcolor = loadImage("color.jpg");//负责取该图片上的颜色
  img = loadImage("sky.png");//镂空的图片，最好文字或者图形是一个模糊的边缘
  for (int i =0; i< particles.length; i++) {
    PVector loc = new PVector(random(width), random(height), 2);
    float angle =random(TWO_PI);
    PVector dir = new PVector(sin(angle), cos(angle));
    float speed = random(0.4, 1);//粒子速度
    particles[i] = new Particle(loc, dir, speed);
  }
}

void draw() {
  fill(#010103, 10);//10表示透明度，数字越小，幻影越明显
  noStroke();
  rect(0, 0, width, height);

//sky里面的粒子
  for (int i = 10000; i < imgcolor.pixels.length; i+=100) {//200：数字越大，粒子数量越少
    fill(imgcolor.pixels[i]);
    particles[i].run(5);//数字表示粒子的大小
  }
  
  image(img, 0, 0);  //sky图片

//sky外面小小的粒子
  for (int i = 0; i < imgcolor.pixels.length; i+=2000) {
    fill(imgcolor.pixels[i]);    
    particles[i].run(1);//数字表示粒子的大小
  }
}

class Particle {
  PVector loc, vel, dir;
  float speed;

  Particle(PVector loc_, PVector dir_, float speed_) {
    loc = loc_;
    dir = dir_;
    speed =speed_;
  }

  void run(int r) {
    move();
    checkEdges();
    update(r);
  }

  void move() {
    //noise 影响angle的变化，从而影响dir和loc，noise(x,y,z);
    float angle = noise(loc.x/noiseScale, loc.y/noiseScale, frameCount/noiseScale)*TWO_PI*noiseStrength;
    dir.x = cos(angle);//dir.x的变化
    dir.y =sin(angle);//dir.y的变化
    vel = dir.get();//获得前进的速度的方向？
    vel.mult(speed);//获得的速度的大小？
    loc.add(vel);//位置在向量的表示方式
  }

  void checkEdges() {
    if (loc.x<0||loc.x>width||loc.y<0||loc.y>height) {
      loc.x = random(width);
      loc.y = random(height);
    }
  }

  void update(int r) {
    ellipse(loc.x, loc.y, r,r);
  }
}