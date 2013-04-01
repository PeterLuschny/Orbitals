// -----------------------------------------------------------
// --   An Asymptote package for drawing orbitals.
// --      Free under any GNU public license.
// --      (C) Copyright: Peter Luschny, 2008
// --              Version 1 Release 1
// -----------------------------------------------------------
// --
// --  An orbital is here an object of combinatorics, not of
// --  celestial mechanics. The set of all orbitals of given
// --  length is a lattice.
// --
// -----------------------------------------------------------
// --  See also the file orbitalgenerator.asy, which provides
// --  structures and routines to generate orbitals and the
// --  file orbitalusage.asy, which illustrates the use of
// --  the structures 'orbital' and 'orbitalgenerator'.
// --
// --  For more information see
// --  http://www.luschny.de/math/swing/orbital/orbitaldoc.pdf
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
//       Draws two orbitals /as given/ in one box.
//       It is required that length(j1) = length(j2).
//
//  Jumps may have the values -1 or 0 or 1, at most one
//  occurrence of 0 is allowed and the sum over all jumps
//  must be 0.
//
//  Eight functions to set the options are provided:
//
//     * settransform(string option)
//       Options: "revers", "invers", "dual", "identity".
//       Default is "invers".
//       The second draw routine always uses "identity".
//
//     * setdisplay(string separate)
//       Options: "inone", "separate", "quad".
//       Default is "inone".
//       The second draw routine always uses "inone".
//
//     * setplot(string option)
//       Options: "orbonly", "transonly", "orbandtrans".
//       Default is "orbandtrans".
//       The second draw routine ignores this option.
//
//     * setlabel(string option)
//       Options: "none", "symbolic", "numeric", "info".
//       Default is "none".
//
//     * sethome(string option)
//       Options: "nohome", "tinyhome", "bighome".
//       Default is "bighome".
//
//     * setarrow(bool option)
//       Options: 'true', 'false'.
//       Default is 'false'.
//
//     * setorbpen(pen orbcolor, pen transcolor)
//       Default colors are 'green' and 'orange'.
//
//     * setfillpen(pen innercolor, pen outercolor)
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

import graph;

struct Orbital
{
    private picture pic;

    private int[] jumps1, jumps2;

    private bool labnone, labsymb, labnum, labinfo;
    private bool orbonly, transonly, orbandtrans;
    private bool inone, separate, quad;
    private bool nohome, tinyhome, bighome;
    private bool showarrow;

    private pair origin, homepos, labelpos1, labelpos2;
    private int  segnum, circnum, mag;
    private real winkinc;

    private pen pospen, negpen, radpen, circpen, labelpen,
                inpen, outpen, arrowpospen, arrownegpen;

    private string currenttrans;

    private static string[] labeloptions = {
            "none", "symbolic", "numeric", "info" };

    private static string[] plotoptions = {
            "orbonly", "transonly", "orbandtrans" };

    private static string[] displayoptions = {
            "inone", "separate", "quad" };

    private static string[] orientation = {
            "positive", "negative" };

    private static string[] homeoptions = {
            "nohome", "tinyhome", "bighome" };

    private static string[] trans = {
            "identity", "revers", "invers", "dual" };

    private static int[] primes = {
    2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61};

    private int[] transform(int[] jump, string type)
    {
        if(type == "identity") { return jump; }

        int[] tra = new int[jump.length];

        if(type == "invers")
            for(int i = 0; i < segnum; ++i)
                tra[i] = -jump[i];

        else if(type == "revers")
            for(int i = 0; i < segnum; ++i)
                tra[i] = jump[segnum-i-1];

        else if(type == "dual")
           for(int i = 0; i < segnum; ++i)
                tra[i] = -jump[segnum-i-1];

        else { tra = jump; }

        return tra;
    }

    private void markhomeposition(bool pre)
    {
        if(nohome) return;

        real r = 0; pen p;

        if(pre)
        {
            if(bighome) { r = 0.6;  p = gray(0.6);}

        } else {

            if(bighome) { r = 0.25; p = black; }
            if(tinyhome){ r = 0.22; p = yellow;
                  fill(pic, circle(homepos,r), p);
                  r = 0.1;  p = red; }
        }

        fill(pic, circle(homepos,r), p);
    }

    private void fillregions()
    {
        fill(pic,scale(circnum)*unitcircle,outpen);
        fill(pic,circle(origin,homepos.x),inpen);
    }

    private void marktype(int[] jump)
    {
        bool ele = false, dep = false;
        int sum = 0;

        for(int j : jump)
        {
            sum += j;
            ele = (sum > 0) | ele;
            dep = (sum < 0) | dep;
        }

        real g = 0;
        if(ele & (!dep)) g = 1.0;
        if(dep &   ele ) g = 0.85;
        if(dep & (!ele)) g = 0.45;

        guide center = circle(origin, 1);
        fill(pic, center, gray(g));
        draw(pic, center);
    }

