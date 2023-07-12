function [XCMP,cfsCMP,dimCFS] = dw2d(X)

wname = 'haar';                          
level = 2;                                
sorh = 'h';    
thrSettings = 331.750000000000110;                          
roundFLAG = true;
[coefs,sizes] = wavedec2(X,level,wname);
[XCMP,cfsCMP,dimCFS] = wdencmp('gbl',coefs,sizes, ...
    wname,level,thrSettings,sorh,1);
%if roundFLAG , XCMP = round(XCMP); end           
if isequal(class(X),'uint8') , XCMP = uint8(XCMP); end  