;B Uptime

on *:text:!uptime*:#: {
  if (%flood_Uptime) && ($nick != $mid(#,2)) { halt }
  set -u30 %flood_Uptime On
  if ($0 == 2) {
    var %status = $startTime($2)
    var %displayName = $displayName($2)
    var %game = $followGame($2)
    if (%status == $null) {
      msg # /me - %displayName is currently offline.
    }
    else {
      msg # /me - %displayName $+ 's stream has been online with " $+ %game $+ " for $duration($calc($ctime - (%status - $timezone))) $+ !
    }
  }
  if ($0 == 1) {
    var %status = $startTime($mid(#,2))
    var %displayName = $displayName($mid(#,2))
    if (%status == $null) {
      msg # /me - %displayName is offline.
    }
    else {
      msg # /me - We've been live for $duration($calc($ctime - (%status - $timezone))) $+ !
    }
  }
}