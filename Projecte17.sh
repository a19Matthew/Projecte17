#!/bin/bash
usage(){
cat <<EOF	
	Utilització: $0 -u nomUsuari -h direccióHost [-p port <1025-65535>] [-t]
 
	-u Nom de l'usuari (Obligatori)
	-h Direcció del host (Obligatori)
	-p El port utilitzat en un rang de 1025 - 65535. Per defecte 3306 [Opcional]
	-t [Opcional] | Comproba l'estat de la conexió pero no es conecta.

EOF
}

while getopts ":u:h:p:t" o; do
	case "${o}" in
	u)
		USUARI=$OPTARG
		;;
	h)
		HOST=$OPTARG
		;;
	p)
		PORT=$OPTARG
		if [ $PORT -lt 1024 ] || [ $PORT -gt 65535 ];then
			echo "ERROR: El port ha de ser mes gran de 1024 i menor o igual a 65535" 1>&2
			ERROR=1
		fi
		;;
	t) 
		TEST=1
		;;
	:)
		echo "ERROR: Opció -$OPTARG requereix un argument" 1>&2
		RE=$OPTARG
		ERROR=1
		;;
	\?)
		echo "ERROR: Opció invalida -$OPTARG" 1>&2
		ERROR=1
		;;
	esac
done

if [ -z $USUARI ] && [ "$RE" != "u" ]; then
	echo "ERROR: L'opció -u és obligatoria" 1>&2
	ERROR=1
fi
if [ -z $HOST ] && [ "$RE" != "h" ]; then
	echo "ERROR: L'opció -h és obligatoria" 1>&2
	ERROR=1
fi
if [ "$ERROR" == 1 ];then
	usage
	exit 1
fi
echo "USUARI: "$USUARI
echo "HOST: "$HOST
if [ -z $PORT ];then
	echo "PORT: 3306"
else
	echo "PORT: "$PORT
fi
if [ -z $TEST ];then
	echo "TEST: FALSE"
else
	echo "TEST: TRUE"
fi
