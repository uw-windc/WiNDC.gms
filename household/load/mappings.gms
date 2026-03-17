$stitle		Single File Contains All Mappings

$eolcom !

$if "%1"=="windc" $goto windc                 ! WiNDC mappings
$if "%1"=="legacy_windc" $goto legacy_windc   ! Legacy WiNDC mappings


$abort "Mapping is not defined: %1";



$label windc




$OnText
 Correlate WiNDC labels with BEA NAICS codes. Update set names to more closely 
 correspond to their meaning.
$OffText

set g "Commodities/Goods in WiNDC"    /
    agr      ! Farms
    fof      ! Forestry, fishing, and related activities
    oil      ! Oil and gas extraction
    min      ! Mining, except oil and gas
    smn      ! Support activities for mining
    uti      ! Utilities
    con      ! Construction
    wpd      ! Wood products
    nmp      ! Nonmetallic mineral products
    pmt      ! Primary metals
    fmt      ! Fabricated metal products
    mch      ! Machinery
    cep      ! Computer and electronic products
    eec      ! Electrical equipment, appliances, and components
    mot      ! Motor vehicles, bodies and trailers, and parts
    ote      ! Other transportation equipment
    fpd      ! Furniture and related products
    mmf      ! Miscellaneous manufacturing
    fbp      ! Food and beverage and tobacco products
    tex      ! Textile mills and textile product mills
    alt      ! Apparel and leather and allied products
    ppd      ! Paper products
    pri      ! Printing and related support activities
    pet      ! Petroleum and coal products
    che      ! Chemical products
    pla      ! Plastics and rubber products
    wht      ! Wholesale trade
    mvt      ! Motor vehicle and parts dealers
    fbt      ! Food and beverage stores
    gmt      ! General merchandise stores
    ott      ! Other retail
    air      ! Air transportation
    trn      ! Rail transportation
    wtt      ! Water transportation
    trk      ! Truck transportation
    grd      ! Transit and ground passenger transportation
    pip      ! Pipeline transportation
    otr      ! Other transportation and support activities
    wrh      ! Warehousing and storage
    pub      ! Publishing industries, except internet (includes software)
    mov      ! Motion picture and sound recording industries
    brd      ! Broadcasting and telecommunications
    dat      ! Data processing, internet publishing, and other information services
    bnk      ! Federal Reserve banks, credit intermediation, and related activities
    sec      ! Securities, commodity contracts, and investments
    ins      ! Insurance carriers and related activities
    fin      ! Funds, trusts, and other financial vehicles
    hou      ! Housing
    ore      ! Other real estate
    rnt      ! Rental and leasing services and lessors of intangible assets
    leg      ! Legal services
    com      ! Computer systems design and related services
    tsv      ! Miscellaneous professional, scientific, and technical services
    man      ! Management of companies and enterprises
    adm      ! Administrative and support services
    wst      ! Waste management and remediation services
    edu      ! Educational services
    amb      ! Ambulatory health care services
    hos      ! Hospitals
    nrs      ! Nursing and residential care facilities
    soc      ! Social assistance
    art      ! Performing arts, spectator sports, museums, and related activities
    rec      ! Amusements, gambling, and recreation industries
    amd      ! Accommodation
    res      ! Food services and drinking places
    osv      ! Other services, except government
    fdd      ! Federal general government (defense)
    fnd      ! Federal general government (nondefense)
    fen      ! Federal government enterprises
    slg      ! State and local general government
    sle      ! State and local government enterprises
    /;

