;X.1 Greeting System

on *:text:!addgreet*:#: {
  if (($nick != $mid(#,2)) && ($nick != fonic_artes)) { halt }
  var %displayName = $displayName($2)
  var %file = data\Greetings\greetings_ [ $+ [ $mid(#,2) ] ] $+ .ini
  if (!$3-) {
    var %greeting = %displayName has arrived! Go follow them at http://twitch.tv/ $+ $2 $+ ! They were last seen playing @game $+ !
    writeini -n %file $2 greeting %greeting
    msg # /me - Greeting for %displayName has been added. (Greetings reset when the cast starts.)
  }
  if ($3-) {
    var %greeting = $3-
    writeini -n %file $2 greeting %greeting
    msg # /me - Custom greeting has been added for %displayName $+ . (Greetings reset when the cast starts.)
  }
}

on *:text:!editgreet*:#: {
  if (($nick != $mid(#,2)) && ($nick != fonic_artes)) { halt }
  var %displayName = $displayName($2)
  var %file = data\Greetings\greetings_ [ $+ [ $mid(#,2) ] ] $+ .ini
  var %check = $ini(%file,$2)
  if (!$2) { halt }
  if (!%check) { msg # /me - %displayName doesn't have a greeting. }
  if (!$3 && %check) {
    var %greeting = %displayName has arrived! Go follow them at http://twitch.tv/ $+ $2 $+ ! They were last seen playing @game $+ !
    writeini -n %file $2 greeting %greeting
    msg # /me - Greeting for %displayName has been changed to default. (Greetings reset when the cast starts.)
  }
  if (%check && $3-) {
    var %greeting = $3-
    writeini -n %file $2 greeting %greeting
    msg # /me - Custom greeting has been edited for %displayName $+ . (Greetings reset when the cast starts.)
  }
}

on *:text:!delgreet*:#: {
  if (($nick != $mid(#,2)) && ($nick != fonic_artes)) { halt }
  var %displayName = $displayName($2)
  var %file = data\Greetings\greetings_ [ $+ [ $mid(#,2) ] ] $+ .ini
  var %check = $ini(%file,$2)
  if (!$2) { halt }
  if (!%check) { msg # /me - %displayName doesn't exist in the database. }
  else {
    remini %file $2
    msg # /me - %displayName has been removed from the database.
  }
}

on *:text:!greet*:#: {
  if (!$2) { msg # /me - To enable greetings use <!greet on>. To disable greetings use <!greet off>. }
  if (($nick != $mid(#,2)) && ($nick != fonic_artes)) { halt }
  if ($2 == on) { 
    msg # /me - Greetings are enabled.
    unset %global. $+ $mid(#,2) 
  }
  if ($2 == off) {
    msg # /me - Greetings are disabled, un-used greetings won't trigger.
    set %global. $+ $mid(#,2) On
  } 
}
