/*get death counts by month in Stata*/
version 13.1
local dir1 = "P:\Evan\Spatial\Large programme\#7COVID19\data-ONSdeaths_monthly\raw\"
local dir2 = "P:\Evan\Spatial\Large programme\#7COVID19\data-ONSdeaths_monthly\"
cd "`dir2'"
set more off
tempfile temp
*capture erase lsoa2011_females_by_year.dta
*capture erase lsoa2011_males_by_year.dta
set excelxlsxlargefile on

/*loop for years 2006 to 2010*/
local yr=5
foreach file in publishedoutput200tcm772274163 publishedoutput200tcm772274233 ///
publishedoutput200tcm772274292 publishedoutput200tcm772274362 publishedoutputfeb021tcm772274383 {
	local yr=`yr'+1
	qui import excel "`dir1'\`file'.xls", sheet("Figures for `=2000+`yr''") cellrange(A3) firstrow clear
	local str=string(`yr',"%02.0f")
	qui drop if Jan`str'==.
	rename AreaCodes Code
	rename B GOR
	label var GOR "Government Office Regions"
	rename C UA
	label var UA "Unitary authorities"
	rename D CD
	label var CD "Counties and districts"
	foreach x of varlist Code GOR UA CD {
		qui replace `x'=trim(`x')	
		qui replace `x'=subinstr(`x',"'","’",.)
	}		
	qui drop if upper(GOR)=="ENGLAND AND WALES"
	qui drop if upper(GOR)=="ENGLAND"
	qui drop if strpos(upper(GOR),"TOTAL REG")>0	
	//mistakes, sometimes regions in the wrong cellrange
	foreach x in A B C D E F G H J K 924 {
		qui replace GOR=UA if Code=="`x'" & GOR==""
		qui replace UA=GOR if Code=="`x'" & UA==""
	}
	qui replace GOR = GOR[_n-1] if missing(GOR) & Code!=""
	qui replace UA = UA[_n-1] if missing(UA) & Code!=""
	qui replace CD=UA if CD=="" & GOR=="WALES"
	qui replace UA="" if GOR=="WALES"
	qui drop if inlist(Code,"A","B","C","D","E")
	qui drop if inlist(Code,"F","G","H","J","K","924")
	//non-residents
	foreach x of varlist UA CD {
		qui replace GOR=`x' if strpos(`x',"Non-residents")>0
		qui replace `x'="" if strpos(`x',"Non-residents")>0
	}
	qui replace GOR="Non-residents" if strpos(GOR,"Non-residents")>0
	***
	//correct for certain districts that have turned into UAs
	qui replace UA="County Durham" if UA=="Durham"
	foreach x in "Shropshire" "Wiltshire" "County Durham" "Northumberland" {
		qui replace UA="`x' UA" if UA=="`x'"
		qui drop if UA=="`x' UA" & CD!=""
	}
	//Cornwall and Isles of Scilly split
	qui count if UA=="Cornwall and Isles of Scilly"
	if r(N)>0 {
		qui replace UA="Cornwall UA" if UA=="Cornwall and Isles of Scilly"
		qui replace UA="Isles of Scilly UA" if CD=="Isles of Scilly"
		qui replace CD="" if UA=="Isles of Scilly UA"
		qui drop if UA=="Cornwall UA" & CD!=""	
	}
	//Bedfordshire split
	qui count if UA=="Bedfordshire"
	if r(N)>0 {
		qui replace UA="Bedford UA" if CD=="Bedford"
		qui replace CD="" if UA=="Bedford UA"
		qui replace UA="Central Bedfordshire UA" if UA=="Bedfordshire" & CD==""
		foreach x of varlist Jan* Feb* Mar* Apr* May* Jun* Jul* Aug* Sep* Oct* Nov* Dec*  {
			qui sum `x' if UA=="Bedford UA"
			qui replace `x'=`x'-r(mean) if UA=="Central Bedfordshire UA"
		}
		qui drop if UA=="Bedfordshire"	
	}
	//Cheshire split
	qui count if UA=="Cheshire"
	if r(N)>0 {
		qui replace UA="Cheshire East UA" if CD=="Congleton"
		foreach x of varlist Jan* Feb* Mar* Apr* May* Jun* Jul* Aug* Sep* Oct* Nov* Dec*  {
			qui sum `x' if inlist(CD,"Congleton","Crewe and Nantwich","Macclesfield") 
			qui replace `x'=r(sum) if UA=="Cheshire East UA"
		}
		qui replace CD="" if UA=="Cheshire East UA"
		qui replace UA="Cheshire West and Chester UA" if CD=="Chester"
		foreach x of varlist Jan* Feb* Mar* Apr* May* Jun* Jul* Aug* Sep* Oct* Nov* Dec*  {
			qui sum `x' if inlist(CD,"Chester","Ellesmere Port & Neston","Vale Royal") 
			qui replace `x'=r(sum) if UA=="Cheshire West and Chester UA"
		}		
		qui replace CD="" if UA=="Cheshire West and Chester UA"
		qui drop if UA=="Cheshire"	
	}	
	
	***
	qui drop if CD!="" & strpos(UA," UA")>0
	qui drop if CD=="" & strpos(UA," UA")==0 & strpos(GOR,"Non-residents")==0
	local cntr=0
	foreach x in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec {
		local cntr=`cntr'+1
		rename `x'`str' deaths`cntr'
		capture destring deaths`cntr', replace ignore("-")
		
	}
	reshape long deaths, i(Code GOR UA CD) j(month)
	label var month "Month"
	rename deaths deaths`=2000+`yr''
	//correct WALES CD strings
	qui split CD,p(" / ") generate(tvar)
	qui replace CD=tvar1
	qui drop tvar*
	//correct for footnotes with and wihtout commas
	forvalues i=0(1)30 {
		foreach x of varlist GOR UA CD {
			qui replace `x'=subinstr(`x',"`i'","",.)
			qui replace `x'=subinstr(`x',"`i',","",.)
		}
	}
	//trim again
	foreach x of varlist Code GOR UA CD {
		qui replace `x'=trim(`x')	
	}
	qui drop if CD=="" & strpos(UA,"UA")==0 & strpos(GOR,"Non-residents")==0
	qui compress
	capture save `temp'
	if _rc!=0 {
		qui merge 1:1 GOR UA CD month using `temp'
		qui tab _merge
		if r(r)>1 {
			di as error "Year `=2000+`yr'' doesn't merge fully with the previous years"
			error
		}
		else {
			qui drop _merge
		}
		qui save `temp', replace
	}	
}

/*loop for years 2011 to 2014*/
foreach file in publishedoutput2011finaltcm772738151 publishedoutput2012finaltcm773197501 ///
publishedoutput2013finaltcm773717241 publishedoutput2014finaltcm774115982 {
	local yr=`yr'+1
	if strpos("`file'","2011")>0 {
		qui import excel "`dir1'\`file'.xls", sheet("Figures for `=2000+`yr''") cellrange(A3) firstrow clear		
	}
	else {
		qui import excel "`dir1'\`file'.xls", sheet("Figures for `=2000+`yr''") cellrange(A4) firstrow clear
	}
	capture drop P
	capture drop Q
	local str=string(`yr',"%02.0f")
	qui drop if Dec`str'==.
	capture rename Areaofusualresidence A
	rename A GOR
	label var GOR "Government Office Regions"
	rename B UA
	label var UA "Unitary authorities"
	rename C CD
	label var CD "Counties and districts"
	foreach x of varlist GOR UA CD {
		qui replace `x'=trim(`x')	
		qui replace `x'=subinstr(`x',"'","’",.)
	}		
	qui drop if upper(GOR)=="ENGLAND AND WALES"
	qui drop if upper(GOR)=="ENGLAND"
	qui drop if strpos(upper(GOR),"TOTAL REG")>0
	qui replace GOR = GOR[_n-1] if missing(GOR)
	qui replace UA = UA[_n-1] if missing(UA) & GOR==GOR[_n-1]
	//correct WALES CD strings
	qui split CD,p(" / ") generate(tvar)
	qui replace CD=tvar1
	qui drop tvar*
	//correct for footnotes with and wihtout commas
	forvalues i=0(1)30 {
		foreach x of varlist GOR UA CD {
			qui replace `x'=subinstr(`x',"`i' ,","",.)
			qui replace `x'=subinstr(`x',"`i',","",.)
			qui replace `x'=subinstr(`x',"`i'","",.)
		}
	}
	//trim again
	foreach x of varlist GOR UA CD {
		qui replace `x'=trim(`x')	
	}	
	//drop SHA aggregates
	qui drop if UA=="" & CD==""
	//older issue for Wales only	
	qui replace CD=UA if CD=="" & GOR=="WALES"
	qui replace UA="" if GOR=="WALES"
	//non-residents
	foreach x of varlist UA CD {
		qui replace GOR=`x' if strpos(`x',"Non-residents")>0
		qui replace `x'="" if strpos(`x',"Non-residents")>0
	}
	qui replace GOR="Non-residents" if strpos(GOR,"Non-residents")>0
	qui drop if CD!="" & strpos(UA," UA")>0
	qui drop if CD=="" & strpos(UA," UA")==0 & strpos(GOR,"Non-residents")==0	
	local cntr=0
	foreach x in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec {
		local cntr=`cntr'+1
		rename `x'`str' deaths`cntr'
		capture destring deaths`cntr', replace ignore("-")
		
	}
	reshape long deaths, i(GOR UA CD) j(month) 
	label var month "Month"
	rename deaths deaths`=2000+`yr''	
	foreach x of varlist GOR UA CD {
		qui replace `x'=trim(`x')	
	}
	qui drop if CD=="" & strpos(UA,"UA")==0 & strpos(GOR,"Non-residents")==0
	qui compress
	capture save `temp'
	if _rc!=0 {
		qui merge 1:1 GOR UA CD month using `temp'
		qui tab _merge
		if r(r)>1 {
			di as error "Year `=2000+`yr'' doesn't merge fully with the previous years"
			error
		}
		else {
			qui drop _merge
		}
		qui save `temp', replace
	}	
}

//make some changes to districts in Wales for future compatibility
qui replace CD="Vale of Glamorgan" if CD=="The Vale of Glamorgan"
qui save `temp', replace

/*loop for years 2015 to latest*/
foreach file in publishedoutput2015final publishedoutput2016final publishedoutputannual2017final ///
publishedannual2018 publishedoutputdecember2019 publishedoutputfebruary20202 {
	local yr=`yr'+1
	qui import excel "`dir1'\`file'.xls", sheet("Figures for `=2000+`yr''") cellrange(A4) firstrow clear
	foreach x in O P Q R S {
		capture drop `x'	
	}
	local str=string(`yr',"%02.0f")
	qui drop if B==""
	capture destring Jan`str', replace
	qui drop if Jan`str'==.
	capture rename Areaofusualresidence A
	rename A Codenew
	label var Codenew "New area codes"
	qui gen str15 GOR=""
	label var GOR "Government Office Regions"
	qui gen str15 UA=""
	label var UA "Unitary authorities"
	rename B CD
	label var CD "Counties and districts"
	foreach x of varlist GOR UA CD {
		qui replace `x'=trim(`x')	
		qui replace `x'=subinstr(`x',"'","’",.)
	}		
	qui drop if upper(CD)=="ENGLAND AND WALES"
	qui drop if upper(CD)=="ENGLAND"
	qui drop if strpos(upper(CD),"ENGLAND, WALES")>0
	order Code GOR UA CD 
	qui replace GOR=CD if strpos(Codenew,"E120000")>0 | strpos(Codenew,"W92000004")>0
	qui replace UA=CD if strpos(Codenew,"E10")>0 | strpos(Codenew,"E11")>0 | strpos(Codenew,"E13")>0
	qui replace GOR = GOR[_n-1] if missing(GOR) & Codenew!="J99000001"
	qui drop if strpos(Codenew,"E120000")>0 | strpos(Codenew,"W92000004")>0
	qui replace UA = UA[_n-1] if missing(UA) & GOR==GOR[_n-1] & (strpos(Codenew,"E07")>0 | strpos(Codenew,"E08")>0 | strpos(Codenew,"E09")>0)
	qui drop if UA==CD
	//move UAs to UA field and add UA to name
	qui replace UA=CD+" UA" if strpos(Codenew,"E06")>0
	qui replace CD="" if strpos(Codenew,"E06")>0
	//correct WALES CD strings
	qui split CD,p(" / ") generate(tvar)
	qui replace CD=tvar1
	qui drop tvar*
	//correct for footnotes with and wihtout commas
	forvalues i=0(1)30 {
		foreach x of varlist GOR UA CD {
			qui replace `x'=subinstr(`x',"`i' ,","",.)
			qui replace `x'=subinstr(`x',"`i',","",.)
			qui replace `x'=subinstr(`x',"`i'","",.)
		}
	}
	//trim again
	foreach x of varlist GOR UA CD {
		qui replace `x'=trim(`x')	
	}	
	//older issue for Wales only	
	qui replace CD=UA if CD=="" & GOR=="WALES"
	qui replace UA="" if GOR=="WALES"
	//non-residents
	foreach x of varlist UA CD {
		qui replace GOR=`x' if strpos(`x',"Non-residents")>0
		qui replace `x'="" if strpos(`x',"Non-residents")>0
	}
	qui replace GOR="Non-residents" if strpos(GOR,"Non-residents")>0
	//mistakes in text for 2018
	qui replace CD="Stevenage" if CD=="Stevege"
	qui replace CD="Blaenau Gwent" if CD=="Blaeu Gwent"
	qui replace CD="Rhondda Cynon Taff" if CD=="Rhondda Cynon Taf"
	//prefer the older version for this district
	qui replace CD="Rhondda, Cynon, Taff" if CD=="Rhondda Cynon Taff"	
	local cntr=0
	foreach x in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec {
		local cntr=`cntr'+1
		rename `x'`str' deaths`cntr'
		capture destring deaths`cntr', replace ignore("-")
	}
	reshape long deaths, i(GOR UA CD) j(month) 
	label var month "Month"
	rename deaths deaths`=2000+`yr''	
	foreach x of varlist GOR UA CD {
		qui replace `x'=trim(`x')	
	}
	qui compress
	capture save `temp'
	if _rc!=0 {
		qui merge 1:1 GOR UA CD month using `temp'
		qui tab _merge
		if r(r)>1 {
			di as error "Year `=2000+`yr'' doesn't merge fully with the previous years"
			error
		}
		else {
			qui drop _merge
		}
		qui save `temp', replace
	}	
	//in 2018 there were district changes. so make changes up to 2017 to comply
	if `yr'==17 {
		//East suffolk merge
		foreach x of varlist deaths*  {
			forvalues mnth=1(1)12 {
				qui sum `x' if inlist(CD,"Suffolk Coastal","Waveney") & month==`mnth'
				qui replace `x'=r(sum) if CD=="Suffolk Coastal" & month==`mnth'
			}
		}
		qui drop if CD=="Waveney"
		qui replace Codenew="E07000244" if CD=="Suffolk Coastal"
		qui replace CD="East Suffolk" if CD=="Suffolk Coastal"
		//West suffolk merge
		foreach x of varlist deaths*  {
			forvalues mnth=1(1)12 {
				qui sum `x' if inlist(CD,"Forest Heath","St Edmundsbury") & month==`mnth'
				qui replace `x'=r(sum) if CD=="Forest Heath" & month==`mnth'
			}
		}
		qui drop if CD=="St Edmundsbury"
		qui replace Codenew="E07000245" if CD=="Forest Heath"
		qui replace CD="West Suffolk" if CD=="Forest Heath"			
		//Shepway renamed to Folkestone and Hythe
		qui replace CD="Folkestone and Hythe" if CD=="Shepway"
		//Bournemouth, Christchurch and Poole merge
		foreach x of varlist deaths*  {
			forvalues mnth=1(1)12 {
				qui sum `x' if (inlist(UA,"Bournemouth UA","Poole UA") | CD=="Christchurch") & month==`mnth'
				qui replace `x'=r(sum) if UA=="Bournemouth UA" & month==`mnth'
			}
		}
		qui drop if CD=="Christchurch" | UA=="Poole UA"
		qui replace Codenew="E06000058" if UA=="Bournemouth UA"
		qui replace UA="Bournemouth, Christchurch and Poole UA" if UA=="Bournemouth UA"	
		//Dorset UA merge from 5 CDs (minus Christchurch)
		foreach x of varlist deaths*  {
			forvalues mnth=1(1)12 {
				qui sum `x' if UA=="Dorset" & CD!="Christchurch" & month==`mnth'
				qui replace `x'=r(sum) if CD=="East Dorset" & month==`mnth'
			}
		}	
		qui drop if inlist(CD,"North Dorset","Purbeck","West Dorset","Weymouth and Portland")
		qui replace Codenew="E06000059" if CD=="East Dorset"
		qui replace UA="Dorset UA" if CD=="East Dorset"
		qui replace CD="" if UA=="Dorset UA"
		//Somerset West and Taunton Deane merge
		foreach x of varlist deaths*  {
			forvalues mnth=1(1)12 {
				qui sum `x' if inlist(CD,"Taunton Deane","West Somerset") & month==`mnth'
				qui replace `x'=r(sum) if CD=="Taunton Deane" & month==`mnth'
			}
		}
		qui drop if CD=="West Somerset"
		qui replace Codenew="E07000246" if CD=="Taunton Deane"
		qui replace CD="Somerset West and Taunton" if CD=="Taunton Deane"			
		qui save `temp', replace
	}
}
order Code* GOR UA CD month deaths*
qui compress
save "ONSmonthly.dta", replace