set map_com(com, g) Mapping from NAICS to WiNDC labels /
    111CA.agr    ! Farms
    113FF.fof    ! Forestry, fishing, and related activities
    211.oil      ! Oil and gas extraction
    212.min      ! Mining, except oil and gas
    213.smn      ! Support activities for mining
    22.uti       ! Utilities
    23.con       ! Construction
    321.wpd      ! Wood products
    327.nmp      ! Nonmetallic mineral products
    331.pmt      ! Primary metals
    332.fmt      ! Fabricated metal products
    333.mch      ! Machinery
    334.cep      ! Computer and electronic products
    335.eec      ! Electrical equipment, appliances, and components
    3361MV.mot   ! Motor vehicles, bodies and trailers, and parts
    3364OT.ote   ! Other transportation equipment
    337.fpd      ! Furniture and related products
    339.mmf      ! Miscellaneous manufacturing
    311FT.fbp    ! Food and beverage and tobacco products
    313TT.tex    ! Textile mills and textile product mills
    315AL.alt    ! Apparel and leather and allied products
    322.ppd      ! Paper products
    323.pri      ! Printing and related support activities
    324.pet      ! Petroleum and coal products
    325.che      ! Chemical products
    326.pla      ! Plastics and rubber products
    42.wht       ! Wholesale trade
    441.mvt      ! Motor vehicle and parts dealers
    445.fbt      ! Food and beverage stores
    452.gmt      ! General merchandise stores
    4A0.ott      ! Other retail
    481.air      ! Air transportation
    482.trn      ! Rail transportation
    483.wtt      ! Water transportation
    484.trk      ! Truck transportation
    485.grd      ! Transit and ground passenger transportation
    486.pip      ! Pipeline transportation
    487OS.otr    ! Other transportation and support activities
    493.wrh      ! Warehousing and storage
    511.pub      ! Publishing industries, except internet (includes software)
    512.mov      ! Motion picture and sound recording industries
    513.brd      ! Broadcasting and telecommunications
    514.dat      ! Data processing, internet publishing, and other information services
    521CI.bnk    ! Federal Reserve banks, credit intermediation, and related activities
    523.sec      ! Securities, commodity contracts, and investments
    524.ins      ! Insurance carriers and related activities
    525.fin      ! Funds, trusts, and other financial vehicles
    HS.hou       ! Housing
    ORE.ore      ! Other real estate
    532RL.rnt    ! Rental and leasing services and lessors of intangible assets
    5411.leg     ! Legal services
    5415.com     ! Computer systems design and related services
    5412OP.tsv   ! Miscellaneous professional, scientific, and technical services
    55.man       ! Management of companies and enterprises
    561.adm      ! Administrative and support services
    562.wst      ! Waste management and remediation services
    61.edu       ! Educational services
    621.amb      ! Ambulatory health care services
    622.hos      ! Hospitals
    623.nrs      ! Nursing and residential care facilities
    624.soc      ! Social assistance
    711AS.art    ! Performing arts, spectator sports, museums, and related activities
    713.rec      ! Amusements, gambling, and recreation industries
    721.amd      ! Accommodation
    722.res      ! Food services and drinking places
    81.osv       ! Other services, except government
    GFGD.fdd     ! Federal general government (defense)
    GFGN.fnd     ! Federal general government (nondefense)
    GFE.fen      ! Federal government enterprises
    GSLG.slg     ! State and local general government
    GSLE.sle     ! State and local government enterprises
/;


