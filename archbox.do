do http://condor.depaul.edu/jlee141/econdata/eco376/ECO376_program.do

program  unit_arima
dftest y 12
dftest dy 12
ac_pac dy
end

program arima_set 
quietly eststo a1: arima `1', arima(1,0,0)
quietly eststo a2: arima `1', arima(2,0,0)
quietly eststo a3: arima `1', arima(3,0,0)
quietly eststo a4: arima `1', arima(4,0,0)
quietly eststo a5: arima `1', arima(5,0,0)
quietly eststo m1: arima `1', arima(0,0,1)
quietly eststo m2: arima `1', arima(0,0,2)
quietly eststo m3: arima `1', arima(0,0,3)
quietly eststo m4: arima `1', arima(0,0,4)
quietly eststo m5: arima `1', arima(0,0,5)
quietly eststo a1m1: arima `1', arima(1,0,1)

esttab a1 a2 a3 a4 a5 m1 m2 m3 m4 m5 a1m1, aic bic
end


program arch_check
regr dy l.dy
/* LM test for autoregressive conditional heteroskedasticity (ARCH) */
estat archlm, lags(1/12)   

end

program arch_model
/* ARIMA  Model */
arch `1', $arima_model 
eststo a0 
predict ei, resid
gen truevar = ei^2 
label var truevar "Square of Errors from ARIMA"
predict ovar, variance
label var ovar "Variance from ARIMA"

/* ARCH(1) */
arch `1', $arima_model arch(1)
eststo arch1 
predict avar1, variance           /* Predict Variance */
label var avar1 "Variance from ARIMA-ARCH(1)"


arch `1', $arima_model arch(1/2)
eststo arch2
predict avar2, variance           /* Predict Variance */
label var avar2 "Variance from ARIMA-ARCH(2)"


quietly arch `1', $arima_model arch(1/3)
eststo arch3
predict avar3, variance           /* Predict Variance */
label var avar3 "Variance from ARIMA-ARCH(3)"


quietly arch `1', $arima_model arch(1/4)
eststo arch4
predict avar4, variance           /* Predict Variance */
label var avar4 "Variance from ARIMA-ARCH(4)"


quietly arch `1', $arima_model arch(1/5)
eststo arch5
predict avar5, variance           /* Predict Variance */
label var avar5 "Variance from ARIMA-ARCH(5)"
end

program garch_model
quietly arch `1', $arima_model arch(1) garch(1)
eststo g11
predict gvar, variance           /* Predict Variance */
label var gvar "Variance from ARIMA-GARCH"

quietly arch `1', $arima_model arch(1) tarch(1) garch(1)
eststo t11
predict tvar, variance           /* Predict Variance */
label var tvar "Variance from ARIMA-TGARCH"

quietly arch `1', $arima_model archm arch(1) garch(1)
eststo m11
predict mvar, variance           /* Predict Variance */
label var mvar "Variance from ARIMA-MGARCH"


end
