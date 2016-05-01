;G Follow & Raid

on $*:text:/^!(follow|raider|caster)/iS:#: {
  var %opList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  var %displayName = $followName($2)
  var %gamePlayed = $followGame($2)
  if (%flood_Caster_ [ $+ [ $mid(#,2) ] ] ) && ($nick != $mid(#,2)) { halt }
  set -u5 %flood_Caster_ $+ $mid(#,2) On
  if (!%opList) { halt }
  if (!$2) { halt }
  if (!%displayName) { msg # /me - Check the name, it may not be spelled right. }
  if (!%gamePlayed) { msg # /me - Go follow %displayName over at http://twitch.tv/ $+ $2 $+ ! They didn't have a game set. }
  if (%gamePlayed != Creative && %gamePlayed != $null) {  msg # /me - Go follow %displayName over at http://twitch.tv/ $+ $2 $+ ! They were last playing %gamePlayed $+ . }
  if (%gamePlayed == Creative) { msg # /me - Go follow %displayName over at http://twitch.tv/ $+ $2 $+ ! They were doing %gamePlayed things. }

}

on *:text:!raid*:#: {
  var %displayName = $followName($2)
  var %file = data\Current_Game\gamelist.ini
  var %response = $readini(data\Current_Game\gamelist.ini,n,#,raid)
  var %url = http://twitch.tv/ $+ $2
  if (!$mid(#,2)) { halt }
  if ($3-) { var %response = $3- | msg # /me - We are raiding %displayName over at %url $+ ! Get in there and wait for my call - %response | .timerRaidTarget 3 0 msg # %response | .timerRaidResponse 3 0 msg # %url }
  if (!%response) { msg # /me - You don't have a raid call active. To set one do !setraid <raid call>. | halt }
  if (%response && !$3-) { msg # /me - We are raiding %displayName over at %url $+ ! Get in there and wait for my call - %response | .timerRaidTarget 3 0 msg # %response | .timerRaidResponse 3 0 msg # %url }

}

on *:text:!setraid*:#: {
  var %file = data\Current_Game\gamelist.ini
  var %response = $2-
  if (!$2) { msg # /me - To set a raid call do !setraid <raid call>. If you want to change the raid call, use the same command. | halt }
  if ($2-) { msg # /me - Your raid call has been set. Bring those walls down! | writeini %file # raid %response
  }
}

on *:text:!host*:#: { 
  var %displayName = $followName($2)
  if (($nick != $mid(#,2)) && ($nick != fonic_artes)) { halt }
  if (!$2) { msg # /me - I can't host nothing, so give me a better response. DansGame | halt }
  if (!%displayName) { msg # /me - Invalid name, try again. | halt }
  if (!$targetStatus($2)) { msg # /me - Target is offline, so hosting would be kind of worthless. | halt }
  if ($targetStatus($2)) { msg # /me - We're hosting %displayName over at http://twitch.tv/ $+ $2 $+ ! Go show them some love! <3 | msg # .host $2 }
}

on *:TEXT:!game:#: { 
  if (%flood.game. [ $+ [ $mid(#,2) ] ] && $nick != $mid(#,2)) { halt }
  set -u5 %flood.game. $+ $mid(#,2) On
  msg # /me - Game: $streamGame($mid(#,2))
}

on $*:text:/^!(title|status)/iS:#: { 
  if (%flood.status. [ $+ [ $mid(#,2) ] ] && $nick != $mid(#,2)) { halt }
  set -u5 %flood.status. $+ $mid(#,2) On
  msg # /me - Title: $streamTitle($mid(#,2))
}

on *:text:!twitter*:#: {
  if ($nick != $mid(#,2)) { halt }
  var %file = data\Current_Game\gamelist.ini
  var %handle = $readini(%file,n,#,twitter)
  if (!$2 && !%handle) { msg # /me - Set a twitter handle with !twitter <@handle>. }
  if (!$2 && %handle) { msg # /me - Your twitter handle is %handle $+ . }
  if ($2 && ($chr(64) isin $2)) { writeini %file # twitter $2 | msg # /me - Twitter handle has been set. }
}