set s "Sectors in WiNDC"    /
    agr      ! Farms
    fof      ! Forestry, fishing, and related activities
    oil      ! Oil and gas extraction
    min      ! Mining, except oil and gas
    smn      ! Support activities for mining
    uti      ! Utilities
    con      ! Construction
    wpd      ! Wood products
    nmp      ! Nonmetallic mineral products
    pmt      ! Primary metals
    fmt      ! Fabricated metal products
    mch      ! Machinery
    cep      ! Computer and electronic products
    eec      ! Electrical equipment, appliances, and components
    mot      ! Motor vehicles, bodies and trailers, and parts
    ote      ! Other transportation equipment
    fpd      ! Furniture and related products
    mmf      ! Miscellaneous manufacturing
    fbp      ! Food and beverage and tobacco products
    tex      ! Textile mills and textile product mills
    alt      ! Apparel and leather and allied products
    ppd      ! Paper products
    pri      ! Printing and related support activities
    pet      ! Petroleum and coal products
    che      ! Chemical products
    pla      ! Plastics and rubber products
    wht      ! Wholesale trade
    mvt      ! Motor vehicle and parts dealers
    fbt      ! Food and beverage stores
    gmt      ! General merchandise stores
    ott      ! Other retail
    air      ! Air transportation
    trn      ! Rail transportation
    wtt      ! Water transportation
    trk      ! Truck transportation
    grd      ! Transit and ground passenger transportation
    pip      ! Pipeline transportation
    otr      ! Other transportation and support activities
    wrh      ! Warehousing and storage
    pub      ! Publishing industries, except internet (includes software)
    mov      ! Motion picture and sound recording industries
    brd      ! Broadcasting and telecommunications
    dat      ! Data processing, internet publishing, and other information services
    bnk      ! Federal Reserve banks, credit intermediation, and related activities
    sec      ! Securities, commodity contracts, and investments
    ins      ! Insurance carriers and related activities
    fin      ! Funds, trusts, and other financial vehicles
    hou      ! Housing
    ore      ! Other real estate
    rnt      ! Rental and leasing services and lessors of intangible assets
    leg      ! Legal services
    com      ! Computer systems design and related services
    tsv      ! Miscellaneous professional, scientific, and technical services
    man      ! Management of companies and enterprises
    adm      ! Administrative and support services
    wst      ! Waste management and remediation services
    edu      ! Educational services
    amb      ! Ambulatory health care services
    hos      ! Hospitals
    nrs      ! Nursing and residential care facilities
    soc      ! Social assistance
    art      ! Performing arts, spectator sports, museums, and related activities
    rec      ! Amusements, gambling, and recreation industries
    amd      ! Accommodation
    res      ! Food services and drinking places
    osv      ! Other services, except government
    fdd      ! Federal general government (defense)
    fnd      ! Federal general government (nondefense)
    fen      ! Federal government enterprises
    slg      ! State and local general government
    sle      ! State and local government enterprises
    /;

set map_sec(sec, s) Mapping from NAICS to WiNDC labels /
    111CA.agr    ! Farms
    113FF.fof    ! Forestry, fishing, and related activities
    211.oil      ! Oil and gas extraction
    212.min      ! Mining, except oil and gas
    213.smn      ! Support activities for mining
    22.uti       ! Utilities
    23.con       ! Construction
    321.wpd      ! Wood products
    327.nmp      ! Nonmetallic mineral products
    331.pmt      ! Primary metals
    332.fmt      ! Fabricated metal products
    333.mch      ! Machinery
    334.cep      ! Computer and electronic products
    335.eec      ! Electrical equipment, appliances, and components
    3361MV.mot   ! Motor vehicles, bodies and trailers, and parts
    3364OT.ote   ! Other transportation equipment
    337.fpd      ! Furniture and related products
    339.mmf      ! Miscellaneous manufacturing
    311FT.fbp    ! Food and beverage and tobacco products
    313TT.tex    ! Textile mills and textile product mills
    315AL.alt    ! Apparel and leather and allied products
    322.ppd      ! Paper products
    323.pri      ! Printing and related support activities
    324.pet      ! Petroleum and coal products
    325.che      ! Chemical products
    326.pla      ! Plastics and rubber products
    42.wht       ! Wholesale trade
    441.mvt      ! Motor vehicle and parts dealers
    445.fbt      ! Food and beverage stores
    452.gmt      ! General merchandise stores
    4A0.ott      ! Other retail
    481.air      ! Air transportation
    482.trn      ! Rail transportation
    483.wtt      ! Water transportation
    484.trk      ! Truck transportation
    485.grd      ! Transit and ground passenger transportation
    486.pip      ! Pipeline transportation
    487OS.otr    ! Other transportation and support activities
    493.wrh      ! Warehousing and storage
    511.pub      ! Publishing industries, except internet (includes software)
    512.mov      ! Motion picture and sound recording industries
    513.brd      ! Broadcasting and telecommunications
    514.dat      ! Data processing, internet publishing, and other information services
    521CI.bnk    ! Federal Reserve banks, credit intermediation, and related activities
    523.sec      ! Securities, commodity contracts, and investments
    524.ins      ! Insurance carriers and related activities
    525.fin      ! Funds, trusts, and other financial vehicles
    HS.hou       ! Housing
    ORE.ore      ! Other real estate
    532RL.rnt    ! Rental and leasing services and lessors of intangible assets
    5411.leg     ! Legal services
    5415.com     ! Computer systems design and related services
    5412OP.tsv   ! Miscellaneous professional, scientific, and technical services
    55.man       ! Management of companies and enterprises
    561.adm      ! Administrative and support services
    562.wst      ! Waste management and remediation services
    61.edu       ! Educational services
    621.amb      ! Ambulatory health care services
    622.hos      ! Hospitals
    623.nrs      ! Nursing and residential care facilities
    624.soc      ! Social assistance
    711AS.art    ! Performing arts, spectator sports, museums, and related activities
    713.rec      ! Amusements, gambling, and recreation industries
    721.amd      ! Accommodation
    722.res      ! Food services and drinking places
    81.osv       ! Other services, except government
    GFGD.fdd     ! Federal general government (defense)
    GFGN.fnd     ! Federal general government (nondefense)
    GFE.fen      ! Federal government enterprises
    GSLG.slg     ! State and local general government
    GSLE.sle     ! State and local government enterprises
