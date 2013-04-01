// -----------------------------------------------------------
// --   An Asymptote package for drawing orbitals.
// --      Free under any GNU public license.
// --      (C) Copyright: Peter Luschny, 2008
// --             Version 1 Release 1
// -----------------------------------------------------------
// --
// --  This file is accompanying the package orbital.asy and
// --  provides structures and routines to generate orbitals.
// --  See also the file orbitalusage.asy, which illustrates
// --  the use of the structure 'orbitalgenerator'.
// --
// --  For more information see
// --  http://www.luschny.de/math/swing/orbital/orbitaldoc.pdf
// --
// -----------------------------------------------------------

typedef void VISIT(int[]);

struct OrbitalGenerator
{
    private VISIT userhook;
    private int N, n, t, count;
    private bool isOdd;

    private void write(int[] jump)
    {
       string s;
       for(int j : jump) { s += (string)j + ","; }
       write(s);
    }

    private void visit(int[] jump)
    {
        count = count + 1;

        if(userhook != null)
        {
            userhook(jump);
        }
        else { this.write(jump); }
    }

    private void assemble(int[] c)
    {
        int[] q = new int[N];

        for(int i = 0; i < N; ++i){ q[i] = 1; }
        for(int i = 0; i < t; ++i){ q[N-c[i+1]-1] = -1; }

        if(isOdd)
        {
            int[] s = {0};
            for(int i = 0; i < n; ++i)
            {
                visit(concat(q[0:i],s,q[i:n]));
            }
        }
        else { visit(q); }
    }

    restricted static OrbitalGenerator
               OrbitalGenerator(int len, VISIT hook = null)
    {
        if(len > 12)
        {
            write("Error! n is too big, n <= 12 required.");
            write("I set n = 1.");
            len = 1;
        }

        OrbitalGenerator og = new OrbitalGenerator;

        bool isodd = len % 2 == 1;
        int Len = isodd ? len - 1 : len;

        og.isOdd = isodd;
        og.n = len;
        og.N = Len;
        og.t = quotient(Len, 2);
        og.count = 0;
        og.userhook = hook;

        return og;
    }

    public int generate()
    {
        int[] c = new int[t + 3];
        for(int j = 1; j <= t; ++j) { c[j] = j - 1; }
        c[t + 1] = N; c[t + 2] = 0;

        // -- Algorithm L in Donald E. Knuth TAOCP 7.2.1.3
        while(true)
        {
            assemble(c);
            int j = 1;
            while(c[j] + 1 == c[j + 1]) { c[j] = j - 1; ++j; }
            if(j > t) { break; }
            c[j] += 1 ;
        }

        return count;
    }

}   from OrbitalGenerator unravel OrbitalGenerator;


// ------------- End of struct OrbitalGenerator --------------


struct PrimeOrbital
{
    restricted int[] jumps;
    restricted int numer, denom;
    restricted real balance;

    private static int[] primes = {
            2,3,5,7,11,13,17,19,23,29,31,37,41};

    private void primorial(int[] jump)
    {
        int i = 0; numer = 1; denom = 1;

        for(int j : jump)
        {
                 if(j > 0) numer *= primes[i];
            else if(j < 0) denom *= primes[i];
            ++i;
        }
        balance = numer / denom ;
    }

    restricted static PrimeOrbital PrimeOrbital(int[] jumps)
    {
        PrimeOrbital o = new PrimeOrbital;
        o.jumps = jumps;
        o.primorial(jumps);
        return o;
    }

    public void write()
    {
       string s;
       for(int j : jumps) { s += (string)j + " " ; }

       string p = " ["+(string)numer+ "/" +(string)denom+"] "
                 +" "+format("%.3g", balance);

       write(s + p);
    }

}   from PrimeOrbital unravel PrimeOrbital;


// --------------- End of struct PrimeOrbital ----------------


struct PrimeOrbitalGenerator
{
    private PrimeOrbital[] urbi;
    private OrbitalGenerator og;
    private int urbI;

    private void insertOrbit(int[] jumps)
    {
        urbi[++urbI] = PrimeOrbital(jumps);
        if(urbI == 0) return;

        PrimeOrbital temp;

        for(int top = 0; top < urbI; ++top)
        {
            for(int j = top ; j >= 0; --j)
            {
                if(urbi[j].balance < urbi[j+1].balance)
                {
                    break;
                }
                temp = urbi[j];
                urbi[j] = urbi[j+1];
                urbi[j+1] = temp;
            }
        }
    }

   private void visit(int[] jumps)
    {
        insertOrbit(jumps);
    }

    restricted static PrimeOrbitalGenerator
                      PrimeOrbitalGenerator(int len)
    {
        PrimeOrbitalGenerator psog = new PrimeOrbitalGenerator;
        psog.og = OrbitalGenerator(len, psog.visit);
        return psog;
    }

    public PrimeOrbital[] generate()
    {
        urbI = -1;
        og.generate();
        return urbi;
    }

    public void write()
    {
        for(PrimeOrbital po : urbi) po.write();
    }

}   from PrimeOrbitalGenerator unravel PrimeOrbitalGenerator;


// ----------- End of struct PrimeOrbitalGenerator -----------
