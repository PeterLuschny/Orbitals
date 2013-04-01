// -----------------------------------------------------------
// --   An Asymptote package for drawing orbitals.
// --      Free under any GNU public license.
// --      (C) Copyright: Peter Luschny, 2008
// --             Version 1 Release 1
// -----------------------------------------------------------
// --
// --  This file is accompanying the package orbital.asy
// --  and illustrates the use of the struct 'orbital'.
// --  For more information see
// --  http://www.luschny.de/math/swing/orbital/orbitaldoc.pdf
// --
// -----------------------------------------------------------
//
//  The struct Orbital provides 10 application functions.
//
//  Two graphical function:
//
//     * draw(picture dest=currentpicture, int[] jumps)
//       Draws an orbital and/or its transformed side by side
//       or in superposition according to the options set.
//
//     * draw(picture dest=currentpicture, int[] j1, int[] j2)
//       Draws two orbitals as given in one box.
//       It is required that length(j1) = length(j2).
//
//  Jumps may have the values -1 or 0 or 1, at most one
//  occurrence of 0 is allowed and the sum over all jumps
//  must be 0.
//
//  Eight functions to set the options are provided:
//
//     * settransform(string option)
//       Options:       (Default is "invers".)
//       -- "revers":   reversing the orbital.
//       -- "invers":   inverting the orbital.
//       -- "dual":     first reversing, then inverting.
//       -- "identity": draw as given
//       The second draw routine always uses "identity".
//
//     * setdisplay(string separate)
//       Options:        (Default is "inone".)
//       -- "inone":     all orbitals in one picture.
//       -- "separate":  two pictures in row.
//       -- "quad":      four pictures in a square.
//       The second draw routine always uses "inone".

//     * setplot(string option)
//       Options:          (Default is "orbandtrans".)
//       -- "orbonly":     plot only the given orbital.
//       -- "transonly":   plot only the transformed orbital.
//       -- "orbandtrans": plot the orbital and its trans.
//       The second draw routine ignores this option.
//
//     * setlabel(string option)
//       Options:        (Default is "none".)
//       -- "none":      write no label.
//       -- "symbolic":  write a symbolic representation.
//       -- "numeric":   write the primorial of the orbital.
//       -- "info":      both "symbolic" and "numeric".
//
//     * sethome(string option)
//       Options:       (Default is "bighome".)
//       -- "nohome":   Set no marker at the homeposition.
//       -- "tinyhome": Set tiny marker at the homeposition.
//       -- "bighome":  Set big marker at the homeposition.
//
//     * setarrow(bool option)
//       Options:       (Default is 'false'.)
//       -- 'true':     Show arrow indicating the orientation.
//       -- 'false':    Show no arrow.
//
//     * setorbpen(pen orbcolor, pen transcolor)
//       The color of the orbitals and the tranformed
//       orbital. Default is 'green' and 'orange'.
//
//     * setfillpen(pen innercolor, pen outercolor)
//       The color of the inner and the outer part of the disk.
//       Default colors are 'gray(0.85)' and 'white'.
//
//
//  How to interpret the output:
//
//  All orbitals start in the same position, the 'home
//  position', and return to it (an orbital path is closed.)
//
//  Note the following conventions:
//
//  The given orbital runs in the counterclockwise sense (is
//  mathematically positive oriented) and has by default the
//  color green. Any transformed orbital runs in the clockwise
//  sense (is mathematically negative oriented) and has the
//  default color orange.
//
//  In the case that both the orbital and the transformed
//  orbital are displayed in the same picture, the label and
//  other visual hints always refer to the original orbital.
//
// -----------------------------------------------------------

settings.outformat="pdf";
import fontsize;

// import orbital -- adjust the path to your setup
import "C:\Asymptote\Orbital\orbital.asy" as orbital;

// import orbitalgenerator -- adjust the path to your setup
import "C:\Asymptote\Orbital\orbitalgenerator.asy" as orbitalgenerator;

// Example uses of struct Orbital:

// -- The most simple case.
// -- The orbital and its invers in one picture.

void demo1()
{
    int[] jump = {1,1,1,-1,-1,-1};

    Orbital orb = Orbital(200); // -- size 200
    orb.draw(jump);

    shipout("orb1demo", bbox(0.2cm));
}

// -- The most simple case with some options.

void demo2()
{
    int[] jump = {1,1,1,0,-1,-1,-1};

    Orbital orb = Orbital(200); // -- size 200

    // -- Path option
    orb.setplot("orbonly");

    // -- Label option
    orb.setlabel("symbolic");

    // -- Color options
    pen orbpen = linewidth(6*linewidth())+lightblue;
    orb.setorbpen(orbpen, orbpen);
    orb.sethome("tinyhome");

    orb.draw(jump);

    shipout("orb2demo", bbox(0.2cm));
}

// -- The option "seperate":
// -- The orbital and its invers in two pictures.