/;


set m "Margin sectors in WiNDC"  /
    trn	! Transport
    trd	! Trade
/;

set map_mar(mar, m) Mapping from NAICS to WiNDC margin sectors /
    Trans.trn   ! Transport
    Trade.trd   ! Trade
/;



set r "State Abbreviations" /
    AL
    AK
    AZ
    AR
    CA
    CO
    CT
    DC
    DE
    FL
    GA
    HI
    ID
    IL
    IN
    IA
    KS
    KY
    LA
    ME
    MD
    MA
    MI
    MN
    MS
    MO
    MT
    NE
    NV
    NH
    NJ
    NM
    NY
    NC
    ND
    OH
    OK
    OR
    PA
    RI
    SC
    SD
    TN
    TX
    UT
    VT
    VA
    WA
    WV
    WI
    WY
    /;

alias (r, q);

set map_state(state, r) Mapping from state abbrevations to states /
"Alabama".AL
"Alaska".AK
"Arizona".AZ
"Arkansas".AR
"California".CA
"Colorado".CO
"Connecticut".CT
"District_of_Columbia".DC
"Delaware".DE
"Florida".FL
"Georgia".GA
"Hawaii".HI
"Idaho".ID
"Illinois".IL
"Indiana".IN
"Iowa".IA
"Kansas".KS
"Kentucky".KY
"Louisiana".LA
"Maine".ME
"Maryland".MD
"Massachusetts".MA
"Michigan".MI
"Minnesota".MN
"Mississippi".MS
"Missouri".MO
"Montana".MT
"Nebraska".NE
"Nevada".NV
"New_Hampshire".NH
"New_Jersey".NJ
"New_Mexico".NM
"New_York".NY
"North_Carolina".NC
"North_Dakota".ND
"Ohio".OH
"Oklahoma".OK
"Oregon".OR
"Pennsylvania".PA
"Rhode_Island".RI
"South_Carolina".SC
"South_Dakota".SD
"Tennessee".TN
"Texas".TX
"Utah".UT
"Vermont".VT
"Virginia".VA
"Washington".WA
"West_Virginia".WV
"Wisconsin".WI
"Wyoming".WY
/;

set map_dest(dest, r) Mapping from state abbrevations to states /
"Alabama".AL
"Alaska".AK
"Arizona".AZ
"Arkansas".AR
"California".CA
"Colorado".CO
"Connecticut".CT
"District_of_Columbia".DC
"Delaware".DE
"Florida".FL
"Georgia".GA
"Hawaii".HI
"Idaho".ID
"Illinois".IL
"Indiana".IN
"Iowa".IA
"Kansas".KS
"Kentucky".KY
"Louisiana".LA
"Maine".ME
"Maryland".MD
"Massachusetts".MA
"Michigan".MI
"Minnesota".MN
"Mississippi".MS
"Missouri".MO
"Montana".MT
"Nebraska".NE
"Nevada".NV
"New_Hampshire".NH
"New_Jersey".NJ
"New_Mexico".NM
"New_York".NY
"North_Carolina".NC
"North_Dakota".ND
"Ohio".OH
"Oklahoma".OK
"Oregon".OR
"Pennsylvania".PA
"Rhode_Island".RI
"South_Carolina".SC
"South_Dakota".SD
"Tennessee".TN
"Texas".TX
"Utah".UT
"Vermont".VT
"Virginia".VA
"Washington".WA
"West_Virginia".WV
"Wisconsin".WI
"Wyoming".WY
/;