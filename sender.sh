#!/bin/bash

# envia pelo Telegram mensagens depositadas na pasta ./msg
# utilize o formato "<ID>-<NOME>.msg" para o nome do arquivo
# Ex. ~/bot/msg/21025096-alerta.msg


# ambiente
BOT='/home/ti/bot'
[[ ! -e $BOT/msg ]] && { mkdir $BOT/msg ; }
[[ ! -e $BOT/msg/.error/ ]] && { mkdir $BOT/msg/.error ; }
MSGS="$BOT/msg"

cd $BOT

# ID de chats (canal/grupo) do Telegram 
CANAL="-100xxxxxxxxxx"
LOG="-200xxxxxxxxxx"



# API para envio pelo Telegram
source $BOT/shellbot/ShellBot.sh 


# Inicializando o bot
ShellBot.init -t <TOKEN-TELEGRAM> --return map


# para envio de mensagem no telegram usando ShellBot
send() {

	ShellBot.sendMessage \
	--chat_id $destino \
	--text "$msg" \
	--disable_notification true \
	--parse_mode markdown
	
	unset msg
}


# para editar uma mensagem no telegram
# utilize 'echo ${return[ok]} > $BOT/senderEdit.id' para marcar sua mensagem
edit() {
	msgtmp=$( cat $BOT/senderEdit.id )

	# edita a mensagem com as opções se houver
	ShellBot.editMessageText \
	--chat_id $destino \
	--message_id $msgtmp \
	--text " $msg " \
	--parse_mode markdown
	
	unset msg msgtmp
}




# loop
while : ; do

	# seleciona o arquivo mais antigo da pasta de mensagens
	msgfile=$( ls -1t $MSGS | tail -n 1 )

	# se houver conteúdo
	[[ -n $msgfile ]] && {

		# define o destino da mensagem
		case ${msgfile%%-*} in

			'vol') destino=$VOL ;;
			'status') destino=$CANAL ;;

			# se o inicio do nome do arquivo for numérico
			# usa este número como ID de destino
			*) [[ $(echo "${msgfile%%-*}" | egrep [0-9]) ]] && { destino=${msgfile%%-*} ; } || { mv $MSGS/$msgfile $MSGS/.error/$msgfile ; } ;;
		esac


		# importa a mensagem do arquivo
		msg=$(cat $MSGS/$msgfile | sed 's/&/e/g')

		# ver no terminal
		echo ; echo "$MSGS/$msgfile" - $(date +%H:%M:%S)
		echo -e "$msg"

		( send # enviar
		
			# fazer bkp da pasta do dia
			bkp_dia="${MSGS}/.bkp_$(date +%d-%m-%Y)"
			[[ ! -e ${bkp_dia} ]] && { mkdir ${bkp_dia} ; }

			# mover mensagem da fila para pasta de bkp do dia
			[[ ${return[ok]} == 'true' ]] && { mv $MSGS/$msgfile ${bkp_dia}/${msgfile} ; echo "[LOG] backup salvo em: ${bkp_dia}" ; } || { mv $MSGS/$msgfile $MSGS/.error/$msgfile ; }
		)
	}

done
