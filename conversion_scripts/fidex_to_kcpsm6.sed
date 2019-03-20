# This sed script converts the fidex assmebly instructions mnemonic to KCPSM6

s/\bRET\b/RETURN/g
s/\bCOMPC\b/COMPARECY/g
s/\bCOMP\b/COMPARE/g
s/\bTESTC\b/TESTCY/g
s/\bADDC\b/ADDCY/g
s/\bSUBC\b/SUBCY/g
s/\bROLC\b/SLA/g
s/\bRORC\b/SRA/g
s/\bLOADRET\b/LOAD&RETURN/g
s/\bRDMEM\b/FETCH/g
s/\bRDPRT\b/INPUT/g
s/\bWRPRT\b/OUTPUT/g
s/\bWRMEM\b/STORE/g


s/0x//g



