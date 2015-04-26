CREATE OR REPLACE FUNCTION gsw_enthalpy_sso_0_p(p double precision) RETURNS double precision AS $$
	DECLARE
		db2Pa CONSTANT double precision := 1e4;
		SSO CONSTANT double precision := 35.16504;
		sqrtSSO double precision;
		v01 CONSTANT double precision :=  9.998420897506056e+2;
		v05 CONSTANT double precision := -6.698001071123802;
		v08 CONSTANT double precision := -3.988822378968490e-2;
		v12 CONSTANT double precision := -2.233269627352527e-2;
		v15 CONSTANT double precision := -1.806789763745328e-4;
		v17 CONSTANT double precision := -3.087032500374211e-7;
		v20 CONSTANT double precision :=  1.550932729220080e-10;
		v21 CONSTANT double precision :=  1.0;
		v26 CONSTANT double precision := -7.521448093615448e-3;
		v31 CONSTANT double precision := -3.303308871386421e-5;
		v36 CONSTANT double precision :=  5.419326551148740e-6;
		v37 CONSTANT double precision := -2.742185394906099e-5;
		v41 CONSTANT double precision := -1.105097577149576e-7;
		v43 CONSTANT double precision := -1.119011592875110e-10;
		v47 CONSTANT double precision := -1.200507748551599e-15;
		a0 double precision;
		a1 double precision;
		a2 double precision;
		a3 double precision;
		b0 double precision;
		b1 double precision;
		b2 double precision;
		b1sq double precision;
		sqrt_disc double precision;
		N double precision;
		M double precision;
		A double precision;
		B double precision;
		part double precision;
	BEGIN
		sqrtSSO := sqrt(SSO);
		a0 := v21 + SSO*(v26 + v36*SSO + v31*sqrtSSO);
		a1 := v37 + v41*SSO;
		a2 := v43;
		a3 := v47;
		b0 := v01 + SSO*(v05 + v08*sqrtSSO);
		b1 := 0.5*(v12 + v15*SSO);
		b2 := v17 + v20*SSO;
		b1sq := b1*b1; 
		sqrt_disc := sqrt(b1sq - b0*b2);
		N := a0 + (2*a3*b0*b1/b2 - a2*b0)/b2;
		M := a1 + (4*a3*b1sq/b2 - a3*b0 - 2*a2*b1)/b2;
		A := b1 - sqrt_disc;
		B := b1 + sqrt_disc;
		part := (N*b2 - M*b1)/(b2*(B - A));
		RETURN db2Pa*(p*(a2 - 2*a3*b1/b2 + 0.5*a3*p)/b2 + (M/(2*b2))*ln(1 + p*(2*b1 + b2*p)/b0) + part*ln(1 + (b2*p*(B - A))/(A*(B + b2*p))));
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gsw_z_from_p(p double precision, lat double precision) RETURNS double precision AS $$
	DECLARE
		gamma CONSTANT double precision := 2.26e-7;
		DEG2RAD CONSTANT double precision := pi()/180;
		X double precision;
		sin2 double precision;
		B double precision;
		A double precision;
		C double precision;
	BEGIN
		X := sin(lat*DEG2RAD);
		sin2 := X*X;
		B := 9.780327*(1.0 + (5.2792e-3 + (2.32e-5*sin2))*sin2);
		A := -0.5*gamma*B;
		C := gsw_enthalpy_sso_0_p(p);
		RETURN -2*C/(B + sqrt(B*B - 4*A*C));
	END;
$$ LANGUAGE plpgsql;
