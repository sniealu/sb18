my $cellinflate     = 1;
my $globCong        = 0;
my $GPIter          = 3;
my $GDIter          = 20;
my $CongPercent     = 10;
my $InflatePercent  = 30;

my $path;
            if($cellinflate==1){
                if($globCong==1){
                    $path = "increPl-86/GP$GPIter\_GD$GDIter\_OFCongBin$CongPercent\_Inflate$InflatePercent\_GlobCong";
                }
                else{
                    $path = "increPl-86/GP$GPIter\_GD$GDIter\_OFCongBin$CongPercent\_Inflate$InflatePercent";
                }
            }
            else {
                $path = "increPl-86/GP$GPIter\_GD$GDIter\_NoCellInflate";
            }
            printf("Running %s\n",$path);
            `rm -rf $path`;
            `mkdir $path`;
            `mkdir $path/Pl`;
            `mkdir $path/CongHorz`;
            `mkdir $path/CongVert`;
            `mkdir $path/PinDens`;
            `mkdir $path/CellDens`;
            
            if($cellinflate==1){
                if($globCong==1){
                    $cmdline = "time ./rplMC_superblue18 -input superblue18.aux -legal Hybrid-CG035-86.pl -increPl -cellinflate -globCong -inflatePercent $InflatePercent -congPercent $CongPercent -gpiter $GPIter -graditer $GDIter -draw > Incre.log";
                }
                else{
                    $cmdline = "time ./rplMC_superblue18 -input superblue18.aux -legal Hybrid-CG035-86.pl -increPl -cellinflate           -inflatePercent $InflatePercent -congPercent $CongPercent -gpiter $GPIter -graditer $GDIter -draw > Incre.log";
                }
            }
            else{
                    $cmdline = "time ./rplMC_superblue18 -input superblue18.aux -legal Hybrid-CG035-86.pl -increPl                        -inflatePercent $InflatePercent -congPercent $CongPercent -gpiter $GPIter -graditer $GDIter -draw > Incre.log";
            }
            system($cmdline);

            `mv Incre.log  $path/`;
            `mv dumpGR.gr   $path/`;
            `mv dumpISPD.pl $path/`;
           
            `gnuplot *.plt`;
            `mv *CellDensity.png $path/CellDens/`;
            `mv *PinDensity.png $path/PinDens/`;
            `mv *CongHorz.png $path/CongHorz/`;
            `mv *CongVert.png $path/CongVert/`;
            `rm *.plt`;
            
            my @filePS = glob("*Pl*.ps");
            foreach $filePS ( @filePS )
            {
                $cmdline = "perl ../../convertPS.pl $filePS";
                system($cmdline);
            }
            `mv *Pl*.png  $path/Pl/`;
            `rm *.ps`;