void demo3()
{
    int[] jump = {-1,-1,-1,-1,-1,-1,1,1,1,1,1,1};

    Orbital orb = Orbital(200);

    orb.setlabel("numeric");
    orb.setdisplay("separate");
    orb.setarrow(true);
    orb.draw(jump);

    shipout("orb3demo", bbox(0.25cm));
}

// -- The option "quad":
// -- The orbital and all its transformed forms in 4 pictures.

void demo4()
{
    int[] jump = {-1,-1,-1,1,1,1,1,1,-1,-1};

    Orbital orb = Orbital(150);

    orb.setlabel("numeric");
    orb.setdisplay("quad");
    orb.draw(jump);

    shipout("orb4demo", bbox(0.2cm));
}

// -- The second form draw:
// -- Two orbitals as given in one picture.

void demo6()
{
    int[][]orbits =  {
    {1,  1, -1, -1}, {1, -1, 1, -1},
    {-1, 1, -1,  1}, {-1,-1, 1,  1} } ;

    int mag = 100; real margin = 5mm;
    Orbital orb = Orbital(mag);

    picture pic1; orb.draw(pic1, orbits[0], orbits[2]);
    picture pic2; orb.draw(pic2, orbits[0], orbits[3]);
    picture pic3; orb.draw(pic3, orbits[1], orbits[2]);
    picture pic4; orb.draw(pic4, orbits[1], orbits[3]);

    // -- add to current picture
    size(currentpicture, 4*mag + 3*margin, mag);

    add(currentpicture, pic1.fit(),(0,0));
    add(currentpicture, pic2.fit(),(240+margin,0));
    add(currentpicture, pic3.fit(),(480+2*margin,0));
    add(currentpicture, pic4.fit(),(720+3*margin,0));

    shipout("orb6demo", bbox(0.2cm));
}

// -- More colors!

void demo7()
{
    size(520);

    int[][]orbits =  {
    { 1,1,-1,-1}, { 1,-1, 1,-1}, { 1,-1,-1,1},
    {-1,1, 1,-1}, {-1, 1,-1, 1}, {-1,-1, 1,1} } ;

    pair[] pos = {(3,1),(3,5/2),(1,4),(5,4),(3,11/2),(3,7)};

    void zeige(int i, int k)
    {
        draw(pos[i]--pos[k],black+linewidth(3.6*linewidth()));
    }

    zeige(1,0); zeige(2,1); zeige(3,1);
    zeige(4,2); zeige(4,3); zeige(5,4);

    Orbital orb = Orbital(1);
    orb.setplot("orbonly");

    orb.setfillpen(gray(0.85),cmyk(0.15,0.0,0.69,0.0));
    pen p = cmyk(0.0,1.0,0.0,0.0)+linewidth(4*linewidth());
    orb.setorbpen(p,p);

    for(int i = 0; i < 6; ++i)
    {
        pair Z = pos[i];
        picture pic;
        orb.draw(pic, orbits[i]);
        add(scale(8)*pic, Z);
    }

    pen p = Symbol(series="m",shape="n");
    p = p+fontsize(56)+gray(0.80);
    label("$\Omega_4$",(3,4),p);

    // Instead of the last three lines with postscript:
    // postscript("/inch{ 72 mul 30 sub } def");
    // postscript("0.0 0.0 0.0 0.4 setcmykcolor");
    // postscript("/Symbol findfont 64 scalefont setfont");
    // postscript("2.95 inch 4.1 inch moveto (\127) show");
    // postscript("/Symbol findfont 40 scalefont setfont");
    // postscript("3.65 inch 3.9 inch moveto (4) show");

    shipout("orb7demo", bbox(0.3cm));
}

/////////////////////////////////////////////////////////////
//            Usage of generators
//  No graphical output, only numerical.
/////////////////////////////////////////////////////////////

void demo8()
{
     OrbitalGenerator og = OrbitalGenerator(6);
     int n = og.generate();
     write("Orbitals("+(string)6+") = "+(string)n);
}

void demo9()
{
    for(int i = 1; i < 7; ++i)
    {
       write();
        write(" Omega("+(string)i +") prime ordered.");

        PrimeOrbitalGenerator pog = PrimeOrbitalGenerator(i);
        pog.generate();
        pog.write();
    }
}

////////////////////////////////////////////////////////
//    Using the visit hook.
//    No graphical output, only numerical.
////////////////////////////////////////////////////////

void myVisit(int[] orb)
{
   string s;
   for(int o : orb)  { s = s + (string)o + " ";  }
   write(reverse(s) + "  ...my visit...");
}

void demo10()
{
    int len = 4, count;
    write("Generate all orbitals of length "+(string)len+" !");

    // -- without visit
    OrbitalGenerator og = OrbitalGenerator(len);
    count = og.generate();

    write("Orbitals("+(string)len+") = "+(string)count);
    write("  ");
    write("And now processing the orbitals my way!");

    // -- with visit
    OrbitalGenerator myog = OrbitalGenerator(len, myVisit);
    count = myog.generate();

    write("Orbitals("+(string)len+") = "+(string)count);
}