    private void drawradials()
    {
        pair b = (1,1);

        for(int k = 0; k < segnum; ++k)  // -- roots of unity
        {
            b = scale(circnum)*expi(2*pi*k/segnum);
            draw(pic, origin -- b, radpen);
        }
    }

    private void drawcircles()
    {
        for(int i = 1; i <= circnum; ++i)
        {
            draw(pic, scale(i)*unitcircle, circpen);
        }
    }

    private void drawarrow(bool pos)
    {
        if(! showarrow) return;

        real r = circnum + 1;
        int  or = pos ? 1 : -1;
        path pa = arc(origin, r, 15*or, 45*or);
        pen  pe = pos ? arrowpospen : arrownegpen;

        draw(pic,pa,pe,Arrow(SimpleHead),PenMargins);
    }

    private void draworbit(int[] jump, string orient)
    {
        real rad = homepos.x;
        real lowink = 0, hiwink = 0;

        bool ori  = orient == "positive";
        real winc = ori ? winkinc : -winkinc;
        pen  farb = ori ? pospen  :  negpen;

        path P;

        for(int j : jump)
        {
            hiwink += winc;
            P = P -- arc(origin, rad, lowink, hiwink);
            lowink = hiwink;
            rad += j;
        }

        draw(pic, P -- cycle, farb);
    }

    private void drawlabel(int[] jump)
    {
        pair labelpos = labelpos1;

        if(labsymb || labinfo)
        {
            string labeltext = "$";

            for(int j : jump)
            {
                    if(j >  0) labeltext += "\,+";
               else if(j <  0) labeltext += "\,-";
               else if(j == 0) labeltext += "\ *";
            }

            label(pic, labeltext + "$", labelpos, labelpen);
            labelpos = labelpos2;
        }

        if(labnum || labinfo)
        {
            if(primes.length < segnum) return;

            int numer = 1, denom = 1, i = 0;

            for(int j : jump)
            {
                    if(j > 0) numer *= primes[i];
               else if(j < 0) denom *= primes[i];
               ++i;
            }

         // string labeltext = format("$%.4g$",numer/denom);
            string labeltext = "$" + (string)numer +
                           "\ /\ " + (string)denom + "$";

            label(pic, labeltext, labelpos, labelpen);
        }
    }

    private void init()
    {
        circnum = (segnum % 2) == 1 ? segnum : segnum+1;
        winkinc = 360 / segnum;

        real radius = (circnum + 1) / 2;
        homepos     = (radius, 0);

        real labeltopmargin  = 1.2;
        real labeltopmargin2 = 1.55;

        labelpos1 = (0, -circnum * labeltopmargin);
        labelpos2 = (0, -circnum * labeltopmargin2);
    }

    // -- This is the main function
    private void draw1orbsystem(picture newpic)
    {
        picture oldpic = pic;  // -- save
        pic = newpic;
        size(pic, mag, mag);

        init();

        fillregions();
        markhomeposition(true);

        drawcircles();
        drawradials();

        if(orbonly | orbandtrans) marktype(jumps1);

        if(transonly | orbandtrans)
        {
            int[] traju = transform(jumps1, currenttrans);
            if(transonly) marktype(traju);
            draworbit(traju, "negative");
            if((! labnone) & (! orbandtrans)) drawlabel(traju);
            drawarrow(false);
        }

        if(orbonly | orbandtrans)
        {
            draworbit(jumps2, "positive");
            if(! labnone) drawlabel(jumps2);
            drawarrow(true);
        }

        markhomeposition(false);

        pic = oldpic;  // -- restore
    }

    private void draw2orbsystems()
    {
        picture pic1, pic2;

        orbandtrans = false; orbonly = true;
        draw1orbsystem(pic1);

        orbonly = false; transonly = true;
        draw1orbsystem(pic2);

        // -- add to current picture
        size(pic, mag + mag, mag);

        add(pic1.fit(),(  0, 0), W);
        add(pic2.fit(),(5mm, 0), E);
    }

    private void draw4orbsystems()
    {
        picture pic1, pic2, pic3, pic4;

        orbandtrans = false; orbonly = true;
        draw1orbsystem(pic1);

        orbonly = false; transonly = true;
        currenttrans = "revers";
        draw1orbsystem(pic2);

        currenttrans = "invers";
        draw1orbsystem(pic3);

        currenttrans = "dual";
        draw1orbsystem(pic4);

        // -- add to current picture
        size(pic, mag + mag, mag + mag);

        add(pic1.fit(),(  0, 0), NW);
        add(pic2.fit(),(5mm, 0), NE);
        add(pic3.fit(),(  0, 0), SW);
        add(pic4.fit(),(5mm, 0), SE);
    }

