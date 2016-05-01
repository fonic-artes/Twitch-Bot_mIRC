;E Moderation Tools/Self Purging

on $*:text:/^!(sudoku|suicide|shoot)/iS:#: {
  var %opList = $read(data\Operators_List\OP_List_ [ $+ [ $mid(#,2) ] ] $+ .txt,nw,$nick)
  var %opList2 = $read(data\Operators_List\OP_List_ [ $+ [ $mid(#,2) ] ] $+ .txt,nw,$2)
  if (%timeout_ [ $+ [ $mid(#,2) ] ]) { halt }
  if ($mid($1,2) == sudoku && $nick != $mid(#,2) && !%opList) {
    var %displayName = $displayName($nick)
    set -u5 %timeout_ $+ $mid(#,2) On
    msg # .timeout $nick 1 | msg # /me - %displayName has been crushed under a mountain of numbers.
  }
  if ($mid($1,2) == suicide && $nick != $mid(#,2) && !%opList) {
    var %displayName = $displayName($nick)
    set -u5 %timeout_ $+ $mid(#,2) On
    msg # .timeout $nick 600 | msg # /me - %displayName impaled themselves on my sword. I'm sorry!
  }
  if ($mid($1,2) == shoot && $nick == %opList && $2 != %opList2) {
    var %target = $displayName($2)
    msg # .timeout $2 5 | msg # /me - %target has been shot! Send help.
  }
}

on *:TEXT:!roulette*:#: {
  var %opList = $read(data\Operators_List\OP_List_ [ $+ [ $mid(#,2) ] ] $+ .txt,nw,$nick)
  var %rand1 = $rand(1,3)
  var %rand2 = $rand(1,3)
  var %displayName = $displayName($nick)
  if (%flood.roulette. [ $+ [ $mid(#,2) ] ]) { halt }
  if ($nick == $mid(#,2)) { set -u60 %flood.roulette. $+ $mid(#,2) On | msg # /me - The gun disintegrated in %displayName $+ 's hands before they could pull the trigger. | halt }
  if (%opList) { set -u60 %flood.roulette. $+ $mid(#,2) On | msg # /me - %displayName $+ , your status magically turned all the bullets into blanks. | halt }
  if (%rand1 != %rand2) { set -u60 %flood.roulette. $+ $mid(#,2) On | msg # /me - %displayName played roulette and survived. You got lucky, punk. }
  if (%rand1 == %rand2) { 
    set -u60 %flood.roulette. $+ $mid(#,2) On | 
    msg # /me - %displayName was playing roulette and was shot, they'll be patched up in 30 seconds! :(
    msg # .timeout $nick 30
  }
}