////////////////////////////////////////////////////////
//    ... now the highlight!
//    Display all orbitals of length 6 in primorial order.
////////////////////////////////////////////////////////

void demo11()
{
    PrimeOrbitalGenerator pog = PrimeOrbitalGenerator(6);
    PrimeOrbital[] po = pog.generate();
    pog.write();
    size(500,1000);

    Orbital orb = Orbital(1);
    orb.setlabel("info");
    int i = -1;

    for(int y = 690; y > 100; y -= 140)
    {
        for(int x = 135; x < 500; x += 110)
        {
            pair Z = (x, y+18);
            picture pic;
            orb.draw(pic, po[++i].jumps);
            add(scale(7)*pic, Z);
        }
    }
    shipout("orb11demo", bbox(1cm));
}

void test()
{
    demo1();  erase();
    demo2();  erase();
    demo3();  erase();
    demo4();  erase();
    demo6();  erase();
    demo7();  erase();
    demo8();  erase();
    demo9();  erase();
    demo10(); erase();
    demo11(); 
}

test();


/**********
0 [1/1]  1
Orbitals(1) = 1

-1 1 [3/2]  1.50
1 -1 [2/3]  0.66
Orbitals(2) = 2

-1 0 1 [5/2]  2.50
0 -1 1 [5/3]  1.67
-1 1 0 [3/2]  1.50
1 -1 0 [2/3]  0.66
0 1 -1 [3/5]  0.60
1 0 -1 [2/5]  0.40
Orbitals(3) = 6

-1 -1 1 1 [35/6]   5.83
-1 1 -1 1 [21/10]  2.10
-1 1 1 -1 [15/14]  1.07
1 -1 -1 1 [14/15]  0.93
1 -1 1 -1 [10/21]  0.47
1 1 -1 -1 [6/35]   0.17
Orbitals(4) = 6

-1 -1 0 1 1 [77/6]  12.80
-1 -1 1 0 1 [55/6]   9.17
-1 0 -1 1 1 [77/10]  7.70
-1 -1 1 1 0 [35/6]   5.83
0 -1 -1 1 1 [77/15]  5.13
-1 0 1 -1 1 [55/14]  3.93
-1 1 -1 0 1 [33/10]  3.30
0 -1 1 -1 1 [55/21]  2.62
-1 1 0 -1 1 [33/14]  2.36
-1 1 -1 1 0 [21/10]  2.10
-1 0 1 1 -1 [35/22]  1.59
1 -1 -1 0 1 [22/15]  1.47
-1 1 1 -1 0 [15/14]  1.07
0 -1 1 1 -1 [35/33]  1.06
1 -1 0 -1 1 [22/21]  1.05
-1 1 0 1 -1 [21/22]  0.95
0 1 -1 -1 1 [33/35]  0.94
1 -1 -1 1 0 [14/15]  0.93
-1 1 1 0 -1 [15/22]  0.68
1 0 -1 -1 1 [22/35]  0.62
1 -1 1 -1 0 [10/21]  0.47
1 -1 0 1 -1 [14/33]  0.42
0 1 -1 1 -1 [21/55]  0.38
1 -1 1 0 -1 [10/33]  0.30
1 0 -1 1 -1 [14/55]  0.25
0 1 1 -1 -1 [15/77]  0.19
1 1 -1 -1 0 [6/35]   0.17
1 0 1 -1 -1 [10/77]  0.13
1 1 -1 0 -1 [6/55]   0.10
1 1 0 -1 -1 [6/77]   0.07
Orbitals(5) = 30

-1 -1 -1 1 1 1 [1001/30] 33.40
-1 -1 1 -1 1 1 [715/42]  17.00
-1 -1 1 1 -1 1 [455/66]   6.89
-1 1 -1 -1 1 1 [429/70]   6.13
-1 -1 1 1 1 -1 [385/78]   4.94
1 -1 -1 -1 1 1 [286/105]  2.72
-1 1 -1 1 -1 1 [273/110]  2.48
-1 1 -1 1 1 -1 [231/130]  1.78
-1 1 1 -1 -1 1 [195/154]  1.27
1 -1 -1 1 -1 1 [182/165]  1.10
-1 1 1 -1 1 -1 [165/182]  0.90
1 -1 -1 1 1 -1 [154/195]  0.79
1 -1 1 -1 -1 1 [130/231]  0.56
1 -1 1 -1 1 -1 [110/273]  0.40
-1 1 1 1 -1 -1 [105/286]  0.36
1 1 -1 -1 -1 1 [78/385]   0.20
1 -1 1 1 -1 -1 [70/429]   0.16
1 1 -1 -1 1 -1 [66/455]   0.14
1 1 -1 1 -1 -1 [42/715]   0.05
1 1 1 -1 -1 -1 [30/1001]  0.03
Orbitals(6) = 20

****/