    private bool isvalid(int[] jump)
    {
        int sum = 0, z = 0;
        bool err = false;

        for(int j : jump)
        {
            sum += j;
                 if(j ==  1) continue;
            else if(j == -1) continue;
            else if(j ==  0) { z += 1; continue; }
            err = true;
        }

        err = err | (sum != 0) | (z > 1);

        if(err)
        {
             write("Error: Not a valid jump list!");
        }

        if(! err)
        {
            jumps1 = jump;
            segnum = jump.length;
        }

        return ! err;
    }

    restricted static Orbital Orbital(int mag)
    {
        Orbital orb = new Orbital;

        orb.mag = mag;
        orb.origin = (0, 0);
        orb.currenttrans = "invers";

        orb.inone       = true;
        orb.labnone     = true;
        orb.bighome     = true;
        orb.showarrow   = false;
        orb.orbandtrans = true;

        pen nep = linewidth(5*linewidth())+linecap(0);
        orb.pospen   = nep + green;
        orb.negpen   = nep + orange;
        orb.inpen    = gray(0.85);
        orb.outpen   = white;
        orb.arrowpospen = green+linewidth(2*linewidth());
        orb.arrownegpen = orange+linewidth(2*linewidth());

        orb.radpen   = currentpen + black;
        orb.circpen  = black + linewidth(1.4*linewidth()) ;
        orb.labelpen = font("cmr12");

        return orb;
    }


// -------------- public functions start here ----------------

    public void settransform(string option)
    {
        bool transident  = trans[0] == option;
        bool transrevers = trans[1] == option;
        bool transinvers = trans[2] == option;
        bool transdual   = trans[3] == option;

        if(! (transident | transrevers |
             transinvers | transdual ))
        {
           write("Warning: Option 'settransform' is not valid!");
           currenttrans = "identity";  // -- default
        }
        else
        {
            currenttrans = option;
        }
    }

    public void setlabel(string option)
    {
        labnone = labeloptions[0] == option;
        labsymb = labeloptions[1] == option;
        labnum  = labeloptions[2] == option;
        labinfo = labeloptions[3] == option;

        if(! (labnone | labsymb | labnum | labinfo))
        {
           write("Warning: Option 'setlabel' is not valid!");
           labnone = true;  // -- default
        }
    }

    public void setplot(string option)
    {
        orbonly     = plotoptions[0] == option;
        transonly   = plotoptions[1] == option;
        orbandtrans = plotoptions[2] == option;

        if(! (orbonly | transonly | orbandtrans))
        {
           write("Warning: Option 'setplot' is not valid!");
           orbandtrans = true;  // -- default
       }
    }

    public void setdisplay(string option)
    {
        inone    = displayoptions[0] == option;
        separate = displayoptions[1] == option;
        quad     = displayoptions[2] == option;

        if(! (inone | separate | quad))
        {
           write("Warning: Option 'setdisplay' is not valid!");
           inone = true;  // -- default
        }
    }

    public void sethome(string option)
    {
        nohome   = homeoptions[0] == option;
        tinyhome = homeoptions[1] == option;
        bighome  = homeoptions[2] == option;

        if(! (nohome | tinyhome | bighome))
        {
           write("Warning: Option 'sethome' is not valid!");
           bighome = true;  // -- default
        }
    }

    public void setorbpen(pen orbcolor, pen transcolor)
    {
        pospen = linecap(0) + orbcolor;
        negpen = linecap(0) + transcolor;
        arrowpospen = orbcolor+linewidth(2*linewidth());
        arrownegpen = transcolor+linewidth(2*linewidth());
    }

    public void setfillpen(pen innercolor, pen outercolor)
    {
        inpen  = innercolor;
        outpen = outercolor;
    }

    public void setarrow(bool option)
    {
        showarrow = option;
    }

    public void draw(picture dest=currentpicture, int[] jump)
    {
        if(! isvalid(jump)) return; jumps2 = jumps1;

             if(separate) draw2orbsystems();
        else if(quad)     draw4orbsystems();
        else draw1orbsystem(dest);
    }

    public void draw(picture dest=currentpicture,
                     int[] j1, int[] j2)
    {
        if(j1.length != j2.length)
        {
            write("Error: Arrays do not have the same length.");
            return;
        }
        if(! isvalid(j1)) return; jumps2 = jumps1;
        if(! isvalid(j2)) return;

        setplot("orbandtrans");
        settransform("identity");
        setdisplay("inone");

        draw1orbsystem(dest);
    }

}   from Orbital unravel Orbital;


// ----------------- End of struct Orbital -------------------