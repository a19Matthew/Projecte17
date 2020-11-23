#!/bin/bash

#Definim la funció que dona informació a l'usuari de la comanda.
usage(){
cat <<EOF	
	Utilització: $0 -u nomUsuari -h direccióHost [-p port <1025-65535>] [-t]
 
	-u Nom de l'usuari (Obligatori)
	-h Direcció del host (Obligatori)
	-p El port utilitzat en un rang de 1025 - 65535. Per defecte 3306 [Opcional]
	-t [Opcional] | Comproba l'estat de la conexió pero no es conecta.

EOF
}
#Iniciem el geotops amb les corresponents opcions
while getopts ":u:h:p:t" o; do
	case "${o}" in
	u)
		#Agafem el parametre de -u
		USUARI=$OPTARG
		;;
	h)
		#Agafem el parametre de -h
		HOST=$OPTARG
		;;
	p)
		#Agafem el parametre de -p
		PORT=$OPTARG
		#Si el port es menor de 1024 o major de 65535
		#igualarem ERROR a 1 per printar informació
		#mes endevant. A més li printem l'error i el
		#redirigim a stderr
		if [ $PORT -lt 1024 ] || [ $PORT -gt 65535 ];then
			echo "ERROR: El port ha de ser mes gran de 1024 i menor o igual a 65535" 1>&2
			ERROR=1
		fi
		;;
	t)
		#En cas que es doni la opció -t igualem TEST a 1
		TEST=1
		;;
	:)
		#Aquest case s'activarà quan NO passem un parametre
		#a les opcions que les necessiten.
		#També guardarem el nom de l'opció sense parametre
		#en la variable RE per donar informació mes endevant.
		echo "ERROR: Opció -$OPTARG requereix un argument" 1>&2
		RE=$OPTARG
		ERROR=1
		;;
	\?)
		#Aquest case s'activarà quan es introdueix una opció
		#que no esta contemplada per geotops.
		echo "ERROR: Opció invalida -$OPTARG" 1>&2
		ERROR=1
		;;
	esac
done

#Aquesta condició es dona si l'usuari no ha escrit
#la opció -u en la comanda.La variable RE s'utilitza
#aqui per evitar mostrar aquest error si ja se sap
#que s'ha passat aquesta opció sense parametre.
if [ -z $USUARI ] && [ "$RE" != "u" ]; then
	echo "ERROR: L'opció -u és obligatoria" 1>&2
	ERROR=1
fi
#Lo mateix que abans pero amb -h.
if [ -z $HOST ] && [ "$RE" != "h" ]; then
	echo "ERROR: L'opció -h és obligatoria" 1>&2
	ERROR=1
fi
#En cas que hagi hagut algun error, es cridarà a
#la funció usage i sortirem de l'escript amb un codi error.
if [ "$ERROR" == 1 ];then
	usage
	exit 1
fi
#Printem l'usuari introduït.
echo "USUARI: "$USUARI
#Printem el host introduït.
echo "HOST: "$HOST
#En cas que no s'hagi introduït el port, es printa el 3306.
if [ -z $PORT ];then
	echo "PORT: 3306"
#Si s'ha introduït, es printarà el port corresponent
else
	echo "PORT: "$PORT
fi
#Es printarà true or false en funció de si s'ha posat la opció -t
if [ -z $TEST ];then
	echo "TEST: FALSE"
else
	echo "TEST: TRUE"
fi
