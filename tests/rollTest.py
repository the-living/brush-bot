import math

def getSpoolDiameter(Lout):
	Ro = 9.9 #spool starting dia
	t = .17 #ribbon thickness
	pi = 3.14159265359
	Lo = 1650 #full ribbon length

	L = Lo - Lout #ribbon left on spool

	# R = math.sqrt((t*L)/pi + Ro**2) #radius of spooled ribbon

	n = ((-2 * pi * Ro) - (pi * t) + math.sqrt((2 * pi * Ro)**2 + (4 * pi * t * L))) / (2 * pi * t)

	return (Ro + n * t) * 2

print getSpoolDiameter(545)
print getSpoolDiameter(744)
print getSpoolDiameter(1035)