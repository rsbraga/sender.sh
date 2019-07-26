# sender.sh

Envio simples de mensagens para Telegram, através de arquivos de texto gravados na pasta ./msg

Pra usar:
- descompacte o arquivo shellbot.zip;
- autorize executar o ShellBot.sh ( $ chmod +x .shellbot/ShellBot.sh );
- autorize executar o sender.sh ( $ chmod +x ./sender.sh );
- edit o arquivo ./sender.sh;
- altere a variável $BOT para pasta do seu ambiente;
- insira o Token do seu Bot na função "ShellBot.init -t [TOKEN-TELEGRAM] --return map";
- execute ./sender.sh

O script deve criar as pastas que precisar.

Para envio de mensagens basta criar arquivos de texto na pasta ./msg.
Sugiro utilizar o formato "[ID]-[NOME].msg" para o nome do arquivo.
  Ex. ~/bot/msg/21025096-alerta.msg
  
 ## Ex. para criar mensagens
`$ echo "Envie conteúdo de texto podendo usar as seguintes opções de formatação: *Negrito*,_Italico_,'Monospace'.
\n também é aceito para quebra de linhas" > $MSGS/2x0x5xx6-teste.msg`

_É possível editar mensagens se você souber a ID desta e grava-la no
arquivo $BOT/senderEdit.id. Este recurso ainda não está completo._



## Erros
Em caso de erro no envio o arquivo será movido para a pasta $BOT/$MSGS/.error


