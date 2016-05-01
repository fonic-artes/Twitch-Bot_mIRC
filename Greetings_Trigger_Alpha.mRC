;W Greetings Trigger

on *:text:*:#: {
  var %file = data\Greetings\greetings_ [ $+ [ $mid(#,2) ] ] $+ .ini
  var %check = $ini(%file,$nick)
  var %greeting = $readini(%file,n,$nick,greeting)
  if (!%check) { halt }
  if (%greeting_ [ $+ [ $mid(#,2) ] $+ _ [ $+ [ $nick ] ] ]) { halt }
  if ((%check) && (!%global. [ $+ [ $mid(#,2) ] ])) {
    var %greet = $replace(%greeting, @game, $followGame($nick))
    set %greeting_ $+ $mid(#,2) $+ _ $+ $nick On
    msg # /me %greet
  }
}

on *:notice:*:#: {
  var %file = data\Greetings\greetings_ [ $+ [ $mid(#,2) ] ] $+ .ini
  var %check = $ini(%file,$nick)
  var %greeting = $readini(%file,n,$nick,greeting)
  if (!%check) { halt }
  if (%greeting_ [ $+ [ $mid(#,2) ] $+ _ [ $+ [ $nick ] ] ]) { halt }
  if ((%check) && (!%global. [ $+ [ $mid(#,2) ] ])) {
    var %greet = $replace(%greeting, @game, $followGame($nick))
    set %greeting_ $+ $mid(#,2) $+ _ $+ $nick On
    msg # /me %greet
  }
}
